import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../data/catalog.dart';
import '../data/photo_service.dart';
import '../shared/charts.dart';
import '../shared/widgets.dart';
import 'diet.dart';
import 'workout.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(this.state, {super.key});
  final AppState state;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
    child: Row(
      children: [
        const ClipOval(child: Photo('avatar', width: 105, height: 105)),
        const SizedBox(width: 28),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.name,
                style: const TextStyle(fontSize: 26),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              const Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Program'),
                      Text(
                        'Beginner',
                        style: TextStyle(color: AppColors.blue, fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time'),
                      Text(
                        '45 Days',
                        style: TextStyle(color: AppColors.blue, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.state, {super.key, this.initialTab = 0});
  final AppState state;
  final int initialTab;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int tab = widget.initialTab;
  Future<void> addPhoto() async {
    try {
      await PhotoService().pick(widget.state);
    } catch (e) {
      if (mounted) {
        notice(
          context,
          e is StateError
              ? e.message
              : 'Unable to open the photo library. Please try again.',
        );
      }
    }
  }

  void viewPhoto(Widget image, {int? personalIndex}) => showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .6,
              ),
              child: image,
            ),
            if (personalIndex != null)
              TextButton.icon(
                onPressed: () {
                  widget.state.update(
                    () => widget.state.photos.removeAt(personalIndex),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline, color: AppColors.red),
                label: const Text(
                  'Remove photo',
                  style: TextStyle(color: AppColors.red),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    ),
  );
  Widget achievement() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Achievement', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your weight', style: TextStyle(fontSize: 13)),
                  Text(
                    '${widget.state.weight.toStringAsFixed(0)} kg',
                    style: const TextStyle(fontSize: 38),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ProgressChart(
                  values: List.filled(7, widget.state.weight),
                  goal: widget.state.goalWeight,
                  compact: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      [
                        Icons.accessibility_new,
                        Icons.straighten,
                        Icons.fitness_center,
                      ][i],
                      color: const Color(0xFFEAB300),
                      size: 24,
                    ),
                    Text(
                      ['Chest', 'Waist', 'Glutes'][i],
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      ['−3 cm', '−6 cm', '+3 cm'][i],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Monthly Training Plan',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Text(
                '${widget.state.completed.length}',
                style: const TextStyle(fontSize: 34),
              ),
              const Text('/16', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 20),
              SizedBox(
                width: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Progress', style: TextStyle(fontSize: 10)),
                    LinearProgressIndicator(
                      value: (widget.state.completed.length / 16).clamp(0, 1),
                      minHeight: 6,
                      color: const Color(0xFFFFB800),
                      backgroundColor: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Analytics', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 14),
        Row(
          children: [
            for (var i = 0; i < 2; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 0 ? 12 : 0),
                  child: ImageTile(
                    image: 'easy_start',
                    height: 105,
                    title: i == 0
                        ? 'Body Rating\n75/100'
                        : 'Workout\n${widget.state.completed.length}/16',
                    onTap: () => open(context, '/track'),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 28),
      ],
    ),
  );
  Widget photos() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: addPhoto,
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Add Photo'),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.state.photos.length + 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: .9,
          ),
          itemBuilder: (_, i) {
            final own = i < widget.state.photos.length;
            final image = own
                ? Image.memory(
                    base64Decode(widget.state.photos[i]),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, _, _) =>
                        const Center(child: Icon(Icons.broken_image_outlined)),
                  )
                : Photo('photo_${i - widget.state.photos.length + 1}');
            return InkWell(
              onTap: () => viewPhoto(image, personalIndex: own ? i : null),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    image,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black45,
                        padding: const EdgeInsets.all(7),
                        child: Text(
                          own
                              ? 'Your progress photo'
                              : 'Progress · ${['April 10', 'March 18', 'March 10', 'March 08', 'March 01', 'Feb 20'][i - widget.state.photos.length]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
  Widget favorites() {
    final savedMeals = meals
        .where((m) => widget.state.favorites.contains(m.id))
        .toList();
    final savedWorkouts = workouts
        .where((w) => widget.state.favorites.contains(w.id))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Meals'),
        if (savedMeals.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'Save recipes with the heart button.',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: savedMeals.map((m) => MealCard(widget.state, m)).toList(),
          ),
        ),
        const SectionTitle('Workout'),
        if (savedWorkouts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'Your favorite workouts will appear here.',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
        WorkoutGrid(widget.state, savedWorkouts),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: SingleChildScrollView(
      child: Column(
        children: [
          const TopBar(settings: true),
          ProfileHeader(widget.state),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => setState(() => tab = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: i == tab ? AppColors.blue : Colors.black12,
                          width: i == tab ? 3 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      ['Target', 'Photo', 'Favorite'][i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: i == tab ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          switch (tab) {
            0 => achievement(),
            1 => photos(),
            _ => favorites(),
          },
        ],
      ),
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen(this.state, {super.key});
  final AppState state;
  Future<void> choose(
    BuildContext context,
    String title,
    List<String> options,
    void Function(String) change,
  ) async {
    final value = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 25)),
          const SizedBox(height: 12),
          ...options.map(
            (v) => ListTile(
              title: Text(v),
              onTap: () => Navigator.pop(context, v),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
    if (value != null) state.update(() => change(value));
  }

  Widget section(IconData icon, String title) => Padding(
    padding: const EdgeInsets.only(top: 32),
    child: Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 22)),
          ],
        ),
        const Divider(),
      ],
    ),
  );
  Widget row(String label, VoidCallback action, {String? value}) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label, style: const TextStyle(color: Color(0xFF606060))),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null)
          Text(
            value,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        const Icon(Icons.chevron_right),
      ],
    ),
    onTap: action,
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Setting', style: TextStyle(fontSize: 34)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  section(Icons.manage_accounts_outlined, 'Account'),
                  row('Edit profile', () => open(context, '/edit-profile')),
                  row('Change password', () => open(context, '/forgot')),
                  row(
                    'Facebook',
                    () => notice(
                      context,
                      'Social sign in is not connected in this demo.',
                    ),
                  ),
                  section(Icons.notifications_none, 'Notifications'),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notifications'),
                    value: state.notifications,
                    onChanged: (v) =>
                        state.update(() => state.notifications = v),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('App notification'),
                    value: state.appNotifications,
                    onChanged: (v) =>
                        state.update(() => state.appNotifications = v),
                  ),
                  section(Icons.edit_note, 'More'),
                  row(
                    'Language',
                    () => choose(context, 'Interface language', [
                      'English',
                    ], (v) => state.language = v),
                    value: state.language,
                  ),
                  row(
                    'Country',
                    () => choose(context, 'Country', [
                      'Japan',
                      'China',
                      'United States',
                      'United Kingdom',
                    ], (v) => state.country = v),
                    value: state.country,
                  ),
                  const SizedBox(height: 42),
                  TextButton.icon(
                    onPressed: () {
                      state.logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (_) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(this.state, {super.key});
  final AppState state;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.state.name);
  late final weight = TextEditingController(
    text: widget.state.weight.toStringAsFixed(0),
  );
  late final height = TextEditingController(
    text: widget.state.height.toStringAsFixed(0),
  );
  late final phone = TextEditingController(text: widget.state.phone);
  @override
  void dispose() {
    for (final c in [name, weight, height, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget field(
    String label,
    TextEditingController c, {
    double? min,
    double? max,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: c,
      keyboardType: min != null
          ? const TextInputType.numberWithOptions(decimal: true)
          : label == 'Mobile'
          ? TextInputType.phone
          : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        if (min != null) {
          final number = double.tryParse(v);
          if (number == null ||
              !number.isFinite ||
              number < min ||
              number > max!) {
            return 'Enter $min–$max';
          }
        }
        if (label == 'Mobile' && v.replaceAll(RegExp(r'\D'), '').length < 8) {
          return 'Enter a valid mobile number';
        }
        return null;
      },
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Edit profile', style: TextStyle(fontSize: 34)),
            ),
            ProfileHeader(widget.state),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
              child: Form(
                key: form,
                child: Column(
                  children: [
                    field('Name', name),
                    field('Your weight (kg)', weight, min: 30, max: 300),
                    field('Your height (cm)', height, min: 100, max: 240),
                    field('Mobile', phone),
                    const SizedBox(height: 28),
                    ActionButton('Save Changes', () {
                      if (!form.currentState!.validate()) return;
                      widget.state.update(() {
                        widget.state.name = name.text.trim();
                        widget.state.weight = double.parse(weight.text);
                        widget.state.height = double.parse(height.text);
                        widget.state.phone = phone.text.trim();
                      });
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                      notice(context, 'Profile updated');
                    }, red: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
