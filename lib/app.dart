import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme.dart';
import 'data/app_state.dart';
import 'features/auth.dart';
import 'features/onboarding.dart';
import 'features/workout.dart';
import 'features/diet.dart';
import 'features/profile.dart';

class ArdentApp extends StatelessWidget {
  const ArdentApp({super.key, required this.state, this.initialRoute});
  final AppState state;
  final String? initialRoute;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Ardent',
    debugShowCheckedModeBanner: false,
    theme: appTheme(),
    initialRoute:
        initialRoute ??
        (state.signedIn
            ? state.setupComplete
                  ? '/home'
                  : '/goal'
            : '/'),
    onGenerateInitialRoutes: (route) => [routeFor(RouteSettings(name: route))],
    onGenerateRoute: routeFor,
    builder: (_, child) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child!,
        ),
      ),
    ),
  );
  Route<void> routeFor(RouteSettings settings) => MaterialPageRoute(
    settings: settings,
    builder: (_) => ListenableBuilder(
      listenable: state,
      builder: (context, _) => Column(
        children: [
          if (state.persistenceError)
            const Material(
              color: Color(0xFFFFE9D0),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Your changes could not be saved. Please try again.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ),
          Expanded(
            child: switch (settings.name) {
              '/' => const AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: IntroScreen(),
              ),
              '/login' => AuthScreen(state, 'login'),
              '/signup' => AuthScreen(state, 'signup'),
              '/forgot' => AuthScreen(state, 'forgot'),
              '/verify' => const VerificationScreen(),
              '/goal' => SetupScreen(state, 0),
              '/details' => SetupScreen(state, 1),
              '/preferences' => SetupScreen(state, 2),
              '/home' => MainShell(state),
              '/diet' => MainShell(state, initialTab: 1),
              '/profile' => MainShell(state, initialTab: 2),
              '/profile/photos' => MainShell(
                state,
                initialTab: 2,
                profileTab: 1,
              ),
              '/profile/favorites' => MainShell(
                state,
                initialTab: 2,
                profileTab: 2,
              ),
              '/workout' => WorkoutScreen(state),
              '/workouts' => AllWorkoutsScreen(state),
              '/player' => PlayerScreen(state),
              '/tips' => const TipsScreen(),
              '/article' => const ArticleScreen(),
              '/meals' => Scaffold(body: DietScreen(state, mealsOnly: true)),
              '/recipe' => RecipeScreen(state),
              '/recipe/expanded' => RecipeScreen(state, expanded: true),
              '/cooking' => CookingScreen(state),
              '/track' => TrackScreen(state),
              '/settings' => SettingsScreen(state),
              '/edit-profile' => EditProfileScreen(state),
              _ => MainShell(state),
            },
          ),
        ],
      ),
    ),
  );
}

class MainShell extends StatefulWidget {
  const MainShell(
    this.state, {
    super.key,
    this.initialTab = 0,
    this.profileTab = 0,
  });
  final AppState state;
  final int initialTab, profileTab;
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int tab = widget.initialTab;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: tab,
      children: [
        WorkoutHome(widget.state),
        DietScreen(widget.state),
        ProfileScreen(widget.state, initialTab: widget.profileTab),
      ],
    ),
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Semantics(
                  selected: i == tab,
                  button: true,
                  child: InkWell(
                    onTap: () => setState(() => tab = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            [
                              Icons.local_fire_department_outlined,
                              Icons.restaurant_menu,
                              Icons.person_outline,
                            ][i],
                            size: 28,
                            color: i == tab ? AppColors.red : AppColors.muted,
                          ),
                          Text(
                            ['Workout', 'Recipe', 'Profile'][i],
                            style: TextStyle(
                              fontSize: 12,
                              color: i == tab ? AppColors.red : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
