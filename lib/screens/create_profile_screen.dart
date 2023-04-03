import 'package:calisthenics_app/screens/home_screen.dart';
import 'package:calisthenics_app/utils.dart';
import 'package:calisthenics_app/widgets/wheel_picker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/text_button_input_widget.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreen();
}

class _CreateProfileScreen extends State<CreateProfileScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final usernameController = TextEditingController();
  int pushUpsController = 0;
  int pullUpsController = 0;
  int dipsController = 0;
  int squatsController = 0;
  final formKey = GlobalKey<FormState>();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String userID = FirebaseAuth.instance.currentUser!.uid;
  bool isUserCreated = false;

  @override
  void dispose() {
    usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: checkUserExists(),
          builder: (context, snapshot) {
            debugPrint(snapshot.connectionState.toString());
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return Navigator(
                key: _navigatorKey,
                initialRoute: 'username',
                onGenerateRoute: _onGenerateRoute,
              );
            }
          }),
    );
  }

  Future checkUserExists() async {
    final snapshot = await users.doc(userID).get();
    if (snapshot.exists) {
      return true;
    }
    return null;
  }

  Future checkUsernameAvailable() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      final username = usernameController.text.trim();
      final query = users.where('username', isEqualTo: username);

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        return true;
      } else {
        Utils.showSnackBar('Username already taken.');
      }
    }
  }

  void createUser() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      DocumentReference userReference = users.doc(userID);
      final username = usernameController.text.trim();
      final query = users.where('username', isEqualTo: username);

      query.get().then((snapshot) => {
            if (snapshot.docs.isEmpty)
              {
                userReference
                    .set({
                      'username': username,
                      'PushUps': pushUpsController,
                      'Dips': pushUpsController,
                      'PullUps': pushUpsController,
                      'Squats': pushUpsController,
                    })
                    .then(
                      (snapshot) => {
                        setState(() {
                          isUserCreated = true;
                        }),
                        debugPrint('added user to database'),
                      },
                    )
                    .catchError(
                      (error) => {debugPrint('Failed to add user: $error')},
                    ),
              }
            else
              {
                Utils.showSnackBar('Username already taken.'),
              }
          });
    }
  }

  void _onUsernameCreated() {
    checkUsernameAvailable().then((value) => {
          if (value) {_navigatorKey.currentState!.pushNamed('pushupsPage')}
        });
  }

  void _onPushupsSelected(int index) {
    _navigatorKey.currentState!.pushNamed('dipsPage');
  }

  void _onDipsSelected(int index) {
    _navigatorKey.currentState!.pushNamed('pullupsPage');
  }

  void _onPullupsSelected(int index) {
    _navigatorKey.currentState!.pushNamed('squatsPage');
  }

  void _onSquatsSelected(int index) {
    createUser();
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case 'username':
        page = TextButtonFormWidget(
          formKey: formKey,
          textController: usernameController,
          label: 'username',
          callback: _onUsernameCreated,
        );
        break;
      case 'pushupsPage':
        page = WheelPickerWidget(
          items: const [
            '0-5',
            '5-10',
            '10-15',
            '15-20',
            '20-25',
            '25-30',
            '30+'
          ],
          titleText: 'How many pushups can you do?',
          callback: _onPushupsSelected,
          backButton: true,
        );
        break;
      case 'dipsPage':
        page = WheelPickerWidget(
          items: const [
            '0-5',
            '5-10',
            '10-15',
            '15-20',
            '20-25',
            '25-30',
            '30+'
          ],
          titleText: 'How many dips can you do?',
          callback: _onDipsSelected,
          backButton: true,
        );
        break;
      case 'pullupsPage':
        page = WheelPickerWidget(
          items: const [
            '0-5',
            '5-10',
            '10-15',
            '15-20',
            '20-25',
            '25+',
          ],
          titleText: 'How many pullups can you do?',
          callback: _onPullupsSelected,
          backButton: true,
        );
        break;
      case 'squatsPage':
        page = WheelPickerWidget(
          items: const ['0-10', '10-20', '20-30', '30-40', '40-50', '50+'],
          titleText: 'How many squats can you do?',
          callback: _onSquatsSelected,
          backButton: true,
        );
        break;
    }
    return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
