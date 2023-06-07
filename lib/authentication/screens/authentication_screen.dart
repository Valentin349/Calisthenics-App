import 'package:calisthenics_app/authentication/widgets/login_widget.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/signup_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedLogin: toggle);

  void toggle() => setState(
        () => isLogin = !isLogin,
      );
}
