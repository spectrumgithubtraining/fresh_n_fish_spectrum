import 'package:flutter/material.dart';

import '../../utils/app-constant.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appScendoryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppConstant.appScendoryColor,
        elevation: 0,
      ),
    );
  }
}
