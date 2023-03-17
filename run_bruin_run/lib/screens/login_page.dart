import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/home_page.dart';
import 'package:run_bruin_run/styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                'Login Page',
                style: TextStyle(
                  fontSize: 35,
                  color: darkBruinBlue,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: 350,
                height: 175,
                child: Column(children: [
                  TextField(
                    maxLength: 25,
                    cursorColor: Colors.white,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: darkBruinBlue,
                      hintStyle: const TextStyle(color: Colors.white70),
                      hintText: "Enter your username",
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
                      // labelText: "Password",
                      // labelStyle: TextStyle(fontSize: 30, color: Colors.white),
                      filled: true,
                      fillColor: darkBruinBlue,
                      hintStyle: const TextStyle(color: Colors.white70),
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                children: [
                  ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {},
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
        ));
  }
}
