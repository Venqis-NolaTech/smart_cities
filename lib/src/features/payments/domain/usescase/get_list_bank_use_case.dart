import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/payments/domain/repositories/payment_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class GetListBankUseCase implements UseCase<List<CatalogItem>, NoParams> {

  final PaymentsRepository paymentsRepository;

  GetListBankUseCase({@required  this.paymentsRepository});

  @override
  Future<Either<Failure, List<CatalogItem>>> call(NoParams params, {callback}) {
    return paymentsRepository.getBanks();
  }


}