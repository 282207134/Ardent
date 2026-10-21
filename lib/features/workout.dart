import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../data/catalog.dart';
import '../shared/widgets.dart';

void selectWorkout(BuildContext context, AppState state, Workout workout) {
  state.selectedWorkout = workout;
  open(context, '/workout');
}

class WorkoutHome extends StatelessWidget {
  const WorkoutHome(this.state, {super.key});
  final AppState state;
  Widget horizontal(
    List<Widget> cards, {
    double height = 210,
    double width = 245,
  }) => SizedBox(
    height: height,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: cards.length,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (_, i) => SizedBox(width: width, child: cards[i]),
    ),
  );
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const PageStorageKey('workout-home'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 390,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Photo('lower_body'),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xDD000000)],
                  ),
                ),
              ),
              const SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: TopBar(white: true, back: false),
                ),
              ),
              Positioned(
                left: 22,
                right: 22,
                bottom: 30,
                child: InkWell(
                  onTap: () => selectWorkout(context, state, workouts.first),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(
                          'New',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: AppColors.blue,
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Text(
                        'Lower Body\nWorkout',
                        style: TextStyle(
                          fontSize: 52,
                          color: Colors.white,
                          height: .98,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Complete lower body workout for\nstrength and toning',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                left: 150,
                right: 150,
                child: LinearProgressIndicator(
                  value: .5,
                  minHeight: 4,
                  color: Colors.white,
                  backgroundColor: Colors.white38,
                ),
              ),
            ],
          ),
        ),
        ColoredBox(
          color: AppColors.surface,
          child: Column(
            children: [
              WeekStrip(state),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Row(
                  children: List.generate(
                    3,
                    (i) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 2 ? 26 : 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ['CARBS', 'PROTEIN', 'FAT'][i],
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              [
                                '150g of 230g',
                                '120g of 230g',
                                '90g of 300g',
                              ][i],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: [.65, .52, .3][i],
                              minHeight: 3,
                              color: AppColors.red,
                              backgroundColor: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SectionTitle("Today's Workout"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ImageTile(
            image: 'today_workout',
            title: 'For You',
            footer: '8 min.',
            height: 230,
            onTap: () => selectWorkout(context, state, workouts.first),
          ),
        ),
        const SectionTitle('Fat burning'),
        horizontal(
          [
            for (final (title, image) in [
              ('Easy Start', 'easy_start'),
              ('Bit Intense', 'intense'),
            ])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageTile(
                    image: image,
                    title: '',
                    height: 150,
                    onTap: () => selectWorkout(context, state, workouts.first),
                  ),
                  const SizedBox(height: 7),
                  Text(title),
                  const Text(
                    '5 min  |  Low',
                    style: TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
          ],
          height: 198,
          width: 255,
        ),
        SectionTitle('All Workouts', action: () => open(context, '/workouts')),
        horizontal(
          [
            for (final w in [workouts.first, workouts.last])
              ImageTile(
                image: w.image,
                title: w.id == 'lower' ? 'Glutes\nActivation' : 'Core\nWorkout',
                badge: '${w.minutes} min',
                height: 168,
                onTap: () => selectWorkout(context, state, w),
              ),
          ],
          height: 168,
          width: 217,
        ),
        const SizedBox(height: 20),
        ColoredBox(
          color: AppColors.pale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                'Workout Tips',
                action: () => open(context, '/tips'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ImageTile(
                  image: 'strength',
                  title: '',
                  height: 230,
                  onTap: () => open(context, '/article'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 4),
                child: Text(
                  'Updates: Future plan, Healthy Update,\nBusiness Talk & More',
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 26),
                child: Text(
                  'Sam S. · June 12 2019',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen(this.state, {super.key});
  final AppState state;
  @override
  Widget build(BuildContext context) {
    final w = state.selectedWorkout;
    final plan = w.plan;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 285,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Photo(w.id == 'lower' ? 'workout_detail' : w.image),
                  const SafeArea(
                    bottom: false,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: TopBar(white: true),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          w.title,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      FavoriteButton(state, w.id),
                    ],
                  ),
                  const Text(
                    'Complete your workout for\nstrength and toning',
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  StatsPanel([
                    ('Time', '${w.minutes} min'),
                    ('Intensity', w.level == 'Beginner' ? 'Low' : 'Medium'),
                    ('Calorie Burn', '35–38'),
                  ]),
                  const SizedBox(height: 16),
                  ...List.generate(plan.length, (i) {
                    final e = plan[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 12,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Photo(e.image, width: 55, height: 55),
                      ),
                      title: Text(e.name, style: const TextStyle(fontSize: 18)),
                      subtitle: Text(
                        '${e.seconds} sec',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                        ),
                      ),
                      trailing: IconButton(
                        tooltip: 'Play ${e.name}',
                        onPressed: () => open(context, '/player'),
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: AppColors.red,
                          size: 34,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  ActionButton('START', () => open(context, '/player')),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutGrid extends StatelessWidget {
  const WorkoutGrid(this.state, this.items, {super.key});
  final AppState state;
  final List<Workout> items;
  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: .78,
      crossAxisSpacing: 14,
      mainAxisSpacing: 20,
    ),
    itemBuilder: (_, i) {
      final w = items[i];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ImageTile(
                  image: w.image,
                  title: '',
                  height: double.infinity,
                  onTap: () => selectWorkout(context, state, w),
                  badge: i < 2 ? 'NEW' : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: FavoriteButton(state, w.id),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            w.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15),
          ),
          Text(
            '${w.minutes} min  |  Full body',
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      );
    },
  );
}

class AllWorkoutsScreen extends StatelessWidget {
  const AllWorkoutsScreen(this.state, {super.key});
  final AppState state;
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: Text('All Workouts', style: TextStyle(fontSize: 34)),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Beginner'),
                Tab(text: 'Skilled'),
                Tab(text: 'Master'),
              ],
            ),
            const SizedBox(height: 22),
            Expanded(
              child: TabBarView(
                children: [
                  for (final level in ['Beginner', 'Skilled', 'Master'])
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: WorkoutGrid(
                          state,
                          workouts.where((w) => w.level == level).toList(),
                        ),
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

class PlayerScreen extends StatefulWidget {
  const PlayerScreen(this.state, {super.key});
  final AppState state;
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with WidgetsBindingObserver {
  Timer? timer;
  List<Exercise> get plan => widget.state.selectedWorkout.plan;
  int index = -1, remaining = 8;
  bool playing = false, finished = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && playing) pause();
  }

  void pause() {
    timer?.cancel();
    setState(() => playing = false);
  }

  void toggle() {
    if (playing) {
      pause();
      return;
    }
    setState(() => playing = true);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining <= 1) {
        advance();
      } else {
        setState(() => remaining--);
      }
    });
  }

  void advance() {
    if (index + 1 >= plan.length) {
      timer?.cancel();
      widget.state.finishWorkout();
      setState(() {
        playing = false;
        finished = true;
        remaining = 0;
      });
      return;
    }
    setState(() {
      index++;
      remaining = plan[index].seconds;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .4,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Photo(plan[index < 0 ? 0 : index].image),
              const SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: TopBar(white: true),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  finished
                      ? 'Workout complete'
                      : index < 0
                      ? plan.first.name
                      : plan[index].name,
                  style: const TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                Text(
                  finished
                      ? '+38 kcal · Nice work!'
                      : index < 0
                      ? '15 reps'
                      : 'Exercise ${index + 1} of ${plan.length}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 32),
                Text(
                  finished
                      ? 'You did it'
                      : index < 0
                      ? 'Get ready'
                      : playing
                      ? 'Keep going'
                      : 'Paused',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 90,
                    height: 1.1,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 14),
                if (finished)
                  ActionButton('Back to workouts', () => Navigator.pop(context))
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'player',
                        tooltip: playing ? 'Pause' : 'Play',
                        backgroundColor: AppColors.blue,
                        foregroundColor: Colors.white,
                        shape: const CircleBorder(),
                        onPressed: toggle,
                        child: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        tooltip: 'Next exercise',
                        onPressed: advance,
                        icon: const Icon(
                          Icons.skip_next,
                          color: AppColors.blue,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: finished ? 1 : (index + 1) / (plan.length + 1),
                  color: AppColors.blue,
                  backgroundColor: Colors.black26,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 22),
              child: Text('Workout Tips', style: TextStyle(fontSize: 34)),
            ),
            for (final (image, title, author) in [
              (
                'strength',
                'Updates: Future plan, Healthy Update, Business Talk & More',
                'Sam S. · June 12 2019',
              ),
              ('article', tipTitle, 'Popi D. · June 06 2019'),
            ])
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageTile(
                      image: image,
                      title: '',
                      height: 225,
                      onTap: () => open(context, '/article'),
                    ),
                    const SizedBox(height: 10),
                    Text(title, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 6),
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.muted,
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

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});
  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final comments = <String>[];
  final input = TextEditingController();
  bool liked = false;
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 285,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Photo('article'),
                const SafeArea(
                  bottom: false,
                  child: Align(alignment: Alignment.topCenter, child: TopBar()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(tipTitle, style: TextStyle(fontSize: 23)),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage('assets/images/avatar.webp'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Popi D. · June 06 2019',
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Build a routine around movement you enjoy. This sample article demonstrates the reading experience from the original design.',
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explore the workout library, save your favorites and follow your progress over time. Take each session at your own pace.',
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 145,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (_, i) => SizedBox(
                      width: 125,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Photo('clean_press')),
                          Text('Clean and Press'),
                          Text(
                            '10 min | Full body',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Share this article',
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy article title',
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: tipTitle));
                        notice(context, 'Article title copied');
                      },
                      icon: const Icon(Icons.copy, color: AppColors.blue),
                    ),
                    IconButton(
                      tooltip: 'Like article',
                      onPressed: () => setState(() => liked = !liked),
                      icon: Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Text(
                  '${comments.length} Comments',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final comment in comments)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.person_outline),
                    ),
                    title: const Text('You'),
                    subtitle: Text(comment),
                  ),
                TextField(
                  controller: input,
                  decoration: const InputDecoration(
                    hintText: 'Write a comment',
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    if (input.text.trim().isEmpty) return;
                    setState(() {
                      comments.add(input.text.trim());
                      input.clear();
                    });
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text('Add comment'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
