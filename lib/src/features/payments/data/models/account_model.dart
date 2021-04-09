



import 'package:smart_cities/src/features/payments/domain/entities/account.dart';

class AccountModel extends Account{

  AccountModel({
    String id,
    int balance,
    bool isActive,
    String accountOwner,
    String accountType,
    String systemCode,
    String user,
    PaymentMethod paymentMethod,
    String createdAt,
    String updatedAt,
    int v
  }): super(
    id: id,
    balance: balance,
    isActive: isActive,
    accountOwner: accountOwner,
    accountType: accountType,
    systemCode: systemCode,
    user: user,
    paymentMethod: paymentMethod,
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v
  );

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json["_id"],
    balance: json["balance"],
    isActive: json["isActive"],
    accountOwner: json["accountOwner"],
    accountType: json["accountType"],
    systemCode: json["systemCode"],
    user: json["user"],
    paymentMethod: PaymentMethodModel.fromJson(json["paymentMethod"]),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "balance": balance,
    "isActive": isActive,
    "accountOwner": accountOwner,
    "accountType": accountType,
    "systemCode": systemCode,
    "user": user,
    "paymentMethod": paymentMethod!= null ? PaymentMethodModel.fromEntity(paymentMethod).toJson() : null,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };

}

class PaymentMethodModel extends PaymentMethod{
  PaymentMethodModel({
    String id,
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
    int v,
  }): super(
    id: id,
    isActive: isActive,
    paymentMethod: paymentMethod,
    paymentOwner: paymentOwner,
    creditCardNumber: creditCardNumber,
    creditCardExpDate: creditCardExpDate,
    creditCardCvv: creditCardCvv,
    creditCardType: creditCardType,
    user: user,
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v
  );


  factory PaymentMethodModel.fromEntity(PaymentMethod paymentMethod) {
    return PaymentMethodModel(
      id: paymentMethod.id,
      isActive: paymentMethod.isActive,
      paymentMethod: paymentMethod.paymentMethod,
      paymentOwner: paymentMethod.paymentOwner,
      creditCardNumber: paymentMethod.creditCardNumber,
      creditCardExpDate: paymentMethod.creditCardExpDate,
      creditCardCvv: paymentMethod.creditCardCvv,
      creditCardType: paymentMethod.creditCardType,
      user: paymentMethod.user,
      createdAt: paymentMethod.createdAt,
      updatedAt: paymentMethod.updatedAt,
      v: paymentMethod.v
    );
  }



  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
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

