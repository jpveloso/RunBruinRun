import 'package:flutter/material.dart';

import 'colours.dart';

//Button Styles
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

//Same as above just smaller footprint
ButtonStyle getSmallButtonStyle() {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: darkBruinBlue,
    fixedSize: const Size(140, 60),
    elevation: 15,
    shadowColor: darkBruinBlue,
    side: const BorderSide(color: lightBruinBlue, width: 2),
    shape: const StadiumBorder(),
  );
}

//Small button style with square border
ButtonStyle getSmallSquaredButtonStyle() {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: darkBruinBlue,
    fixedSize: const Size(140, 60),
    elevation: 15,
    shadowColor: darkBruinBlue,
    side: const BorderSide(color: lightBruinBlue, width: 2),
  );
}

//Quit button style for game
ButtonStyle getQuitButtonStyle() {
  return IconButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.white,
  );
}
