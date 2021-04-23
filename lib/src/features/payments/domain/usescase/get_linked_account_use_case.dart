import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
import 'package:smart_cities/src/features/payments/domain/repositories/payment_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class GetLinkedAccountUseCase implements UseCase<List<Account>, NoParams> {

  final PaymentsRepository paymentsRepository;

  GetLinkedAccountUseCase({@required  this.paymentsRepository});

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params, {callback}) {
    return paymentsRepository.listingAccount();
  }


}