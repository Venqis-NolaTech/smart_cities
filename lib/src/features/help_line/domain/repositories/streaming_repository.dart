import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/help_line/domain/entities/streaming.dart';

abstract class StreamingRepository {
  Future<Either<Failure, Streaming>> getDataConnect(
      String canal, double latitud, double longitud);
}