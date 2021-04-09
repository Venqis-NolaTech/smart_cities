
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
import 'package:smart_cities/src/features/payments/domain/repositories/payment_repository.dart';

class SaveAccountsUseCase implements UseCase<Account, CreateAccountParams >{

  final PaymentsRepository paymentsRepository;
  SaveAccountsUseCase({@required  this.paymentsRepository});

  @override
  Future<Either<Failure, Account>> call(CreateAccountParams params, {callback}) async {
    return paymentsRepository.createAccount(request: params.data);
  }
}


class CreateAccountParams  extends Equatable {
  final Map<String, dynamic> data;

  CreateAccountParams({this.data});

  @override
  List<Object> get props => [];

}