import 'dart:core';

class User {
  int _id;
  String _email;
  String _userName;
  String _password;

  User(this._id, this._email, this._userName, this._password);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }
}
