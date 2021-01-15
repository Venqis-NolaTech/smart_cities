import 'package:equatable/equatable.dart';

import '../../../../core/entities/catalog_item.dart';

class User extends Equatable {
  final String id;
  final String uid;
  final String phoneNumber;
  final String countryCode;
  //final CatalogItem location;
  //final String address;
  final String profession;
  final String firstName;
  final String lastName;
  final String nickName;
  final String email;
  final String photoURL;
  final String dni;
  //final String birthDate;
  CatalogItem municipality;
  CatalogItem province;
  CatalogItem city;

  User({
    this.id,
    this.uid,
    this.phoneNumber,
    this.countryCode,
    //this.location,
    //this.address,
    this.profession,
    this.firstName,
    this.lastName,
    this.nickName,
    this.photoURL,
    this.email,
    this.dni,
    //this.birthDate,
    this.municipality,
    this.province,
    this.city
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
}

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
