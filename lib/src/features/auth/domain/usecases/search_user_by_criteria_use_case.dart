import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SearchUserByCriteriaUserUseCase
    implements UseCase<UserListings, SearchUserByCriteriaParams> {
  SearchUserByCriteriaUserUseCase({
    @required this.userRepository,
  });

  final UserRepository userRepository;

  @override
  Future<Either<Failure, UserListings>> call(SearchUserByCriteriaParams params,
      {Callback callback}) async {
    return userRepository.searchUserByName(
      page: params.page,
      count: params.count,
      criteria: params.criteria,
      channelId: params.channelId,
      inChannel: params.inChannel,
    );
  }
}

class SearchUserByCriteriaParams extends ListingsParams {
  final String criteria;
  final String channelId;
  final bool inChannel;

  SearchUserByCriteriaParams({
    this.criteria,
    this.channelId,
    this.inChannel,
    int page,
    int count,
  }) : super(
          page: page,
          count: count,
        );

  @override
  List<Object> get props => [
        criteria,
        channelId,
        inChannel,
        ...super.props,
      ];
}
