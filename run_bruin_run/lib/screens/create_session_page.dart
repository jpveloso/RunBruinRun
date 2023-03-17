import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/home_page.dart';
import 'package:run_bruin_run/screens/main_menu_page.dart';
import 'package:run_bruin_run/styles.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({Key? key}) : super(key: key);

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  // final emailFieldController = TextEditingController();
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    //Release memory allocated to the fields after the page is removed
    // emailFieldController.dispose();
    _usernameFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form (
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
                    'CREATE SESSION',
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
                      inputTextFormFieldStyle("Username", "Enter your username",
                          _usernameFieldController),
                      const SizedBox(height: 30),
                      passwordTextFormFieldStyle("Password",
                          "Enter your password", _passwordFieldController),
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
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const MainMenuPage()));
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
