import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/app.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetNearbyReportsUseCase extends UseCase<List<Report>, NearbyParams> {
  final ReportRepository reportRepository;

  GetNearbyReportsUseCase({@required this.reportRepository});

  @override
  Future<Either<Failure, List<Report>>> call(
    NearbyParams params, {
    Callback callback,
  }) {
    return reportRepository.getNearbyReports(
      latitude: params.latitude,
      longitude: params.longitude,
      distance: params.distance,
      municipality: params.municipality
    );
  }
}

class NearbyParams extends Equatable {
  final double latitude;
  final double longitude;
  final double distance;
  final String municipality;

  NearbyParams({this.municipality, this.latitude, this.longitude, this.distance});

  @override
  List<Object> get props => [latitude, longitude, distance];
}
