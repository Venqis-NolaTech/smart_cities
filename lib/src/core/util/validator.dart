import 'string_util.dart';

class Validator {
  bool isRequired(String value) {
    return (value.isNotNullOrNotEmpty);
  }

  bool isValidName(String name) {
    return (isRequired(name) && name.length > 2);
  }

  bool isValidPassword(String password) {
    return (password.isNotNullOrNotEmpty && password.length >= 6);
  }

  bool isEmail(String email) {
    if (email.isNullOrEmpty) return false;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    return regex.hasMatch(email);
  }

  bool isPhoneNumber(String phoneNumber) {
    if (phoneNumber.isNullOrEmpty) return false;

    Pattern pattern = r'^[+]*[1-9]{1,2}[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regex = new RegExp(pattern);

    return regex.hasMatch(phoneNumber);
  }

  // Validates a Panamenial id (Cédula)
  bool isValidDni(String dni) {
    Pattern pattern =
        r'/^P$|^(?:PE|E|N|[23456789]|[23456789](?:A|P)?|1[0123]?|1[0123]?(?:A|P)?)$|^(?:PE|E|N|[23456789]|[23456789](?:AV|PI)?|1[0123]?|1[0123]?(?:AV|PI)?)-?$|^(?:PE|E|N|[23456789](?:AV|PI)?|1[0123]?(?:AV|PI)?)-(?:\d{1,4})-?$|^(PE|E|N|[23456789](?:AV|PI)?|1[0123]?(?:AV|PI)?)-(\d{1,4})-(\d{1,6})$';
    RegExp regex = new RegExp(pattern);

    return regex.hasMatch(dni);
  }
}
