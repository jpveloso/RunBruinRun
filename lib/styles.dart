import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const darkBruinBlue = Color.fromRGBO(8, 42, 86, 1);
const lightBruinBlue = Color.fromRGBO(123, 192, 234, 1);
const bluePlayerColor = Color.fromRGBO(0, 0, 255, 1);
const redPlayerColor = Color.fromRGBO(255, 0, 0, 1);
const greenPlayerColor = Color.fromRGBO(0, 255, 0, 1);
const yellowPlayerColor = Color.fromRGBO(255, 255, 0, 1);

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

//Input Pages Login/Signup
TextFormField inputTextFormFieldStyle(String? labelText, String? hintText,
    TextEditingController? controller, String? errorText) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {
      if (value == null || value.isEmpty) {
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
      counterStyle: counterTextStyle(),
      errorText: errorText,
      errorStyle: const TextStyle(
          fontSize: 14.0, color: darkBruinBlue, fontWeight: FontWeight.bold),
      label: SizedBox(
          height: 50,
          width: 200,
          child: Text(labelText!,
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

//For Username Field
TextFormField userNameTextFormFieldStyle(String? labelText, String? hintText,
    TextEditingController? controller) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {
      if (value == null || value.isEmpty) {
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
      counterStyle: counterTextStyle(),
      errorStyle: const TextStyle(
          fontSize: 14.0, color: darkBruinBlue, fontWeight: FontWeight.bold),
      label: SizedBox(
          height: 50,
          width: 200,
          child: Text(labelText!,
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

//Same as Input Page ^^^ just with hidden characters for password
TextFormField passwordTextFormFieldStyle(String? labelText, String? hintText,
    TextEditingController? controller, String? errorText) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {
      if (value == null || value.isEmpty) {
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
      counterStyle: counterTextStyle(),
      errorText: errorText,
      errorStyle: const TextStyle(
          fontSize: 14.0, color: darkBruinBlue, fontWeight: FontWeight.bold),
      label: SizedBox(
          height: 50,
          width: 200,
          child: Text(labelText!,
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

//Retype password input field with validator
TextFormField retypePasswordTextFormFieldStyle(String? labelText, String? hintText,
    TextEditingController? controller, TextEditingController? passwordController) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {
      if ( value != passwordController?.text) {
        return 'Password does not match';
      } else if (value == null || value.isEmpty) {
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
      counterStyle: counterTextStyle(),
      // errorText: errorText,
      errorStyle: const TextStyle(
          fontSize: 14.0, color: darkBruinBlue, fontWeight: FontWeight.bold),
      label: SizedBox(
          height: 50,
          width: 200,
          child: Text(labelText!,
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

//Join Session/Create Session field
TextFormField joinCodeTextFieldStyle(TextEditingController? controller) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Join Code is required';
      } else if (value.length < 6) {
        return 'Minimum Join Code length of 6';
      }
      return null;
    },
    controller: controller,
    maxLength: 6,
    cursorColor: Colors.white,
    autofocus: true,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ],
    style: const TextStyle(
      color: Colors.white,
      fontSize: 50,
    ),
    decoration: InputDecoration(
      counterStyle: counterTextStyle(),
      errorStyle: const TextStyle(
          fontSize: 14, color: darkBruinBlue, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: darkBruinBlue,
      hintStyle: const TextStyle(color: Colors.white70),
      hintText: "Ex. 123456",
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}

//Create Session Random Number Field
TextFormField generatedCodeTextFieldStyle(TextEditingController? controller) {
  return TextFormField(
    enabled: false,
    controller: controller,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 50,
    ),
    decoration: const InputDecoration(
      filled: true,
      fillColor: darkBruinBlue,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        // borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}

//Counter style for maxLength of a TextFormField Input
TextStyle counterTextStyle() {
  return const TextStyle(
    fontSize: 14,
    color: darkBruinBlue,
    fontWeight: FontWeight.bold,
  );
}

//Create Session Player Card and Button
Wrap playerCardAndBtn(Color color, String playerName, String buttonText) {
  return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Container(
          width: 200,
          height: 80,
          color: Colors.white,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: color,
                  radius: 30,
                ),
                const SizedBox(width: 20),
                Text(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    playerName)
              ],
            ),
          ),
        ),
        ElevatedButton(
            style: getSmallSquaredButtonStyle(),
            onPressed: () {},
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 20),
            )),
      ]);
}

//Session Joined Player Card
Wrap playerCard(Color color, String playerName) {
  return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Container(
          width: 200,
          height: 80,
          color: Colors.white,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: color,
                  radius: 30,
                ),
                const SizedBox(width: 20),
                Text(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    playerName)
              ],
            ),
          ),
        ),
      ]);
}
