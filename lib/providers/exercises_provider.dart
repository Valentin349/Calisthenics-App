import 'package:flutter/foundation.dart';

class Exercise {
  final String name;
  final String description;

  Exercise({
    required this.name,
    required this.description,
  });
}

class ExercisesProvider with ChangeNotifier {
  final List<Exercise> _exercises = [
    Exercise(name: 'Exercise 1', description: 'Description for exercise 1'),
    Exercise(name: 'Exercise 2', description: 'Description for exercise 2'),
  ];

  List<Exercise> get exercises => _exercises;

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }
}
