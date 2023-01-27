import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises_provider.dart';
import '../providers/workouts_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedWorkout = -1;

  @override
  Widget build(BuildContext context) {
    final workoutsProvider = Provider.of<WorkoutsProvider>(context);
    final exercisesProvider = Provider.of<ExercisesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedWorkout = _selectedWorkout == index ? -1 : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _selectedWorkout == index
                  ? MediaQuery.of(context).size.height - kToolbarHeight
                  : 100,
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(workoutsProvider.workouts[index].name),
                    ),
                    _selectedWorkout == index
                        ? Flexible(
                            child: ListView.builder(
                              itemCount: exercisesProvider.exercises.length,
                              itemBuilder: (context, exerciseIndex) {
                                return ListTile(
                                  title: Text(exercisesProvider
                                      .exercises[exerciseIndex].name),
                                  subtitle: Text(exercisesProvider
                                      .exercises[exerciseIndex].description),
                                );
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
