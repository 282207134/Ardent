import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../shared/widgets.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final controller = PageController();
  int page = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        PageView(
          controller: controller,
          onPageChanged: (i) => setState(() => page = i),
          children: List.generate(
            3,
            (i) => Stack(
              fit: StackFit.expand,
              children: [
                Photo('intro_${i + 1}'),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x99000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 116,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ['Get started', 'Diets', 'Body-part'][i],
                        style: const TextStyle(
                          fontSize: 56,
                          height: 1.1,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        [
                          'Get in better shape and embrace a lifestyle.',
                          'Best ways to lose weight is by changing your diet.',
                          'Abs, arms, shoulders, glutes and legs.',
                        ][i],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Skip', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 32,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                ...List.generate(
                  3,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i == page ? 44 : 22,
                    height: 6,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: i == page ? 1 : .55,
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  heroTag: 'intro',
                  tooltip: 'Next',
                  backgroundColor: AppColors.red,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (page < 2) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  child: const Icon(Icons.chevron_right, size: 38),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class SetupScreen extends StatefulWidget {
  const SetupScreen(this.state, this.step, {super.key});
  final AppState state;
  final int step;
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final form = GlobalKey<FormState>();
  late String goal = widget.state.goal;
  late String gender = widget.state.gender;
  late final age = TextEditingController(text: '${widget.state.age}');
  late final height = TextEditingController(
    text: widget.state.height.toStringAsFixed(0),
  );
  late final weight = TextEditingController(
    text: widget.state.weight.toStringAsFixed(0),
  );
  late final target = TextEditingController(
    text: widget.state.goalWeight.toStringAsFixed(0),
  );
  late final selected = Set<String>.of(widget.state.preferences);
  @override
  void dispose() {
    for (final c in [age, height, weight, target]) {
      c.dispose();
    }
    super.dispose();
  }

  void next() {
    final state = widget.state;
    if (widget.step == 1 && !form.currentState!.validate()) return;
    state.update(() {
      if (widget.step == 0) state.goal = goal;
      if (widget.step == 1) {
        state.gender = gender;
        state.age = int.parse(age.text);
        state.height = double.parse(height.text);
        state.weight = double.parse(weight.text);
        state.goalWeight = double.parse(target.text);
      }
      if (widget.step == 2) {
        state.preferences = selected;
        state.setupComplete = true;
      }
    });
    if (widget.step == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } else {
      open(context, widget.step == 0 ? '/details' : '/preferences');
    }
  }

  Widget number(
    String label,
    TextEditingController controller,
    double min,
    double max,
    String unit,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, suffixText: unit),
      validator: (v) {
        final n = double.tryParse(v ?? '');
        return n == null ||
                !n.isFinite ||
                n < min ||
                n > max ||
                (label == 'AGE' && n != n.roundToDouble())
            ? 'Enter $min–$max'
            : null;
      },
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, size) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 18, 30, 38),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.maxHeight - 56),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: AppColors.muted,
                      ),
                    ),
                    const Spacer(),
                    ...List.generate(
                      3,
                      (i) => Container(
                        width: i == widget.step ? 42 : 22,
                        height: 4,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: i == widget.step
                              ? AppColors.red
                              : Colors.black12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  [
                    'Your goal',
                    'Profile details',
                    'What do you like?',
                  ][widget.step],
                  style: TextStyle(
                    fontSize: widget.step == 2 ? 40 : 48,
                    height: 1.05,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.step == 0) ...[
                  const SizedBox(height: 48),
                  ...List.generate(3, (i) {
                    final title = [
                      'Be healthier',
                      'Lose weight',
                      'Gain weight',
                    ][i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => setState(() => goal = title),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: title == goal
                                ? AppColors.pale.withValues(alpha: .6)
                                : Colors.white,
                            border: Border.all(
                              color: title == goal
                                  ? AppColors.blue
                                  : AppColors.blue.withValues(alpha: .5),
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                title.toUpperCase(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                [
                                  'Eat and train for optimum health',
                                  'Get leaner and increase your stamina',
                                  'Build muscle strength',
                                ][i],
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
                if (widget.step == 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Form(
                      key: form,
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: gender,
                            decoration: const InputDecoration(
                              labelText: 'GENDER',
                            ),
                            items: ['Female', 'Male', 'Prefer not to say']
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => gender = v!,
                          ),
                          const SizedBox(height: 24),
                          number('AGE', age, 13, 100, 'years'),
                          number('HEIGHT', height, 100, 240, 'cm'),
                          number('WEIGHT', weight, 30, 300, 'kg'),
                          number('GOAL WEIGHT', target, 30, 300, 'kg'),
                        ],
                      ),
                    ),
                  ),
                if (widget.step == 2) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'Personalize your meals and plans',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 40),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: .88,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (context, i) {
                      final label = [
                        'Fish',
                        'Snack',
                        'Protein',
                        'Dairy',
                        'Vegetables',
                        'Fruits',
                        'Vegetarian',
                        'Vegan',
                        'Organic',
                      ][i];
                      final active = selected.contains(label);
                      return Semantics(
                        button: true,
                        selected: active,
                        child: InkWell(
                          onTap: () => setState(() {
                            if (!selected.add(label)) selected.remove(label);
                          }),
                          child: Column(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: active
                                          ? AppColors.blue
                                          : const Color(0xFFE9E9E9),
                                    ),
                                    child: Icon(
                                      [
                                        Icons.set_meal_outlined,
                                        Icons.lunch_dining_outlined,
                                        Icons.egg_outlined,
                                        Icons.local_drink_outlined,
                                        Icons.grass,
                                        Icons.apple_outlined,
                                        Icons.eco_outlined,
                                        Icons.spa_outlined,
                                        Icons.energy_savings_leaf_outlined,
                                      ][i],
                                      size: 40,
                                      color: active
                                          ? Colors.white
                                          : AppColors.ink,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                label.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 58),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: ActionButton('Next', next, red: true, arrow: true),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
