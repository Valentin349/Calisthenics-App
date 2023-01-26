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
  bool _isExpanded = false;
  int _selectedWorkout = -1;

  @override
  Widget build(BuildContext context) {
    final workoutsProvider = Provider.of<WorkoutsProvider>(context);
    final exercisesProvider = Provider.of<ExercisesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(workoutsProvider.workouts[index].name),
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        _selectedWorkout = index;
                      });
                    },
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height:
                        _isExpanded && _selectedWorkout == index ? null : 0.0,
                    child: _isExpanded && _selectedWorkout == index
                        ? ListView.builder(
                            itemCount: exercisesProvider.exercises.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    exercisesProvider.exercises[index].name),
                                subtitle: Text(exercisesProvider
                                    .exercises[index].description),
                              );
                            },
                          )
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
