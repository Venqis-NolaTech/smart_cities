import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';

abstract class PaymentsRepository {

  Future<Either<Failure, List<CatalogItem>>> getBanks();

  Future<Either<Failure, Account>> createAccount({Map<String, dynamic> request});

  Future<Either<Failure, List<Account>>> listingAccount();

  Future<Either<Failure, Account>> detailAccount(String id);
}

