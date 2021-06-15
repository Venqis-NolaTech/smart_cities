import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/help_line/domain/entities/streaming.dart';
import 'package:smart_cities/src/features/help_line/domain/repositories/streaming_repository.dart';
import 'package:smart_cities/src/features/payments/domain/usescase/get_detail_account_use_case.dart';
import 'package:meta/meta.dart';



class GetDataStreamingUseCase implements UseCase<Streaming, GetDataStreamingParams> {

  final StreamingRepository streamingRepository;

  GetDataStreamingUseCase({@required  this.streamingRepository});

  @override
  Future<Either<Failure, Streaming>> call(GetDataStreamingParams params, {callback}) {
    return streamingRepository.getDataConnect(params.canal);

   /*
     @override
  Future<Either<Failure, Account>> call(GetDetailAccountParams params, {callback}) {
    return paymentsRepository.detailAccount(params.idAccount);
  }
    */
  }




}


class GetDataStreamingParams extends Equatable{
  final String canal;

  GetDataStreamingParams({@required this.canal});

  @override
  List<Object> get props => [];

}