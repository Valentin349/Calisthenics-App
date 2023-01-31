import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'providers/workouts_provider.dart';
import 'providers/exercises_provider.dart';
import 'widgets/login_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutsProvider()),
        ChangeNotifierProvider(create: (_) => ExercisesProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const HomeScreen();
                } else {
                  return LoginWidget();
                }
              }),
        ),
      ),
    );
  }
}
