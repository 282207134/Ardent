import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/app_state.dart';
import 'data/storage.dart';
import 'data/photo_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final state = await AppState.restore(PreferencesStorage());
  try {
    await PhotoService().recover(state);
  } catch (_) {
    /* A cancelled picker must not block startup. */
  }
  runApp(ArdentApp(state: state));
}
