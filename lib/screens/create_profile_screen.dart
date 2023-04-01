import 'package:calisthenics_app/screens/home_screen.dart';
import 'package:calisthenics_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreen();
}

class _CreateProfileScreen extends State<CreateProfileScreen> {
  final usernameController = TextEditingController();
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
  void initState() {
    super.initState();

    checkUserExists();
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

  Future checkUserExists() async {
    final snapshot = await users.doc(userID).get();
    if (snapshot.exists) {
      setState(() {
        isUserCreated = true;
      });
    }
  }

  void createUser() {
    // TO-DO : make more efficient so user doesnt keep making database
    // real calls, can potentially retrieve all data once and check
    // local copy if username is contained
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
                      'age': 21,
                      'workouts': 1,
                    })
                    .then((snapshot) => {
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
