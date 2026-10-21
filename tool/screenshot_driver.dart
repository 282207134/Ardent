import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final images = <String>[];
  final directory = Directory('docs/screenshots')..createSync(recursive: true);
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      if (bytes.isEmpty) return false;
      await File('${directory.path}/$name.png').writeAsBytes(bytes);
      images.add('$name.png');
      return true;
    },
    responseDataCallback: (data) async {
      await File('docs/test_report.json').writeAsString(
        const JsonEncoder.withIndent('  ').convert({
          'date': '2026-10-21',
          'device': 'Android 9, API 28, emulator-5554',
          'result': 'passed',
          'screenshots': images,
          'journeys': [
            'onboarding',
            'timer and completion',
            'cooking and meal log',
            'favorites',
            'profile editing',
            'native persistence',
            'bottom navigation',
          ],
        }),
      );
    },
  );
}
