

import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';

abstract class ReportRepository {
  Future<Either<Failure, Report>> createReport(Map<String, dynamic> request);

  Future<Either<Failure, Report>> updateReport(
      String reportId,
      Map<String, dynamic> request,
      );

  Future<Either<Failure, ReportListing>> getGeneralReports({
    int page,
    int count,
    String municipality
  });

  Future<Either<Failure, ReportListing>> getMyReports({int page, int count});

  Future<Either<Failure, List<Report>>> getNearbyReports({
    double latitude,
    double longitude,
    double distance,
    String municipality
  });

  Future<Either<Failure, Report>> getReportById(String id);

  Future<Either<Failure, Report>> likeReport(String reportId);

  Future<Either<Failure, ReportCommentListing>> getReportComments(
      String reportId, {
        int page,
        int count,
      });

  Future<Either<Failure, ReportComment>> createComment({
    String reportId,
    Map<String, dynamic> request,
  });


  Future<Either<Failure, ReportComment>> updateComment({
    String reportId,
    String commentId,
    Map<String, dynamic> request,
  });


  Future<Either<Failure, List<CatalogItem>>> getAllCategory();
}
