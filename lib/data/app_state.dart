import 'package:flutter/foundation.dart';

import 'catalog.dart';
import 'storage.dart';

class AppState extends ChangeNotifier {
  AppState({this.storage, Map<String, dynamic> data = const {}}) {
    signedIn = data['signedIn'] == true;
    setupComplete = data['setupComplete'] == true;
    name = data['name'] as String? ?? 'CHARLOTTE Up';
    phone = data['phone'] as String? ?? '+12 1234567890';
    gender = data['gender'] as String? ?? 'Female';
    age = (data['age'] as num?)?.toInt() ?? 28;
    height = (data['height'] as num?)?.toDouble() ?? 164;
    weight = (data['weight'] as num?)?.toDouble() ?? 58;
    goalWeight = (data['goalWeight'] as num?)?.toDouble() ?? 55;
    goal = data['goal'] as String? ?? 'Lose weight';
    notifications = data['notifications'] != false;
    appNotifications = data['appNotifications'] == true;
    language = data['language'] as String? ?? 'English';
    country = data['country'] as String? ?? 'Japan';
    favorites = Set<String>.from(
      data['favorites'] as List? ?? ['chicken', 'dumbbell'],
    );
    preferences = Set<String>.from(
      data['preferences'] as List? ?? ['Fruits', 'Vegetarian', 'Organic'],
    );
    completed = Set<String>.from(data['completed'] as List? ?? []);
    entries = Map<String, String>.from(data['entries'] as Map? ?? {});
    entries.removeWhere((_, value) => !meals.any((meal) => meal.id == value));
    photos = List<String>.from(data['photos'] as List? ?? []);
  }
  static Future<AppState> restore(AppStorage storage) async {
    try {
      return AppState(storage: storage, data: await storage.read());
    } catch (error) {
      debugPrint('Local state restore failed: $error');
      return AppState(storage: storage)..persistenceError = true;
    }
  }

  final AppStorage? storage;
  Future<void> _writes = Future.value();
  Future<void> get settled => _writes;
  bool persistenceError = false;
  late bool signedIn, setupComplete, notifications, appNotifications;
  late String name, phone, gender, goal, language, country;
  late int age;
  late double height, weight, goalWeight;
  late Set<String> favorites, preferences, completed;
  late Map<String, String> entries;
  late List<String> photos;
  int selectedDay = DateTime.now().weekday % 7;
  Workout selectedWorkout = workouts.first;
  Meal selectedMeal = meals.first;
  String dayKey([int? day]) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday % 7))
        .add(Duration(days: day ?? selectedDay));
    return date.toIso8601String().split('T').first;
  }

  int get eaten => entries.entries
      .where((e) => e.key.startsWith('${dayKey()}:'))
      .fold(
        0,
        (sum, e) => sum + meals.firstWhere((m) => m.id == e.value).calories,
      );
  int get burned =>
      completed.where((e) => e.startsWith('${dayKey()}:')).length * 38;
  Map<String, dynamic> toJson() => {
    'version': 1,
    'signedIn': signedIn,
    'setupComplete': setupComplete,
    'name': name,
    'phone': phone,
    'gender': gender,
    'age': age,
    'height': height,
    'weight': weight,
    'goalWeight': goalWeight,
    'goal': goal,
    'notifications': notifications,
    'appNotifications': appNotifications,
    'language': language,
    'country': country,
    'favorites': favorites.toList(),
    'preferences': preferences.toList(),
    'completed': completed.toList(),
    'entries': Map.of(entries),
    'photos': List.of(photos),
  };
  void update(VoidCallback change) {
    change();
    notifyListeners();
    final snapshot = toJson();
    _writes = _writes.then((_) async {
      try {
        await storage?.write(snapshot);
        if (persistenceError) {
          persistenceError = false;
          notifyListeners();
        }
      } catch (error) {
        debugPrint('Local state save failed: $error');
        persistenceError = true;
        notifyListeners();
      }
    });
  }

  void toggleFavorite(String id) => update(() {
    if (!favorites.add(id)) favorites.remove(id);
  });
  void recordMeal() => update(() {
    entries['${dayKey()}:${selectedMeal.id}'] = selectedMeal.id;
  });
  void finishWorkout() => update(() {
    completed.add('${dayKey()}:${selectedWorkout.id}');
  });
  void selectDay(int day) {
    selectedDay = day;
    notifyListeners();
  }

  void signIn() => update(() => signedIn = true);
  void logout() => update(() => signedIn = false);
}
