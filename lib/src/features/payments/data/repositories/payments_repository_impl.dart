import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/error/exception.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/payments/data/datasource/payment_data_source.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
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

  @override
  Future<Either<Failure, Account>> createAccount({Map<String, dynamic> request}) {
    return _process<Account>(
          () => paymentDataSource.createAccount(
        request: request,
      ),
    );

  }


  @override
  Future<Either<Failure, List<Account>>> listingAccount() {
    return _process<List<Account>>(
          () => paymentDataSource.listAccounts(),
    );

  }


  @override
  Future<Either<Failure, Account>> detailAccount(String id) {
    return _process<Account>(
          () => paymentDataSource.detailAccount(id),
    );

  }

  //--- private methods ---//
  Future<Either<Failure, T>> _process<T>(Future<T> Function() action) async {
    try {
      final result = await action();

      if (result == null) {
        return Left(UnexpectedFailure());
      }

      return Right(result);
    } catch (e, s) {
      switch (e.runtimeType) {
        case NotConnectionException:
          return Left(NotConnectionFailure());
        case UserNotFoundException:
          return Left(UserNotFoundFailure());
        default:
          FirebaseCrashlytics.instance.recordError(e, s);

          return Left(UnexpectedFailure());
      }
    }
  }



}