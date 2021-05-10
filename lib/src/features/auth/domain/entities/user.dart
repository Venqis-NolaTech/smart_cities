import 'package:equatable/equatable.dart';

import '../../../../core/entities/catalog_item.dart';



class UserListings extends Equatable {
  final int totalCount;
  final List<User> users;

  UserListings({this.totalCount, this.users});

  @override
  List<Object> get props => [totalCount, users];
}



// ignore: must_be_immutable
class User extends Equatable {
  final String id;
  final String uid;
  final String phoneNumber;
  final String countryCode;
  final String kind;
  //final CatalogItem location;
  //final String address;
  final String profession;
  final String firstName;
  final String lastName;
  final String nickName;
  final String email;
  final String photoURL;
  final String dni;
  final String street;
  final String number;
  //final String birthDate;
  CatalogItem municipality;
  CatalogItem province;
  CatalogItem city;
  final bool emailVerified;
  final String lastSignInTime;

  CatalogItem sector;
  final int reportNumber;

  User(
      {this.id,
      this.uid,
      this.phoneNumber,
      this.countryCode,
      this.kind,
      //this.location,
      //this.address,
      this.profession,
      this.firstName,
      this.lastName,
      this.nickName,
      this.photoURL,
      this.email,
      this.dni,
      this.street,
      this.number,
      //this.birthDate,
      this.municipality,
      this.province,
      this.city,
      this.reportNumber,
      this.sector,
      this.emailVerified,
      this.lastSignInTime,
      });

  String get fullName => '$firstName $lastName';

  @override
  List<Object> get props => [
        id,
        uid,
        phoneNumber,
        countryCode,
        profession,
        firstName,
        lastName,
        nickName,
        email,
        photoURL,
        dni
      ];

  User copy({
    String id,
    String uid,
    String phoneNumber,
    String countryCode,
    String kind,
    String profession,
    String firstName,
    String lastName,
    String nickName,
    String email,
    String photoURL,
    String dni,
    String street,
    String number,
    CatalogItem municipality,
    CatalogItem province,
    CatalogItem city,
    bool emailVerified,
    String lastSignInTime,
    CatalogItem sector,
    int reportNumber
  }) =>
      User(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        countryCode: countryCode ?? this.countryCode,
        kind: kind ?? this.kind,
        profession: profession ?? this.profession,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        nickName: nickName ?? this.nickName,
        email: email ?? this.email,
        photoURL: photoURL ?? this.photoURL,
        dni: dni ?? this.dni,
        street: street ?? this.street,
        number: number ?? this.number,
        municipality: municipality ?? this.municipality,
        province: province ?? this.province,
        city: city ?? this.city,
        emailVerified: emailVerified ?? this.emailVerified,
        lastSignInTime: lastSignInTime ?? this.lastSignInTime
      );
}

// ignore: must_be_immutable
class UserRegisterRequest extends Equatable {
  UserRegisterRequest({
    this.phoneNumber,
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.email,
    this.dni,
    this.countryCode,
    this.street,
    this.province,
    this.city,
    this.municipality,
    this.number,
  });

  String phoneNumber;
  String photoUrl;
  String firstName;
  String lastName;
  String email;
  String dni;
  String countryCode;
  String street;
  String province;
  String city;
  String municipality;
  String number;

  @override
  List<Object> get props => [
        phoneNumber,
        photoUrl,
        firstName,
        lastName,
        email,
        dni,
        countryCode,
        street,
        province,
        city,
        municipality,
        number,
      ];
}

class Position extends Equatable {
  final double latitude;
  final double longitude;

  Position({
    this.latitude,
    this.longitude,
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
      ];
}

class UserIdentification extends Equatable {
  final bool found;
  final String fullName;
  final String phoneNumber;
  final String dni;

  UserIdentification({
    this.found,
    this.fullName,
    this.phoneNumber,
    this.dni,
  });

  @override
  List<Object> get props => [
        found,
        fullName,
        phoneNumber,
        dni,
      ];
}
