import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_state.dart';

void open(BuildContext context, String route) =>
    Navigator.pushNamed(context, route);
void notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

class Photo extends StatelessWidget {
  const Photo(
    this.name, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });
  final String name;
  final double? height, width;
  final BoxFit fit;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.webp',
    height: height,
    width: width,
    fit: fit,
    alignment: alignment,
    filterQuality: FilterQuality.medium,
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label,
    this.onPressed, {
    super.key,
    this.red = false,
    this.arrow = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool red, arrow;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: red ? 52 : 66,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: red ? AppColors.red : AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: (red ? AppColors.red : AppColors.blue).withValues(
          alpha: .55,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(red ? 30 : 22),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: red ? 20 : 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (arrow)
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.chevron_right, size: 32),
            ),
        ],
      ),
    ),
  );
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    this.white = false,
    this.settings = false,
    this.back = true,
  });
  final bool white, settings, back;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Row(
      children: [
        if (back)
          IconButton(
            tooltip: 'Back',
            icon: Icon(
              Icons.chevron_left,
              size: 30,
              color: white ? Colors.white : AppColors.ink,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
        const Spacer(),
        IconButton(
          tooltip: settings ? 'Settings' : 'Notifications',
          onPressed: () {
            if (settings) {
              open(context, '/settings');
            } else {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (_) => const Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your activity', style: TextStyle(fontSize: 26)),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(
                          Icons.favorite_outline,
                          color: AppColors.red,
                        ),
                        title: Text('A little progress, every day.'),
                        subtitle: Text(
                          'Your next workout is ready whenever you are.',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          icon: settings
              ? const Icon(Icons.settings_outlined, size: 27)
              : Badge(
                  smallSize: 9,
                  backgroundColor: AppColors.red,
                  child: Icon(
                    Icons.notifications_none,
                    size: 29,
                    color: white ? Colors.white : AppColors.ink,
                  ),
                ),
        ),
        const SizedBox(width: 8),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.title, {
    super.key,
    this.action,
    this.label = 'view all',
  });
  final String title, label;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 22, 14, 14),
    child: Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 20))),
        if (action != null)
          TextButton(
            onPressed: action,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
      ],
    ),
  );
}

class StatsPanel extends StatelessWidget {
  const StatsPanel(this.values, {super.key});
  final List<(String, String)> values;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
    decoration: BoxDecoration(
      color: AppColors.pale,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: values
          .map(
            (v) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.$1, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 3),
                    Text(
                      v.$2,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class WeekStrip extends StatelessWidget {
  const WeekStrip(this.state, {super.key});
  final AppState state;
  @override
  Widget build(BuildContext context) {
    final start = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday % 7),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          7,
          (i) => Semantics(
            selected: state.selectedDay == i,
            button: true,
            label:
                'Select ${['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][i]}',
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => state.selectDay(i),
              child: Container(
                width: 36,
                height: 60,
                decoration: BoxDecoration(
                  color: i == state.selectedDay
                      ? AppColors.red
                      : const Color(0xFFE5E6EB),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'][i],
                      style: TextStyle(
                        fontSize: 12,
                        color: i == state.selectedDay
                            ? Colors.white
                            : AppColors.ink,
                      ),
                    ),
                    Text(
                      '${start.add(Duration(days: i)).day}',
                      style: TextStyle(
                        fontSize: 14,
                        color: i == state.selectedDay
                            ? Colors.white
                            : AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    this.height = 180,
    this.badge,
    this.footer,
  });
  final String image, title;
  final String? badge, footer;
  final double height;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: title,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Photo(image),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .72),
                    ],
                  ),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 12,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          height: 1.06,
                        ),
                      ),
                    ),
                    if (footer != null)
                      Text(
                        footer!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton(this.state, this.id, {super.key});
  final AppState state;
  final String id;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: state.favorites.contains(id) ? 'Remove favorite' : 'Add favorite',
    onPressed: () => state.toggleFavorite(id),
    icon: Icon(
      state.favorites.contains(id) ? Icons.favorite : Icons.favorite_border,
      color: AppColors.red,
      size: 29,
    ),
  );
}
