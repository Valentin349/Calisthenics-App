import 'package:calisthenics_app/screens/home_screen.dart';
import 'package:calisthenics_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreen();
}

class _CreateProfileScreen extends State<CreateProfileScreen> {
  //TO DO: Link auth user id to user profile so that user is not asked ot create profile every time.
  final usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isUserCreated = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isUserCreated
        ? const HomeScreen()
        : Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: usernameController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(label: Text('Username')),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 3
                        ? 'Enter min. 3 characters'
                        : null,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(
                      Icons.arrow_right_outlined,
                      size: 32,
                    ),
                    label: const Text(
                      'Next',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: createUser,
                  ),
                ],
              ),
            ),
          );
  }

  void createUser() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      DocumentReference userReference =
          users.doc(usernameController.text.trim());
      userReference.get().then((value) => {
            if (!value.exists)
              {
                userReference
                    .set({
                      'age': 21,
                      'workouts': 1,
                    })
                    .then((value) => {
                          setState(() {
                            isUserCreated = true;
                          }),
                          debugPrint('added user to database')
                        })
                    .catchError(
                        (error) => {debugPrint('Failed to add user: $error')})
              }
            else
              {Utils.showSnackBar('Username already taken.')}
          });
    }
  }
}
