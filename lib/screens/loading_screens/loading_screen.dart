import 'package:flutter/material.dart';

import '../../styles/colours.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBruinBlue,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              'LOADING...',
              style: TextStyle(
                fontSize: 28,
                color: darkBruinBlue,
                fontFamily: 'PressStart2P',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
