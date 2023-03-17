import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/signup_page.dart';
import 'package:run_bruin_run/styles.dart';
import 'login_page.dart';

//dart fix --apply

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBruinBlue,
      // appBar: AppBar(
      //   backgroundColor: darkBruinBlue,
      //   title: Text('Run Bruin Run'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Image.asset(
              'lib/images/Sheridan_Bruins_Logo.png',
            ),
            const SizedBox(height: 50),
            const Text(
              'RUN BRUIN RUN',
              style: TextStyle(
                fontSize: 28,
                color: darkBruinBlue,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 120),
            Wrap(
              direction: Axis.vertical,
              // crossAxisAlignment: WrapCrossAlignment.center,
              // alignment: WrapAlignment.center,
              spacing: 20,
              children: [
                ElevatedButton(
                    style: getButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(),
                    )),
                ElevatedButton(
                    style: getButtonStyle(),
                    onPressed: () {},
                    child: const Text('Guest')),
                ElevatedButton(
                    style: getButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const SignUpPage())
                      );
                    },
                    child: const Text('Sign Up')),
              ],
            ),
          ],
        ),
      )
    );
  }
}
