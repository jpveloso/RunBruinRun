import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_bruin_run/screens/usercredentialpages/login_page.dart';
import 'package:run_bruin_run/styles.dart';

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
  bool weakPassword = false;
  bool retypePasswordMatch = false;
  bool emailExists = false;

  //final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> verifySignUp(String userName, String email) async {
    final navigator = Navigator.of(context);
    try {
      bool checkUserName = await FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: userName)
          // .limit(1)
          .get()
          .then((value) => value.size > 0 ? true : false);

      bool checkEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          // .limit(1)
          .get()
          .then((value) => value.size > 0 ? true : false);

      if (checkUserName == false && checkEmail == false) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailFieldController.text,
          password: _passwordFieldController.text,
        );
        navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else if (checkUserName == true && checkEmail == true) {
        _usernameFieldController.text = '';
        _emailFieldController.text = '';
        Fluttertoast.showToast(
            msg: "Username and Email Already Exists!",
            toastLength: Toast.LENGTH_LONG);
      } else if (checkUserName == true && checkEmail == false) {
        _usernameFieldController.text = '';
        Fluttertoast.showToast(
            msg: "Username Already Exists!", toastLength: Toast.LENGTH_LONG);
      } else if (checkUserName == false && checkEmail == true) {
        _usernameFieldController.text = '';
        Fluttertoast.showToast(
            msg: "Email Already Exists!", toastLength: Toast.LENGTH_LONG);
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
    // FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    // CollectionReference users = FirebaseFirestore.instance.collection("users");
    // FirebaseFirestore.instance.collection('users').doc(userName)

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: lightBruinBlue,
        body: Center(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'SIGN UP PAGE',
                style: TextStyle(
                  fontSize: 32,
                  color: darkBruinBlue,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 25,
                  children: [
                    inputTextFormFieldStyle(
                        "Email",
                        "enter email",
                        _emailFieldController,
                        emailExists
                            ? 'The account already exists for that email.'
                            : null),
                    userNameTextFormFieldStyle(
                        "Username", "enter username", _usernameFieldController),
                    passwordTextFormFieldStyle(
                        "Password",
                        "enter password",
                        _passwordFieldController,
                        weakPassword
                            ? 'The password provided is too weak.'
                            : null),
                    retypePasswordTextFormFieldStyle(
                        "Retype Password",
                        "retype password",
                        _retypePasswordFieldController,
                        _passwordFieldController),
                  ],
                ),
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
                          // _signUp();
                          verifySignUp(_usernameFieldController.text,
                              _emailFieldController.text);
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(),
                      )),
                  const Text(
                    'Already Have An Account?',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text('Login Page'))
                ],
              ),
            ],
          ),
        )));
  }

// void _signUp() async {
//   //New Navigator to get rid of Linter warninglines
//   final navigator = Navigator.of(context);
//   try {
//     UserCredential userCredential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: _emailFieldController.text,
//       password: _passwordFieldController.text,
//     );
//     // User is signed up, navigate to home page
//     //New Navigator to get rid of Linter warninglines
//     navigator.pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginPage()));
//
//     //Old implementation of ^^^
//     // Navigator.pushReplacement(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => const LoginPage()),
//     // );
//   } on FirebaseAuthException catch (e) {
//     //weak-password means less than 6 chars
//     if (e.code == 'weak-password') {
//       print('The password provided is too weak.');
//     } else if (e.code == 'email-already-in-use') {
//       print('The account already exists for that email.');
//     }
//   } catch (e) {
//     print(e);
//   }
// }
}
