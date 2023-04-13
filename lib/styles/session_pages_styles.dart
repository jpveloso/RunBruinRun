import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:run_bruin_run/styles/input_field_styles.dart';

import 'button_styles.dart';
import 'colours.dart';

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
