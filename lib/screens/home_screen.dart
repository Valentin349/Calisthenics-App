import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises_provider.dart';
import '../providers/workouts_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedWorkout = -1;

  @override
  Widget build(BuildContext context) {
    final workoutsProvider = Provider.of<WorkoutsProvider>(context);
    final exercisesProvider = Provider.of<ExercisesProvider>(context);
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          const Text(
            'Signed In as',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            user.email!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(
                Icons.arrow_back,
                size: 32,
              ),
              label: const Text('Sign out')),
          Expanded(
            child: ListView.builder(
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
                                    itemCount:
                                        exercisesProvider.exercises.length,
                                    itemBuilder: (context, exerciseIndex) {
                                      return ListTile(
                                        title: Text(exercisesProvider
                                            .exercises[exerciseIndex].name),
                                        subtitle: Text(exercisesProvider
                                            .exercises[exerciseIndex]
                                            .description),
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
          ),
        ],
      ),
    );
  }
}
