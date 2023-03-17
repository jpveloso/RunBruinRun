import 'package:flutter/material.dart';

const darkBruinBlue = Color.fromRGBO(8, 42, 86, 1);
const lightBruinBlue = Color.fromRGBO(123, 192, 234, 1);

// ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
//   foregroundColor: Colors.white,
//   backgroundColor: darkBruinBlue,
//   fixedSize: const Size(300, 50),
// );

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

TextFormField inputTextFormFieldStyle(
    String labelText, String hintText, TextEditingController? controller) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {
      if (value == null || value.isEmpty){
        return '$labelText is required';
      }
      return null;
    },
    controller: controller,
    maxLength: 25,
    cursorColor: Colors.white,
    autofocus: true,
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      errorStyle: const TextStyle(
        fontSize: 14.0,
        color: darkBruinBlue,
        fontWeight: FontWeight.bold
      ),
      label: SizedBox(
          height: 50,
          width: 200,
          child: Text(labelText,
              style: const TextStyle(fontSize: 25, color: Colors.white))),
      filled: true,
      fillColor: darkBruinBlue,
      hintStyle: const TextStyle(color: Colors.white70),
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}

TextFormField passwordTextFormFieldStyle(
    String labelText, String hintText, TextEditingController? controller) {
  return TextFormField (
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {
      if (value == null || value.isEmpty){
        return '$labelText is required';
      }
      return null;
    },
    controller: controller,
    enableSuggestions: false,
    autocorrect: false,
    obscureText: true,
    obscuringCharacter: "*",
    maxLength: 25,
    cursorColor: Colors.white,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      errorStyle: const TextStyle(
          fontSize: 14.0,
          color: darkBruinBlue,
          fontWeight: FontWeight.bold
      ),
      label: SizedBox(
          height: 50,
          width: 200,
          child: Text(labelText,
              style: const TextStyle(fontSize: 25, color: Colors.white))),
      filled: true,
      fillColor: darkBruinBlue,
      hintStyle: const TextStyle(color: Colors.white70),
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}
