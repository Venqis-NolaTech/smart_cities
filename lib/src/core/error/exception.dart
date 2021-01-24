abstract class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return '$_prefix$_message';
  }
}

class AuthUserException extends AppException {
  AuthUserException([String message]) : super(message, 'Auth User Error: ');
}

class CreateUserException extends AppException {
  CreateUserException([String message]) : super(message, 'Create User Error: ');
}

class UserInfoException extends AppException {
  UserInfoException([String message]) : super(message, 'User Info Error: ');
}

class UserNotFoundException extends AppException {
  UserNotFoundException([String message]) : super(message, 'User Not Found: ');
}

class NotConnectionException extends AppException {
  NotConnectionException([message])
      : super(message, "Device isn't conntected: ");
}

class ServerException extends AppException {
  ServerException([String message])
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, 'Unauthorised: ');
}

class NotTokenException extends AppException {
  NotTokenException([String message]) : super(message, 'Error No token: ');
}

class LocationServiceException extends AppException {
  LocationServiceException([String message])
      : super(message, "Error During Communication LocationService: ");
}
