import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/help_line/data/datasource/streaming_data_source.dart';
import 'package:smart_cities/src/features/help_line/domain/entities/streaming.dart';
import 'package:smart_cities/src/features/help_line/domain/repositories/streaming_repository.dart';

class StreamingRepositoryImpl implements StreamingRepository{
  final StreamingDataSource streamingDataSource;

  StreamingRepositoryImpl({this.streamingDataSource});

  @override
  Future<Either<Failure, Streaming>> getDataConnect(String canal, double latitude, double longitude) async {
    try {
      final data = await streamingDataSource.getDataConnect(canal, latitude, longitude);
      return data != null ? Right(data) : Left(InfoNotFoundFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  Failure _handleFailure(e, StackTrace s) {
    FirebaseCrashlytics.instance.recordError(e, s);
    return UnexpectedFailure();
  }
}