import 'package:flutter_test/flutter_test.dart';
import 'package:ardent/data/app_state.dart';
import 'package:ardent/data/catalog.dart';
import 'package:ardent/data/storage.dart';

class MemoryStorage implements AppStorage {
  Map<String, dynamic> data = {};
  bool fail = false;
  @override
  Future<Map<String, dynamic>> read() async => data;
  @override
  Future<void> write(Map<String, dynamic> value) async {
    if (fail) throw StateError('Unavailable');
    await Future<void>.delayed(const Duration(milliseconds: 1));
    data = value;
  }
}

void main() {
  test(
    'favorites, profile and session survive restoration and rapid edits',
    () async {
      final storage = MemoryStorage();
      final state = AppState(storage: storage);
      state.toggleFavorite('salad');
      state.toggleFavorite('salad');
      state.toggleFavorite('core');
      state.update(() {
        state.name = 'Alex';
        state.weight = 62;
        state.setupComplete = true;
      });
      state.signIn();
      await state.settled;
      final restored = await AppState.restore(storage);
      expect(restored.favorites, contains('core'));
      expect(restored.favorites, isNot(contains('salad')));
      expect(restored.name, 'Alex');
      expect(restored.weight, 62);
      expect(restored.signedIn, isTrue);
      restored.logout();
      await restored.settled;
      expect((await AppState.restore(storage)).signedIn, isFalse);
    },
  );
  test('meal and workout logs are idempotent and isolated by day', () {
    final state = AppState();
    state.selectDay(0);
    state.selectedMeal = meals.first;
    state.recordMeal();
    state.recordMeal();
    state.finishWorkout();
    state.finishWorkout();
    expect(state.eaten, 415);
    expect(state.burned, 38);
    state.selectDay(1);
    expect(state.eaten, 0);
    expect(state.burned, 0);
    state.selectedMeal = meals[2];
    state.recordMeal();
    expect(state.eaten, 457);
    state.selectDay(0);
    expect(state.eaten, 415);
  });
  test('a storage failure is visible and the next write can recover', () async {
    final storage = MemoryStorage()..fail = true;
    final state = AppState(storage: storage);
    state.toggleFavorite('core');
    await state.settled;
    expect(state.persistenceError, isTrue);
    storage.fail = false;
    state.toggleFavorite('abs');
    await state.settled;
    expect(state.persistenceError, isFalse);
    expect(storage.data['favorites'], contains('core'));
  });
  test(
    'invalid saved data falls back and unknown meal ids cannot break tracking',
    () async {
      final storage = MemoryStorage()..data = {'weight': 'invalid'};
      final state = await AppState.restore(storage);
      expect(state.weight, 58);
      expect(state.persistenceError, isTrue);
      final filtered = AppState(
        data: {
          'entries': {'invalid:meal': 'removed-meal'},
        },
      );
      expect(filtered.entries, isEmpty);
      expect(filtered.eaten, 0);
    },
  );
}
