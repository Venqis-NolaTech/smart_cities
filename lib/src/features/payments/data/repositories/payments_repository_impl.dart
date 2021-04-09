import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/payments/data/datasource/payment_data_source.dart';
import 'package:smart_cities/src/features/payments/domain/repositories/payment_repository.dart';

class PaymentsRepositoryImpl implements PaymentsRepository{
  final PaymentDataSource paymentDataSource;

  PaymentsRepositoryImpl({@required this.paymentDataSource});

  @override
  Future<Either<Failure, List<CatalogItem>>> getBanks() async {

    try {
      final banks = await paymentDataSource.bankList();
      return banks != null ? Right(banks) : Left(InfoNotFoundFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  Failure _handleFailure(e, StackTrace s) {
    FirebaseCrashlytics.instance.recordError(e, s);
    return UnexpectedFailure();
  }


}