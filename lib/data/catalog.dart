class Workout {
  const Workout(this.id, this.title, this.image, this.minutes, this.level);
  final String id, title, image, level;
  final int minutes;
  List<Exercise> get plan => switch (id) {
    'chest' => const [
      (name: 'Push-Up', image: 'pushup', seconds: 45),
      (name: 'Dumbbell Press', image: 'chest', seconds: 40),
      (name: 'Standing Press', image: 'clean_press', seconds: 40),
    ],
    'dumbbell' => const [
      (name: 'Bicep Curl', image: 'strength', seconds: 40),
      (name: 'Clean and Press', image: 'clean_press', seconds: 45),
      (name: 'Dumbbell Row', image: 'dumbbell', seconds: 40),
    ],
    'barre' || 'abs' || 'core' => const [
      (name: 'Side Plank', image: 'article', seconds: 35),
      (name: 'Core Hold', image: 'abs', seconds: 40),
      (name: 'Push-Up', image: 'pushup', seconds: 35),
    ],
    _ => exercises,
  };
}

class Meal {
  const Meal(
    this.id,
    this.title,
    this.image,
    this.minutes,
    this.calories,
    this.category,
  );
  final String id, title, image, category;
  final int minutes, calories;
  List<(String, String)> get items => switch (id) {
    'chicken' => const [
      ('Chicken breast', '2 pieces'),
      ('Spinach', '1 cup'),
      ('Cheese', '40 g'),
      ('Olive oil', '1 tbsp'),
      ('Garlic', '2 cloves'),
      ('Lemon', '1/2'),
      ('Pepper', 'to taste'),
    ],
    'egg' => const [
      ('Cooked chicken', '100 g'),
      ('Egg', '1'),
      ('Wholegrain bread', '2 slices'),
      ('Baby greens', '1 cup'),
      ('BBQ sauce', '1 tbsp'),
    ],
    'bowl' => const [
      ('Cooked grains', '1 cup'),
      ('Baby greens', '1 cup'),
      ('Cucumber', '1/2'),
      ('Tomatoes', '1/2 cup'),
      ('Olive oil', '1 tbsp'),
    ],
    'snack' => const [
      ('Mixed nuts', '30 g'),
      ('Baby greens', '1 cup'),
      ('Lemon juice', '1 tbsp'),
    ],
    _ => ingredients,
  };
  List<String> get steps => switch (id) {
    'chicken' => const [
      'Fill the chicken breast with spinach, cheese and minced garlic, then roll tightly.',
      'Brush with olive oil and cook thoroughly until the center reaches 74°C.',
      'Rest, slice and serve with lemon and fresh greens.',
    ],
    'egg' => const [
      'Toast the bread and add washed greens.',
      'Top with fully cooked chicken, a cooked egg and BBQ sauce.',
      'Arrange on a plate and serve immediately.',
    ],
    'bowl' => const [
      'Wash and chop the cucumber and tomatoes.',
      'Arrange cooked grains and vegetables in a bowl.',
      'Drizzle with olive oil, toss gently and serve.',
    ],
    'snack' => const [
      'Wash and dry the greens.',
      'Combine the greens and toasted nuts in a small bowl.',
      'Add lemon juice and toss gently.',
    ],
    _ => directions,
  };
  (int, int, int) get macros => switch (id) {
    'chicken' => (38, 18, 25),
    'egg' => (32, 19, 40),
    'bowl' => (12, 10, 45),
    'snack' => (6, 14, 8),
    _ => (25, 16, 80),
  };
}

typedef Exercise = ({String name, String image, int seconds});

const workouts = [
  Workout('lower', 'Lower Body Workout', 'lower_body', 5, 'Beginner'),
  Workout('dumbbell', 'Only Dumbbell', 'dumbbell', 10, 'Beginner'),
  Workout('chest', 'Chest Workout', 'chest', 12, 'Beginner'),
  Workout('barre', 'Power Barre Workout', 'barre', 10, 'Skilled'),
  Workout('abs', 'Abs and Butt Workout', 'abs', 12, 'Skilled'),
  Workout('core', 'Core Workout', 'core', 7, 'Master'),
];
const meals = [
  Meal('salad', 'Green Salad with Toasted Nuts', 'salad', 20, 415, 'Lunch'),
  Meal('chicken', 'Chicken Roulades', 'chicken', 20, 415, 'Lunch'),
  Meal('egg', 'BBQ Chicken with half boiled Egg', 'egg', 30, 457, 'Breakfast'),
  Meal('bowl', 'Fresh Garden Bowl', 'meal_3', 15, 320, 'Dinner'),
  Meal('snack', 'Toasted Nuts & Greens', 'salad', 5, 168, 'Snack'),
];
const exercises = [
  (name: 'Frog Squat', image: 'frog', seconds: 50),
  (name: 'Squat + Donkey Kick', image: 'kick', seconds: 40),
  (name: 'Sumo Squat', image: 'sumo', seconds: 40),
];
const ingredients = [
  ('Red leaf lettuce', '1 head'),
  ('Sliced English cucumber', '1 cup'),
  ('Frozen peas', '1 cup'),
  ('Grape tomatoes', '1 cup'),
  ('Garlic cloves', '2'),
  ('Red wine vinegar', '1/4 cup'),
  ('Sliced almonds, toasted', '1 cup'),
];
const directions = [
  'In a small bowl, whisk the vinegar and minced garlic. Gradually whisk in the oil until blended.',
  'In a large bowl, combine the lettuce, cucumber, peas and tomatoes.',
  'Just before serving, pour the dressing over the salad and toss to coat. Sprinkle with toasted almonds and enjoy.',
];
const tipTitle = '7 Pregnancy Ab Exercises That Are Safe For Every Trimester';
