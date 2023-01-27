import 'package:flutter/foundation.dart';

class Workout {
  final String name;
  final String description;

  Workout({
    required this.name,
    required this.description,
  });
}

class WorkoutsProvider with ChangeNotifier {
  final List<Workout> _workouts = [
    Workout(name: 'Workout 1', description: 'Description for workout 1'),
    Workout(name: 'Workout 2', description: 'Description for workout 2'),
  ];

  List<Workout> get workouts => _workouts;

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }
}
