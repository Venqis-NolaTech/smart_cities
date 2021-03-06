import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
import 'package:smart_cities/src/features/payments/domain/repositories/payment_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class GetDetailAccountUseCase implements UseCase<Account, GetDetailAccountParams> {

  final PaymentsRepository paymentsRepository;

  GetDetailAccountUseCase({@required  this.paymentsRepository});

  @override
  Future<Either<Failure, Account>> call(GetDetailAccountParams params, {callback}) {
    return paymentsRepository.detailAccount(params.idAccount);
  }


}
class GetDetailAccountParams extends Equatable{
  final String idAccount;

  GetDetailAccountParams({this.idAccount});

  @override
  List<Object> get props => [];


}
