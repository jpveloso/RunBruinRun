import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';
import 'package:run_bruin_run/styles/input_field_styles.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool emailNotFound = false;
  bool wrongPassword = false;

  @override
  void dispose() {
    //Release memory allocated to the fields after the page is removed
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  // Sign in the user with the email and password provided
  Future<void> _signInWithEmailAndPassword() async {
    // emailNotFound = false;
    final navigator = Navigator.of(context);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailFieldController.text,
        password: _passwordFieldController.text,
      );
      // Navigate to home screen or another authenticated screen
      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const MainMenuPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // emailNotFound = true;
        Fluttertoast.showToast(
            fontSize: 14,
            gravity: ToastGravity.CENTER,
            msg: "User with that email does not exist!",
            toastLength: Toast.LENGTH_LONG);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            fontSize: 20,
            gravity: ToastGravity.CENTER,
            msg: "Password is incorrect!",
            toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
            fontSize: 20,
            gravity: ToastGravity.CENTER,
            msg: "An error occurred. Please try again later.",
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: lightBruinBlue,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'LOGIN PAGE',
                  style: TextStyle(
                    fontSize: 30,
                    color: darkBruinBlue,
                    fontFamily: 'PressStart2P',
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 220,
                      child: Column(children: [
                        emailTextFormFieldStyle(
                            "Email",
                            "Enter your email",
                            _emailFieldController),
                        const SizedBox(height: 30),
                        passwordTextFormFieldStyle(
                            "Password",
                            "Enter your password",
                            _passwordFieldController,
                            wrongPassword ? 'Incorrect password.' : null),
                      ]),
                    ),
                    Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      children: [
                        ElevatedButton(
                            style: getButtonStyle(),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _signInWithEmailAndPassword();
                              }
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(),
                            )),
                        ElevatedButton(
                            style: getButtonStyle(),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            },
                            child: const Text('Back'))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
