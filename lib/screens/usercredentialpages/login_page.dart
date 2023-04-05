import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';
import 'package:run_bruin_run/styles/input_field_styles.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';

// final emailFieldController = TextEditingController();

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

  String _errorMessage = '';

  @override
  void dispose() {
    //Release memory allocated to the fields after the page is removed
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  // Sign in the user with the email and password provided
  Future<void> _signInWithEmailAndPassword() async {
    final navigator = Navigator.of(context);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailFieldController.text.trim(),
        password: _passwordFieldController.text.trim(),
      );
      // Navigate to home screen or another authenticated screen
      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const MainMenuPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "User with email does not exist!", toastLength: Toast.LENGTH_LONG);
        _errorMessage = 'No user found with that email address.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Incorrect password.';
      } else {
        _errorMessage = 'An error occurred. Please try again later.';
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'LOGIN PAGE',
                    style: TextStyle(
                      fontSize: 35,
                      color: darkBruinBlue,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    width: 350,
                    height: 200,
                    child: Column(children: [
                      inputTextFormFieldStyle(
                          "Email",
                          "Enter your email",
                          _emailFieldController,
                          emailNotFound
                              ? 'No user found with that email address.'
                              : null),
                      const SizedBox(height: 30),
                      passwordTextFormFieldStyle(
                          "Password",
                          "Enter your password",
                          _passwordFieldController,
                          wrongPassword ? 'Incorrect password.' : null),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: [
                      ElevatedButton(
                          style: getButtonStyle(),
                          // onPressed: () {
                          //   if (_formKey.currentState!.validate()) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(content: Text('Signing in')),
                          //     );
                          //   }
                          // },
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _signInWithEmailAndPassword(); //.then((value){
                              //         Navigator.push(
                              //           context,
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //             const MainMenuPage()));
                              //  });
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
            )));
  }
}
