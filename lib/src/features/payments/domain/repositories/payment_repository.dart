import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';

abstract class PaymentsRepository {

  Future<Either<Failure, List<CatalogItem>>> getBanks();

}

