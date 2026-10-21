"""Build the geometric Ardent A mark at the platform launcher sizes."""
import json
from pathlib import Path
from PIL import Image, ImageDraw

root = Path(__file__).resolve().parents[1]
icon = Image.new('RGB', (1024, 1024), '#D03030')
draw = ImageDraw.Draw(icon)
draw.polygon([(218, 770), (440, 238), (584, 238), (806, 770),
              (648, 770), (598, 642), (426, 642), (376, 770)], fill='white')
draw.polygon([(469, 526), (555, 526), (512, 410)], fill='#D03030')

def save(path, size):
    assert path.resolve().is_relative_to(root)
    icon.resize((size, size), Image.Resampling.LANCZOS).save(path)

for density, size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    save(root / f'android/app/src/main/res/mipmap-{density}/ic_launcher.png', size)
directory = root / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for entry in json.loads((directory / 'Contents.json').read_text())['images']:
    if 'filename' in entry:
        size = round(float(entry['size'].split('x')[0]) * float(entry['scale'].rstrip('x')))
        save(directory / entry['filename'], size)
for path in (root / 'web/icons').glob('*.png'):
    size = int(path.stem.split('-')[-1])
    save(path, size)
save(root / 'web/favicon.png', 32)
print('Android, iOS and Web launcher icons updated.')
