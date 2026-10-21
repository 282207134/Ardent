import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ardent/app.dart';
import 'package:ardent/data/app_state.dart';

const routes = [
  '/',
  '/login',
  '/signup',
  '/forgot',
  '/verify',
  '/goal',
  '/details',
  '/preferences',
  '/home',
  '/workout',
  '/workouts',
  '/player',
  '/tips',
  '/article',
  '/diet',
  '/meals',
  '/recipe',
  '/recipe/expanded',
  '/cooking',
  '/track',
  '/profile',
  '/profile/photos',
  '/profile/favorites',
  '/settings',
  '/edit-profile',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('SourceSans')
      ..addFont(rootBundle.load('assets/fonts/SourceSans3-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/SourceSans3-Semibold.ttf'));
    await fonts.load();
  });
  for (final width in [375.0, 320.0]) {
    testWidgets('all screens fit a $width logical pixel phone', (tester) async {
      tester.view.physicalSize = Size(width, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final route in routes) {
        await tester.pumpWidget(
          ArdentApp(key: UniqueKey(), state: AppState(), initialRoute: route),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: route);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('timer pauses, resumes and records one completed workout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = AppState();
    await tester.pumpWidget(ArdentApp(state: state, initialRoute: '/player'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Play'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:06'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('00:06'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byTooltip('Next exercise'));
      await tester.pump();
    }
    expect(find.text('Workout complete'), findsOneWidget);
    expect(state.completed.length, 1);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('login validation and setup navigation work', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = AppState();
    await tester.pumpWidget(ArdentApp(state: state, initialRoute: '/login'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.ensureVisible(find.text('Log in'));
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter Username'), findsOneWidget);
    expect(state.signedIn, isFalse);
    await tester.enterText(find.byType(TextFormField).first, 'Alex');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.ensureVisible(find.text('Log in'));
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Your goal'), findsOneWidget);
    expect(state.signedIn, isTrue);
  });
}
