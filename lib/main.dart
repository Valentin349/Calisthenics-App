import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/authentication/verify_email_screen.dart';
import 'screens/authentication/authentication_screen.dart';
import 'providers/workouts_provider.dart';
import 'providers/exercises_provider.dart';
import 'utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  try {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  } catch (e) {
    debugPrint('auth error: $e');
  }

  try {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  } catch (e) {
    debugPrint('Functions error: $e');
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
        scaffoldMessengerKey: Utils.messengerKey,
        title: 'Fitness App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong!'),
                  );
                } else if (snapshot.hasData) {
                  return const VerifyEmailScreen();
                } else {
                  return const AuthenticationScreen();
                }
              }),
        ),
      ),
    );
  }
}
