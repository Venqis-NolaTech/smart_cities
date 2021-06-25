import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/help_line/domain/entities/streaming.dart';
import 'package:smart_cities/src/features/help_line/domain/repositories/streaming_repository.dart';
import 'package:meta/meta.dart';

class GetDataStreamingUseCase
    implements UseCase<Streaming, GetDataStreamingParams> {
  final StreamingRepository streamingRepository;

  GetDataStreamingUseCase({@required this.streamingRepository});

  @override
  Future<Either<Failure, Streaming>> call(GetDataStreamingParams params,
      {callback}) {
    return streamingRepository.getDataConnect(params.canal, params.latitude, params.longitude);
  }
}

class GetDataStreamingParams extends Equatable {
  final String canal;
  final double latitude;
  final double longitude;

  GetDataStreamingParams({@required this.latitude, @required this.longitude, @required this.canal});

  @override
  List<Object> get props => [];
}
