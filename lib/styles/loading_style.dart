import 'package:flutter/material.dart';

import 'colours.dart';

Scaffold loadingScreen() {
  return Scaffold(
    backgroundColor: lightBruinBlue,
    resizeToAvoidBottomInset: false,
    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// crossAxisAlignment: CrossAxisAlignment.center,
          children: const [ Text(
            'LOADING...',
            style: TextStyle(
              fontSize: 28,
              color: darkBruinBlue,
              fontFamily: 'PressStart2P',
            ),
          ),
          ],
        )
    ),
  );
}

