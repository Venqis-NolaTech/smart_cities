import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => const <dynamic>[];
}

class UnexpectedFailure extends Failure {}

class NotConnectionFailure extends Failure {}

class InfoNotFoundFailure extends Failure {}

class UserInfoFailure extends Failure {}

class UserNotFoundFailure extends Failure {}

class DniExistFailure extends Failure {}

class EmailExistFailure extends Failure {}

class UserExistFailure extends Failure {}

class UserDisabledFailure extends Failure {}

class InvalidCredentialFailure extends Failure {}

class AccountExistWithDiferentCredentialFailure extends Failure {}

class LocationServiceFailure extends Failure {}
