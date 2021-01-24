import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/catalog_item.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/data/datasources/local/user_data_source.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/remote/report_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl({
    @required this.reportDataSource,
    @required this.userLocalDataSource,
  });

  final ReportDataSource reportDataSource;
  final UserLocalDataSource userLocalDataSource;

  @override
  Future<Either<Failure, Report>> createReport(Map<String, dynamic> request) {
    return _process<Report>(
      () => reportDataSource.createReport(request),
    );
  }

  @override
  Future<Either<Failure, Report>> updateReport(
      String reportId, Map<String, dynamic> request) {
    return _process<Report>(
      () => reportDataSource.updateReport(reportId, request),
    );
  }

  @override
  Future<Either<Failure, ReportListing>> getGeneralReports(
      {int page, int count, String municipality}) {
    return _process<ReportListing>(
      () => reportDataSource.getGeneralReports(
        page: page,
        count: count,
        municipality: municipality
      ),
    );
  }

  @override
  Future<Either<Failure, List<Report>>> getNearbyReports(
      {double latitude, double longitude, double distance, String municipality}) {
    return _process<List<Report>>(
      () => reportDataSource.getNearbyReports(
        latitude: latitude,
        longitude: longitude,
        distance: distance,
        municipality: municipality
      ),
    );
  }

  @override
  Future<Either<Failure, ReportListing>> getMyReports({int page, int count}) {
    return _process<ReportListing>(
      () => reportDataSource.getMyReports(
        page: page,
        count: count,
      ),
    );
  }


  @override
  Future<Either<Failure, Report>> getReportById(String id) {
    return _process<Report>(() => reportDataSource.getReportById(id));
  }

  @override
  Future<Either<Failure, Report>> likeReport(String reportId) {
    return _process<Report>(
      () => reportDataSource.likeReport(reportId),
    );
  }

  @override
  Future<Either<Failure, ReportCommentListing>> getReportComments(
      String reportId,
      {int page,
      int count}) {
    return _process<ReportCommentListing>(
      () => reportDataSource.getReportComments(
        reportId,
        page: page,
        count: count,
      ),
    );
  }

  @override
  Future<Either<Failure, ReportComment>> createComment({
    String reportId,
    Map<String, dynamic> request,
  }) {
    return _process<ReportComment>(
      () => reportDataSource.createComment(
        reportId: reportId,
        request: request,
      ),
    );
  }


  @override
  Future<Either<Failure, ReportComment>> updateComment({String reportId, String commentId, Map<String, dynamic> request}) {
    return _process<ReportComment>(
          () => reportDataSource.updateComment(
        reportId: reportId,
        commentId: commentId,
        request: request,
      ),
    );
  }

  @override
  Future<Either<Failure, List<CatalogItem>>> getAllCategory() {
    return _process<List<CatalogItem>>(
          () => reportDataSource.getCategory(),
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
