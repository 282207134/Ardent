import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'app_state.dart';

class PhotoService {
  final _picker = ImagePicker();
  Future<void> pick(AppState state) async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 900,
      imageQuality: 75,
      requestFullMetadata: false,
    );
    if (file != null) await _save(state, file);
  }

  Future<void> recover(AppState state) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    final result = await _picker.retrieveLostData();
    for (final file in result.files ?? <XFile>[]) {
      await _save(state, file);
    }
  }

  Future<void> _save(AppState state, XFile file) async {
    if (state.photos.length >= 5) {
      throw StateError(
        'You can save up to 5 personal photos. Remove one to add another.',
      );
    }
    final bytes = await file.readAsBytes();
    if (bytes.length > 500000) {
      throw StateError('Please choose a smaller image (under 500 KB).');
    }
    state.update(() => state.photos.insert(0, base64Encode(bytes)));
  }
}
