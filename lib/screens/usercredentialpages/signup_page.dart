import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool emailExists = false;

  //final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              const SizedBox(height: 100),
              SizedBox(
                width: 350,
                height: 380,
                child: Column(children: [
                  inputTextFormFieldStyle(
                      "Email",
                      "enter email",
                      _emailFieldController,
                      emailExists
                          ? 'The account already exists for that email.'
                          : null),
                  const SizedBox(height: 10),
                  inputTextFormFieldStyle(
                      "Username", "enter username", _usernameFieldController),
                  const SizedBox(height: 10),
                  passwordTextFormFieldStyle(
                      "Password",
                      "enter password",
                      _passwordFieldController,
                      weakPassword
                          ? 'The password provided is too weak.'
                          : null),
                  const SizedBox(height: 10),
                  passwordTextFormFieldStyle("Retype Password",
                      "retype password", _retypePasswordFieldController),
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
                          _signUp();
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

  void _signUp() async {
    //New Navigator to get rid of Linter warninglines
    final navigator = Navigator.of(context);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailFieldController.text,
        password: _passwordFieldController.text,
      );
      // User is signed up, navigate to home page
      //New Navigator to get rid of Linter warninglines
      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));

      //Old implementation of ^^^
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LoginPage()),
      // );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
