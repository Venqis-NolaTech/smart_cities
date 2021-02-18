


import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/reports/data/datasources/local/report_filter_data_source.dart';
import 'package:smart_cities/src/features/reports/domain/entities/report.dart';
import 'package:smart_cities/src/features/reports/domain/repositories/report_filter_repository.dart';
import 'package:meta/meta.dart';

class ReportFilterRepositoryImpl implements ReportFilterRepository{
  final ReportFilterDataSource reportFilterDataSource;

  ReportFilterRepositoryImpl({
    @required this.reportFilterDataSource,
  });



  @override
  Future<bool> clear() {
    return reportFilterDataSource.clear();
  }

  @override
  Future<Either<Failure, List<FilterReportItem>>> createParam() async {
    List<FilterReportItem> list=[
      FilterReportItem(
        key: ValuesFiltresKey.MY_REPORTS,
        title: 'Mis Reportes',
        value: await reportFilterDataSource.getValue(ValuesFiltresKey.MY_REPORTS) ?? true
      ),

      FilterReportItem(
          key: ValuesFiltresKey.IN_PROCESS,
          title: 'En Proceso',
          value: await reportFilterDataSource.getValue(ValuesFiltresKey.IN_PROCESS) ?? true
      ),

      FilterReportItem(
          key: ValuesFiltresKey.SOLUTION_COMPLETED,
          title: 'Resueltos',
          value: await reportFilterDataSource.getValue(ValuesFiltresKey.SOLUTION_COMPLETED) ?? true
      ),


      FilterReportItem(
          key: ValuesFiltresKey.NOT_ATTEND,
          title: 'No Atendidos',
          value: await reportFilterDataSource.getValue(ValuesFiltresKey.NOT_ATTEND) ?? true
      ),

      FilterReportItem(
          key: ValuesFiltresKey.AREA_PEDESTRIAN,
          title:  'Areas Peatonales',
          value: await reportFilterDataSource.getValue(ValuesFiltresKey.AREA_PEDESTRIAN) ?? true
      ),

      FilterReportItem(
          key: ValuesFiltresKey.AREA_RECREATIONAL,
          title: 'Areas Recreativas',
          value: await reportFilterDataSource.getValue(ValuesFiltresKey.AREA_RECREATIONAL) ?? true
      ),

      FilterReportItem(
          key: ValuesFiltresKey.AREA_GREEN,
          title: 'Areas Recreativas',
          value: await reportFilterDataSource.getValue(ValuesFiltresKey.AREA_GREEN) ?? true
      )

    ];

    return Right(list);
  }

  @override
  Future<bool> setParam(FilterReportItem value) {
    return reportFilterDataSource.setValue(value.key, !value.value);
  }

}
