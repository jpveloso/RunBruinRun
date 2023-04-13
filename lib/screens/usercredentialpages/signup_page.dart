import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_bruin_run/screens/usercredentialpages/login_page.dart';
import 'package:run_bruin_run/services/firestore_service.dart';
import 'package:run_bruin_run/styles/input_field_styles.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailFieldController = TextEditingController();
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _retypePasswordFieldController = TextEditingController();
  bool _checkUserName = false;
  bool _checkEmail = false;

  //final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> verifySignUp(String userName, String email) async {
    final navigator = Navigator.of(context);
    try {
      _checkUserName = await FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: userName)
          // .limit(1)
          .get()
          .then((value) => value.size > 0 ? true : false);

      _checkEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          // .limit(1)
          .get()
          .then((value) => value.size > 0 ? true : false);

      if (_checkUserName == false && _checkEmail == false) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailFieldController.text,
          password: _passwordFieldController.text,
        );

        FirestoreService fs = FirestoreService();
        fs.createUser(
            _emailFieldController.text, _usernameFieldController.text);

        navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else if (_checkUserName == true && _checkEmail == true) {
        _usernameFieldController.text = '';
        _emailFieldController.text = '';
        Fluttertoast.showToast(
            msg:
                "Username and Email already in use!\nChoose different credentials!",
            toastLength: Toast.LENGTH_LONG);
      } else if (_checkUserName == true && _checkEmail == false) {
        _usernameFieldController.text = '';
        Fluttertoast.showToast(
            msg: "Username already in use!\nChoose a different Username!",
            toastLength: Toast.LENGTH_LONG);
      } else if (_checkUserName == false && _checkEmail == true) {
        _emailFieldController.text = '';
        Fluttertoast.showToast(
            msg: "Email already in use!\nChoose a different Email!",
            toastLength: Toast.LENGTH_LONG);
      }
    } on FirebaseAuthException catch (e) {
      //weak-password means less than 6 chars
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    //Release memory allocated to the fields after the page is removed
    _emailFieldController.dispose();
    _usernameFieldController.dispose();
    _passwordFieldController.dispose();
    _retypePasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: lightBruinBlue,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'SIGN UP PAGE',
                    style: TextStyle(
                      fontSize: 27,
                      color: darkBruinBlue,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Wrap(
                    runSpacing: 25,
                    direction: Axis.horizontal,
                    children: [
                      emailTextFormFieldStyle(
                          "Email", "enter email", _emailFieldController, false),
                      userNameTextFormFieldStyle("Username", "enter username",
                          _usernameFieldController),
                      signUpPasswordTextFormFieldStyle("Password",
                          "enter password", _passwordFieldController),
                      retypePasswordTextFormFieldStyle(
                          "Retype Password",
                          "retype password",
                          _retypePasswordFieldController,
                          _passwordFieldController),
                      const SizedBox(height: 5),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 15,
                        children: [
                          ElevatedButton(
                            style: getButtonStyle(),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                verifySignUp(_usernameFieldController.text,
                                    _emailFieldController.text);
                              }
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(),
                            ),
                          ),
                          const Center(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Already Have An Account?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: getButtonStyle(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text('Login Page'),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.01, // smoothes out the touch scroll animation from the bottom
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains(' ')) {
      // Remove spaces
      final String trimmedValue = newValue.text.replaceAll(' ', '');
      return TextEditingValue(
        text: trimmedValue,
        selection: TextSelection.collapsed(offset: trimmedValue.length),
      );
    }
    return newValue;
  }
}
