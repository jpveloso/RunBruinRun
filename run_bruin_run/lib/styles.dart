import 'package:flutter/material.dart';

const darkBruinBlue = Color.fromRGBO(8, 42, 86, 1);
const lightBruinBlue = Color.fromRGBO(123, 192, 234, 1);

ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: darkBruinBlue,
  fixedSize: const Size(300, 50),
);

ButtonStyle getButtonStyle() {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: darkBruinBlue,
    fixedSize: const Size(200, 60),
    elevation: 15,
    shadowColor: darkBruinBlue,
    side: const BorderSide(color: lightBruinBlue, width: 2),
    shape: const StadiumBorder(),
  );
}
