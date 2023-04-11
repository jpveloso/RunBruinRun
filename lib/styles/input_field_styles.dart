import 'package:flutter/material.dart';

import '../screens/usercredentialpages/signup_page.dart';
import 'colours.dart';

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
      decoration: decorationStyle(labelText, hintText, errorText));
}

//For Username Field Login Page
TextFormField userNameTextFormFieldStyle(
    String? labelText, String? hintText, TextEditingController? controller) {
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
      decoration: decorationStyle(labelText, hintText, null));
}

//For Email field in SignUp Page
TextFormField emailTextFormFieldStyle(
    String? labelText, String? hintText, TextEditingController? controller) {
  return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      //old
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return '$labelText is required';
      //   } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
      //       .hasMatch(value)) {
      //     return 'Please enter a valid email address';
      //   } else if (value.contains(' ')) {
      //     return '$labelText address should not contain spaces';
      //   } else {
      //     return null;
      //   }
      // },

      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        } else if (value.contains(' ')) {
          return '$labelText address should not contain spaces';
        } else if (value.split('@')[1].contains(RegExp(r'[A-Z]'))) {
          return 'No uppercase letters after @';
        } else {
          return null;
        }
      },

      controller: controller,
      maxLength: 25,
      inputFormatters: [NoSpaceFormatter()],
      cursorColor: Colors.white,
      autofocus: true,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: decorationStyle(labelText, hintText, null));
}

//Same as Login Page password ^^^ just with hidden characters for password
TextFormField passwordTextFormFieldStyle(String? labelText, String? hintText,
    TextEditingController? controller, String? errorText) {
  return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        } else if (value.length < 6) {
          return 'Must be at least 6 characters!';
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
      decoration: decorationStyle(labelText, hintText, errorText));
}

//Signup Page Password Field
TextFormField signUpPasswordTextFormFieldStyle(
    String? labelText, String? hintText, TextEditingController? controller) {
  return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        } else if (value.length < 6) {
          return 'Must be at least 6 characters!';
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
      decoration: decorationStyle(labelText, hintText, null));
}

//Retype password input field with validator
TextFormField retypePasswordTextFormFieldStyle(
    String? labelText,
    String? hintText,
    TextEditingController? controller,
    TextEditingController? passwordController) {
  return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value != passwordController?.text) {
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
      decoration: decorationStyle(labelText, hintText, null));
}

//Decoration Style for the TextFormField(s) Methods InputDecoration ^^^
InputDecoration decorationStyle(
    String? labelText, String? hintText, String? errorText) {
  return InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    counterStyle: counterTextStyle(),
    errorText: errorText,
    errorStyle: const TextStyle(
        fontSize: 12.0, color: darkBruinBlue, fontWeight: FontWeight.w900),
    label: FittedBox(
      fit: BoxFit.fitWidth,
      child: SizedBox(
          height: 50,
          child: Text(labelText!,
              style: const TextStyle(fontSize: 22, color: Colors.white))),
    ),
    filled: true,
    fillColor: darkBruinBlue,
    hintStyle: const TextStyle(color: Colors.white54),
    hintText: hintText,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(50),
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
