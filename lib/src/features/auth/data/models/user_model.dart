import '../../../../core/entities/catalog_item.dart';
import '../../../../core/models/catalog_item_model.dart';
import '../../domain/entities/user.dart';

// ignore: must_be_immutable
class UserModel extends User {
  UserModel(
      {String id,
      String uid,
      String phoneNumber,
      String countryCode,
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
      CatalogItem sector,
      int reportNumber
      })
      : super(
            id: id,
            uid: uid,
            phoneNumber: phoneNumber,
            countryCode: countryCode,
            profession: profession,
            firstName: firstName,
            lastName: lastName,
            nickName: nickName,
            email: email,
            photoURL: photoURL,
            dni: dni,
            street: street,
            number: number,
            municipality: municipality,
            province: province,
            city: city,
            reportNumber: reportNumber,
            sector: sector);

  // Json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json.containsKey('user') ? json['user'] : json;

    return UserModel(
      id: user['_id'],
      uid: user['uid'],
      phoneNumber: user['phoneNumber'],
      countryCode: user['countryCode'],
      profession: user["profession"],
      firstName: user['firstName'],
      lastName: user['lastName'],
      nickName: user['nickName'],
      email: user['email'],
      photoURL: user['photoURL'],
      dni: user['dni'],
      street: user['street'],
      number: user['number'],
      reportNumber: user['reportNumber'],
      municipality: user['municipality'] != null
          ? CatalogItemModel.fromJson(user['municipality'])
          : null,
      province: user['province'] != null
          ? CatalogItemModel.fromJson(user['province'])
          : null,
      city:
          user['city'] != null ? CatalogItemModel.fromJson(user['city']) : null,
      sector: user['sector'] != null
          ? CatalogItemModel.fromJson(user['sector'])
          : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": {
        '_id': id,
        'uid': uid,
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
        'profession': profession,
        'firstName': firstName,
        'lastName': lastName,
        'nickName': nickName,
        'email': email,
        'photoURL': photoURL,
        'dni': dni,
        'street': street,
        'number': number,
        'municipality': municipality != null
            ? CatalogItemModel.fromEntity(municipality).toJson()
            : null,
        'province': province != null
            ? CatalogItemModel.fromEntity(province).toJson()
            : null,
        'city': city != null ? CatalogItemModel.fromEntity(city).toJson() : null,
        'reportNumber': reportNumber,

        'sector': sector != null
            ? CatalogItemModel.fromEntity(sector).toJson()
            : null,
      }
    };
  }

  Map<String, dynamic> toJsonRequest() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nickName': nickName,
      'email': email,
      'photoURL': photoURL,
      'municipality': municipality!= null ? municipality.key : null,
      'street': street,
      'number': number,
      'sector': sector!= null ? sector.key : null
      //'province': province.key,
    };
  }

  //Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      uid: user.uid,
      phoneNumber: user.phoneNumber,
      countryCode: user.countryCode,
      profession: user.profession,
      firstName: user.firstName,
      lastName: user.lastName,
      nickName: user.nickName,
      email: user.email,
      photoURL: user.photoURL,
      dni: user.dni,
      street: user.street,
      number: user.number,
      municipality: user.municipality,
      province: user.province,
      city: user.city,
      reportNumber: user.reportNumber,
      sector: user.sector
    );
  }
}

// ignore: must_be_immutable
class UserRegisterRequestModel extends UserRegisterRequest {
  UserRegisterRequestModel({
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
  }) : super(
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
          firstName: firstName,
          lastName: lastName,
          email: email,
          dni: dni,
          countryCode: countryCode,
          street: street,
          province: province,
          city: city,
          municipality: municipality,
          number: number,
        );

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

  factory UserRegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      UserRegisterRequestModel(
        phoneNumber: json["phoneNumber"],
        photoUrl: json["photoURL"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        dni: json["dni"],
        countryCode: json["countryCode"],
        street: json["street"],
        province: json["province"],
        city: json["city"],
        municipality: json["municipality"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "photoURL": (photoUrl != null) ? photoUrl : '',
        "firstName": firstName,
        "lastName": lastName,
        "email": (email != null) ? email : '',
        "dni": dni,
        "countryCode": countryCode,
        "street": street,
        "province": province,
        "city": city,
        "municipality": municipality,
        "number": number,
      };

  factory UserRegisterRequestModel.fromEntity(
      UserRegisterRequest userRegisterRequest) {
    return UserRegisterRequestModel(
      phoneNumber: userRegisterRequest.phoneNumber,
      photoUrl: userRegisterRequest.photoUrl,
      firstName: userRegisterRequest.firstName,
      lastName: userRegisterRequest.lastName,
      email: userRegisterRequest.email,
      dni: userRegisterRequest.dni,
      countryCode: userRegisterRequest.countryCode,
      street: userRegisterRequest.street,
      province: userRegisterRequest.province,
      city: userRegisterRequest.city,
      municipality: userRegisterRequest.municipality,
      number: userRegisterRequest.number,
    );
  }
}

class PositionModel extends Position {
  PositionModel({
    latitude,
    longitude,
  }) : super(
          latitude: latitude,
          longitude: longitude,
        );
}

class UserIdentificationModel extends UserIdentification {
  UserIdentificationModel({
    bool found,
    String fullName,
    String phoneNumber,
    String dni,
  }) : super(
          found: found,
          fullName: fullName,
          phoneNumber: phoneNumber,
          dni: dni,
        );

  factory UserIdentificationModel.fromJson(Map<String, dynamic> json) {
    return UserIdentificationModel(
      found: json['found'],
      fullName: json['name'],
      phoneNumber: json['phoneNumber'],
      dni: json['dni'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'found': found,
      'name': fullName,
      'phoneNumber': phoneNumber,
      'dni': dni,
    };
  }

  factory UserIdentificationModel.fromEntity(
      UserIdentification userIdentification) {
    return UserIdentificationModel(
      found: userIdentification.found,
      fullName: userIdentification.fullName,
      phoneNumber: userIdentification.phoneNumber,
      dni: userIdentification.dni,
    );
  }
}
