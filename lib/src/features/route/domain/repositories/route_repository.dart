


import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/route/domain/entities/sector.dart';

abstract class  RouteRepository{
  Future<Either<Failure, Sector>> getSector(String sector);

  Future<Either<Failure, dynamic>> createComment({
    String sectorId,
    Map<String, dynamic> request,
  });

  Future<Either<Failure, dynamic>> getComments(
      String sectorId, {
        int page,
        int count,
      });


}