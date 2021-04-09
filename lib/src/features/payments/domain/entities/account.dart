
import 'package:equatable/equatable.dart';



class Account extends Equatable{
  Account({
    this.id,
    this.balance,
    this.isActive,
    this.accountOwner,
    this.accountType,
    this.systemCode,
    this.user,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.v,
  });


  final String id;
  final int balance;
  final bool isActive;
  final String accountOwner;
  final String accountType;
  final String systemCode;
  final String user;
  final PaymentMethod paymentMethod;
  final String createdAt;
  final String updatedAt;
  final int v;


  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.isActive,
    this.paymentMethod,
    this.paymentOwner,
    this.creditCardNumber,
    this.creditCardExpDate,
    this.creditCardCvv,
    this.creditCardType,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String id;
  bool isActive;
  String paymentMethod;
  String paymentOwner;
  String creditCardNumber;
  String creditCardExpDate;
  String creditCardCvv;
  String creditCardType;
  String user;
  String createdAt;
  String updatedAt;
  int v;

}

