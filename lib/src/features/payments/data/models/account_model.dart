



import 'package:smart_cities/src/features/payments/domain/entities/account.dart';

class AccountModel extends Account{

  AccountModel(
  {String id,
  bool isActive,
  String paymentMethod,
  String paymentOwner,
  String creditCardNumber,
  String creditCardExpDate,
  String creditCardCvv,
  String creditCardType,
  String user,
  String createdAt,
  String updatedAt,
  int v
  }): super(
    id: id,
    isActive: isActive,
    paymentMethod: paymentMethod,
    paymentOwner: paymentOwner,
    creditCardNumber: creditCardNumber,
    creditCardCvv: creditCardCvv,
    creditCardType: creditCardType,
    user: user,
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v
  );

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json["_id"],
    isActive: json["isActive"],
    paymentMethod: json["paymentMethod"],
    paymentOwner: json["paymentOwner"],
    creditCardNumber: json["creditCardNumber"],
    creditCardExpDate: json["creditCardExpDate"],
    creditCardCvv: json["creditCardCVV"],
    creditCardType: json["creditCardType"],
    user: json["user"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isActive": isActive,
    "paymentMethod": paymentMethod,
    "paymentOwner": paymentOwner,
    "creditCardNumber": creditCardNumber,
    "creditCardExpDate": creditCardExpDate,
    "creditCardCVV": creditCardCvv,
    "creditCardType": creditCardType,
    "user": user,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };

}