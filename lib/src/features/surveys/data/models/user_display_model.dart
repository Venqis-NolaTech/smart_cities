import '../../domain/entities/user_display.dart';

class UserDisplayModel extends UserDisplay {
  UserDisplayModel({
    String id,
    String displayName,
    String photoUrl,
  }) : super(
          id: id,
          displayName: displayName,
          photoUrl: photoUrl,
        );

  // Json
  factory UserDisplayModel.fromJson(Map<String, dynamic> json) {
    return UserDisplayModel(
      id: json['_id'],
      displayName: json['displayName'],
      photoUrl: json['photoURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'displayName': displayName,
      'photoURL': photoUrl,
    };
  }

  //Entity
  factory UserDisplayModel.fromEntity(UserDisplay user) {
    return UserDisplayModel(
      id: user.id,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }
}
