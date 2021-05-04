import 'package:equatable/equatable.dart';

class UserDisplay extends Equatable {
  final String id;
  final String displayName;
  final String photoUrl;

  UserDisplay({this.id, this.displayName, this.photoUrl});

  @override
  List<Object> get props => [id, displayName, photoUrl];
}
