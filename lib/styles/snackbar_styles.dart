import 'package:flutter/material.dart';

import 'colours.dart';

SnackBar showShortLengthSnackbar(String message) {
  return SnackBar(
    duration: const Duration(milliseconds: 2000),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14.0,
        // fontFamily: 'PressStart2P',
        color: Colors.white,
        fontWeight: FontWeight.w900,
      ),
    ),
    backgroundColor: darkBruinBlue,
  );
}

SnackBar showLongLengthSnackbar(String message) {
  return SnackBar(
    duration: const Duration(milliseconds: 5000),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14.0,
        // fontFamily: 'PressStart2P',
        color: Colors.white,
        fontWeight: FontWeight.w900,
      ),
    ),
    backgroundColor: darkBruinBlue,
  );
}