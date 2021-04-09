
import 'package:equatable/equatable.dart';



class Account extends Equatable{
  Account({
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

  @override
  // TODO: implement props
  List<Object> get props => [id];
}