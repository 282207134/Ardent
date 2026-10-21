"""Verify the installed Release APK through Android accessibility and cold restarts.

Run after installing the x86_64 APK: python tool/release_smoke.py [adb] [device]
Uses the app's prefilled demo account and records its salad recipe.
"""
import json
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path
from xml.etree import ElementTree

root = Path(__file__).resolve().parents[1]
adb = sys.argv[1] if len(sys.argv) > 1 else shutil.which('adb') or str(
    Path.home() / 'AppData/Local/Android/Sdk/platform-tools/adb.exe')
device = sys.argv[2] if len(sys.argv) > 2 else 'emulator-5554'

def command(*args):
    return subprocess.check_output([adb, '-s', device, *args]).decode('utf-8', errors='replace')

def screen():
    for attempt in range(3):
        result=command('shell', 'uiautomator', 'dump', '--compressed', '/sdcard/ardent-smoke.xml')
        if 'dumped to' in result:
            break
        time.sleep(1)
    else:
        raise AssertionError('Android accessibility did not return a screen')
    tree = ElementTree.fromstring(command('shell', 'cat', '/sdcard/ardent-smoke.xml'))
    nodes = [n for n in tree.iter('node') if n.get('package') == 'com.ardent.ardent']
    assert nodes, 'Ardent must be the foreground app'
    assert not any('could not be saved' in n.get('content-desc', '') for n in nodes), 'Storage error banner'
    return nodes

def matches(nodes, label):
    return [n for n in nodes if label in {n.get('text'), *n.get('content-desc', '').split('\n')}]

def tap(label):
    for attempt in range(3):
        nodes = screen()
        found = matches(nodes, label)
        if found:
            node = next((n for n in found if n.get('clickable') == 'true'), found[0])
            x1, y1, x2, y2 = map(int, re.findall(r'\d+', node.get('bounds')))
            command('shell', 'input', 'tap', str((x1+x2)//2), str((y1+y2)//2))
            return
        if attempt < 2:
            command('shell', 'input', 'swipe', '540', '1650', '540', '850', '350')
    raise AssertionError(f'Control not visible: {label}')

def restart():
    command('shell', 'am', 'force-stop', 'com.ardent.ardent')
    command('shell', 'am', 'start', '-n', 'com.ardent.ardent/.MainActivity')

command('shell', 'am', 'start', '-n', 'com.ardent.ardent/.MainActivity')
nodes = screen()
if matches(nodes, 'Skip'):
    tap('Skip')
    tap('Log in')
    tap('Next')
    tap('Next')
    tap('Next')
assert matches(screen(), "Today's Workout"), 'Home did not appear'
restart()
assert matches(screen(), "Today's Workout"), 'Session did not survive restart'
tap('Recipe')
tap('Green Salad')
tap('Log this meal')
tap('Back')
tap('Track')
assert matches(screen(), '415 kcal'), 'Recorded meal did not reach tracker'
restart()
tap('Recipe')
tap('Track')
assert matches(screen(), '415 kcal'), 'Meal record did not survive restart'
image = subprocess.check_output([adb, '-s', device, 'exec-out', 'screencap', '-p'])
(root/'docs/release-smoke.png').write_bytes(image)
(root/'docs/release_report.json').write_text(json.dumps({
    'date': '2026-10-21', 'build': 'release', 'device': device, 'result': 'passed',
    'checks': ['startup storage', 'onboarding', 'cold session restore', 'meal log', 'cold meal restore'],
}, indent=2), encoding='utf-8')
print('Release startup, onboarding, meal recording and two cold restarts passed.')
