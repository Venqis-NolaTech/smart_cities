import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failure.dart';

abstract class ViewState extends Equatable {
  @override
  List<Object> get props => const <dynamic>[];
}

class Idle extends ViewState {}

class Loading extends ViewState {}

class Loaded<T> extends ViewState {
  final T value;

  Loaded({this.value});

  @override
  List<Object> get props => [value];
}

class Error extends ViewState {
  final Failure failure;

  Error({@required this.failure});

  @override
  List<Object> get props => [failure];
}
