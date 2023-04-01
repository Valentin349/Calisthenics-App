import 'package:calisthenics_app/screens/home_screen.dart';
import 'package:calisthenics_app/utils.dart';
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
              return TextButtonFormWidget(
                formKey: formKey,
                textController: usernameController,
                label: 'username',
                callback: createUser,
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
