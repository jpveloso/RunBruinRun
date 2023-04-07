import 'package:flutter/material.dart';
import '../../styles/colours.dart';

Scaffold showGameOverScreen() {
  return Scaffold(
    backgroundColor: lightBruinBlue,
    resizeToAvoidBottomInset: false,
    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// crossAxisAlignment: CrossAxisAlignment.center,
          children: const [ Text(
            'GAME OVER...',
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

