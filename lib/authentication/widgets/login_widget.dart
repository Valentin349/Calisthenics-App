import 'package:calisthenics_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/forgot_password_screen.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(label: Text('email')),
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(label: Text('password')),
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(
              Icons.lock_open,
              size: 32,
            ),
            label: const Text(
              'Log In',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signIn,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen())),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () => widget.onClickedSignUp(),
              child: const Text('Create Account'))
        ],
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with code: ${e.code}');
      debugPrint(e.message);

      Utils.showSnackBar(e.message);
    }

    if (mounted) Navigator.of(context).pop(context);
  }
}
