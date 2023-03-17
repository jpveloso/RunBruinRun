import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/login_page.dart';
import 'package:run_bruin_run/styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final retypePasswordFieldController = TextEditingController();

  @override
  void dispose() {
    //Release memory allocated to the fields after the page is removed
    emailFieldController.dispose();
    usernameFieldController.dispose();
    passwordFieldController.dispose();
    retypePasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: lightBruinBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Sign Up Page',
                style: TextStyle(
                  fontSize: 32,
                  color: darkBruinBlue,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: 350,
                height: 380,
                child: Column(children: [
                  inputTextFieldStyle("Email", "enter email", emailFieldController),
                  const SizedBox(height: 10),
                  inputTextFieldStyle("Username", "enter username", usernameFieldController),
                  const SizedBox(height: 10),
                  passwordTextFieldStyle("Password", "enter password", passwordFieldController),
                  const SizedBox(height: 10),
                  passwordTextFieldStyle("Retype Password", "retype password", retypePasswordFieldController),
                ]),
              ),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                children: [
                  ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {},
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
                      child: const Text('Login'))
                ],
              ),
            ],
          ),
        ));
  }
}
