import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../data/catalog.dart';
import '../shared/charts.dart';
import '../shared/widgets.dart';

void selectMeal(
  BuildContext context,
  AppState state,
  Meal meal, {
  bool expanded = true,
}) {
  state.selectedMeal = meal;
  open(context, expanded ? '/recipe/expanded' : '/recipe');
}

class MealCard extends StatelessWidget {
  const MealCard(this.state, this.meal, {super.key, this.small = false});
  final AppState state;
  final Meal meal;
  final bool small;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ImageTile(
              image: meal.image,
              title: '',
              height: small ? 110 : 178,
              onTap: () => selectMeal(context, state, meal),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: FavoriteButton(state, meal.id),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          meal.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: small ? 14 : 16),
        ),
        const SizedBox(height: 3),
        Text(
          '${meal.minutes} min  |  ${meal.calories} kCal',
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    ),
  );
}

class DietScreen extends StatefulWidget {
  const DietScreen(this.state, {super.key, this.mealsOnly = false});
  final AppState state;
  final bool mealsOnly;
  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  int category = 1;
  final carousel = PageController(viewportFraction: .7);
  @override
  void dispose() {
    carousel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = ['Breakfast', 'Lunch', 'Snack', 'Dinner'][category];
    final filtered = meals.where((m) => m.category == categoryName).toList();
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        key: PageStorageKey('diet-${widget.mealsOnly}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 18, 8),
              child: Row(
                children: [
                  Text(
                    widget.mealsOnly ? 'Meals' : 'Diet',
                    style: const TextStyle(fontSize: 34),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => open(context, '/track'),
                    child: const Text('Track'),
                  ),
                ],
              ),
            ),
            if (!widget.mealsOnly)
              ColoredBox(
                color: const Color(0xFFF3F8FA),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Text(
                        'Recipes For You',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 285,
                      child: PageView.builder(
                        controller: carousel,
                        itemCount: 3,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ImageTile(
                            image: ['salad', 'chicken', 'meal_3'][i],
                            title: [
                              'Green Salad',
                              'Chicken Roulades',
                              'Garden Bowl',
                            ][i],
                            footer: '20 min',
                            onTap: () => selectMeal(
                              context,
                              widget.state,
                              [meals[0], meals[1], meals[3]][i],
                              expanded: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            if (!widget.mealsOnly)
              SectionTitle('Meals', action: () => open(context, '/meals')),
            Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: InkWell(
                    onTap: () => setState(() => category = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: i == category
                                ? AppColors.blue
                                : Colors.black12,
                            width: i == category ? 2 : 1,
                          ),
                        ),
                      ),
                      child: Text(
                        ['Breakfast', 'Lunch', 'Snack', 'Dinner'][i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: i == category
                              ? AppColors.ink
                              : AppColors.muted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: filtered
                    .map((m) => MealCard(widget.state, m))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen(this.state, {super.key, this.expanded = false});
  final AppState state;
  final bool expanded;
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final checked = <int>{};
  @override
  Widget build(BuildContext context) {
    final meal = widget.state.selectedMeal;
    final items = meal.items;
    final steps = meal.steps;
    final macros = meal.macros;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.expanded)
                SizedBox(
                  height: 250,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Photo(meal.image),
                      const Align(
                        alignment: Alignment.topCenter,
                        child: TopBar(white: true),
                      ),
                    ],
                  ),
                )
              else
                const TopBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            meal.title,
                            style: const TextStyle(fontSize: 32, height: 1.05),
                          ),
                        ),
                        FavoriteButton(widget.state, meal.id),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${meal.minutes} min  |  ${meal.calories} kCal',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    StatsPanel([
                      ('PROTEIN', '${macros.$1} g'),
                      ('FAT', '${macros.$2} g'),
                      ('CARBS', '${macros.$3} g'),
                    ]),
                    const SizedBox(height: 24),
                    const Text('Ingredients', style: TextStyle(fontSize: 22)),
                    const SizedBox(height: 10),
                    ...List.generate(
                      items.length,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => setState(() {
                            if (!checked.add(i)) checked.remove(i);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F8FA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  checked.contains(i)
                                      ? Icons.check_circle_outline
                                      : Icons.playlist_add_check,
                                  size: 21,
                                  color: checked.contains(i)
                                      ? const Color(0xFF60CE8A)
                                      : Colors.black26,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    items[i].$1,
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: checked.contains(i)
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                                Text(
                                  items[i].$2,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.expanded) ...[
                      const SizedBox(height: 20),
                      const Text('Directions', style: TextStyle(fontSize: 22)),
                      ...List.generate(
                        steps.length,
                        (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${i + 1}. ${steps[i]}',
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    ActionButton('PLAY', () => open(context, '/cooking')),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          widget.state.recordMeal();
                          notice(
                            context,
                            'Meal added to ${widget.state.dayKey()}',
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Log this meal'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CookingScreen extends StatefulWidget {
  const CookingScreen(this.state, {super.key});
  final AppState state;
  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  int step = -1;
  List<String> get steps => widget.state.selectedMeal.steps;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Photo(widget.state.selectedMeal.image),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black26, Colors.transparent, Colors.black87],
            ),
          ),
        ),
        const SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: TopBar(white: true),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 30,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.state.selectedMeal.title,
                  style: const TextStyle(
                    fontSize: 34,
                    color: Colors.white,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${widget.state.selectedMeal.minutes} min · Recipe guide',
                  style: const TextStyle(color: Colors.white70),
                ),
                if (step >= 0) ...[
                  const SizedBox(height: 28),
                  Text(
                    'Step ${step + 1} of ${steps.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    steps[step],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.3,
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                ActionButton(
                  step < 0
                      ? '▶  START COOKING'
                      : step < steps.length - 1
                      ? 'NEXT STEP'
                      : 'FINISH & LOG MEAL',
                  () {
                    if (step < steps.length - 1) {
                      setState(() => step++);
                    } else {
                      widget.state.recordMeal();
                      Navigator.pop(context);
                      notice(context, 'Meal recorded. Enjoy!');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class TrackScreen extends StatelessWidget {
  const TrackScreen(this.state, {super.key});
  final AppState state;
  @override
  Widget build(BuildContext context) {
    final values = List.generate(
      7,
      (i) => state.entries.entries
          .where((e) => e.key.startsWith('${state.dayKey(i)}:'))
          .fold<double>(
            0,
            (sum, e) => sum + meals.firstWhere((m) => m.id == e.value).calories,
          ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Track', style: TextStyle(fontSize: 34)),
              ),
              WeekStrip(state),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.goal,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Your goal',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${state.weight.toStringAsFixed(1)} kg',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Target ${state.goalWeight.toStringAsFixed(1)} kg',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: List.generate(
                        2,
                        (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: i == 0 ? 6 : 0,
                              left: i == 1 ? 6 : 0,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  i == 0
                                      ? Icons.apple
                                      : Icons.local_fire_department,
                                  size: 44,
                                  color: i == 0
                                      ? const Color(0xFFED4E54)
                                      : const Color(0xFFFF785B),
                                ),
                                FittedBox(
                                  child: Text(
                                    '${i == 0 ? state.eaten : state.burned} kcal',
                                    style: const TextStyle(fontSize: 38),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(i == 0 ? 'Eaten' : 'Burned'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '■ Eaten    ■ Daily goal',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 12,
                            ),
                          ),
                          ProgressChart(values: values, goal: 1800),
                        ],
                      ),
                    ),
                    if (state.eaten == 0)
                      const Padding(
                        padding: EdgeInsets.only(top: 22),
                        child: Text(
                          'Log a meal to see your daily progress.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
