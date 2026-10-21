import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ardent/app.dart';
import 'package:ardent/data/app_state.dart';
import 'package:ardent/data/catalog.dart';
import 'package:ardent/data/storage.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('capture every screen and verify the main user journeys', (
    tester,
  ) async {
    var state = AppState(data: {'signedIn': true, 'setupComplete': true});
    Future<void> show(String route) async {
      await tester.pumpWidget(
        ArdentApp(key: UniqueKey(), state: state, initialRoute: route),
      );
      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(milliseconds: 180));
      await tester.pumpAndSettle();
    }

    Future<void> shot(String name) async {
      expect(tester.takeException(), isNull, reason: name);
      await binding.takeScreenshot(name);
    }

    Future<void> tapText(String text) async {
      await tester.ensureVisible(find.text(text).last);
      await tester.tap(find.text(text).last);
      await tester.pumpAndSettle();
    }

    await show('/');
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await shot('01_intro');
    await tester.tap(find.byTooltip('Next'));
    await tester.pumpAndSettle();
    await shot('02_intro_diets');
    await tester.tap(find.byTooltip('Next'));
    await tester.pumpAndSettle();
    await shot('03_intro_body');
    const screens = [
      ('/login', '04_login'),
      ('/signup', '05_signup'),
      ('/forgot', '06_forgot'),
      ('/verify', '07_verification'),
      ('/goal', '08_goal'),
      ('/details', '09_details'),
      ('/preferences', '10_preferences'),
      ('/home', '11_home'),
      ('/workout', '12_workout'),
      ('/workouts', '13_all_workouts'),
      ('/player', '14_player'),
      ('/tips', '15_tips'),
      ('/article', '16_article'),
      ('/diet', '17_diet'),
      ('/meals', '18_meals'),
      ('/recipe', '19_recipe'),
      ('/recipe/expanded', '20_recipe_expanded'),
      ('/cooking', '21_cooking'),
      ('/track', '22_track'),
      ('/profile', '23_profile'),
      ('/profile/photos', '24_photos'),
      ('/profile/favorites', '25_favorites'),
      ('/settings', '26_settings'),
      ('/edit-profile', '27_edit_profile'),
    ];
    for (final (route, name) in screens) {
      await show(route);
      await shot(name);
    }
    await show('/home');
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -1150),
    );
    await tester.pumpAndSettle();
    await shot('28_home_more');
    await show('/article');
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -650),
    );
    await tester.pumpAndSettle();
    await shot('29_article_more');
    await show('/recipe/expanded');
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -650),
    );
    await tester.pumpAndSettle();
    await shot('30_recipe_more');

    // A fresh account follows the actual onboarding routes.
    state = AppState(storage: PreferencesStorage(key: 'ardent_e2e_v1'));
    await show('/login');
    await tapText('Log in');
    expect(find.text('Your goal'), findsOneWidget);
    await tapText('Next');
    expect(find.text('Profile details'), findsOneWidget);
    await tapText('Next');
    expect(find.text('What do you like?'), findsOneWidget);
    await tapText('Next');
    expect(state.setupComplete, isTrue);

    // The timer can pause and complete, and feeds progress tracking.
    await show('/workout');
    await tapText('START');
    await tester.tap(find.byTooltip('Play'));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byTooltip('Pause'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byTooltip('Next exercise'));
      await tester.pumpAndSettle();
    }
    expect(state.burned, 38);
    await shot('31_workout_complete');

    // Recipe -> step guide -> log -> tracker, with duplicate prevention.
    state.selectedMeal = meals.first;
    await show('/recipe');
    await tapText('PLAY');
    await tapText('▶  START COOKING');
    await shot('32_cooking_step');
    await tapText('NEXT STEP');
    await tapText('NEXT STEP');
    await tapText('FINISH & LOG MEAL');
    expect(state.eaten, 415);
    await show('/track');
    await shot('33_track_recorded');
    await show('/recipe');
    await tester.tap(find.byTooltip('Add favorite'));
    await tester.pumpAndSettle();
    expect(state.favorites, contains('salad'));

    // Settings, editing and the real on-device preference store.
    await show('/settings');
    await tapText('Edit profile');
    await tester.enterText(find.byType(TextFormField).first, 'Alex Runner');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tapText('Save Changes');
    expect(state.name, 'Alex Runner');
    await state.settled;
    final restored = await AppState.restore(
      PreferencesStorage(key: 'ardent_e2e_v1'),
    );
    expect(restored.name, 'Alex Runner');
    expect(restored.eaten, 415);
    expect(restored.burned, 38);
    expect(restored.favorites, contains('salad'));
    await show('/profile');
    await tester.tap(find.text('Recipe').last);
    await tester.pumpAndSettle();
    expect(find.text('Diet'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
