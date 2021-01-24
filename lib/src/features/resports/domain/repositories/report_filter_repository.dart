import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';

abstract class ReportFilterRepository {
  Future<Either<Failure,  List<FilterReportItem>>> createParam();
  Future<bool> clear();
  Future<bool> setParam(FilterReportItem value);
}
