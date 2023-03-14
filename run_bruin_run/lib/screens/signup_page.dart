import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/login_page.dart';
import 'package:run_bruin_run/styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
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
                  TextField(
                    maxLength: 25,
                    cursorColor: Colors.white,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle:
                          const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              // height: 20,
                          ),
                      filled: true,
                      fillColor: darkBruinBlue,
                      // hintStyle: const TextStyle(color: Colors.white70),
                      // hintText: "email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLength: 25,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle:
                          const TextStyle(fontSize: 20, color: Colors.white),
                      filled: true,
                      fillColor: darkBruinBlue,
                      // hintStyle: const TextStyle(color: Colors.white70),
                      // hintText: "username",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    obscuringCharacter: "*",
                    maxLength: 25,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle:
                          const TextStyle(fontSize: 20, color: Colors.white),
                      filled: true,
                      fillColor: darkBruinBlue,
                      // hintStyle: const TextStyle(color: Colors.white70),
                      // hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    obscuringCharacter: "*",
                    maxLength: 25,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Retype Password",
                      labelStyle:
                          const TextStyle(fontSize: 20, color: Colors.white),
                      filled: true,
                      fillColor: darkBruinBlue,
                      // hintStyle: const TextStyle(color: Colors.white70),
                      // hintText: "retype password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ]),
              ),
              // const SizedBox(height: 20),
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
