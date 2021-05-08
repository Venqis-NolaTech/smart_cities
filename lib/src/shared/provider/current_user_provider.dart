import '../../core/usecases/use_case.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/domain/usecases/logged_user_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import 'base_provider.dart';
import 'view_state.dart';

abstract class CurrentUserProvider extends BaseProvider {
  CurrentUserProvider({
    this.loggedUserUseCase,
    this.logoutUseCase,
  });

  final LoggedUserUseCase loggedUserUseCase;
  final LogoutUseCase logoutUseCase;

  User _user;

  User get user => _user;

  Future getUser({bool notify = true}) async {
    if (loggedUserUseCase == null) throw ("LoggedUserUseCase can't be null");

    if (notify) state = Loading();

    final failureOrUser = await loggedUserUseCase(NoParams());

    failureOrUser.fold(
      (failure) {
        _user = null;
        if (notify) state = Error(failure: failure);
      },
      (user) {
        _user = user;
        if (notify) state = Loaded();
      },
    );
  }

  Future<void> logout() async {
    if (logoutUseCase == null) throw ("LogoutUseCase can't be null");

    state = Loading();

    final failureOrLogount = await logoutUseCase(NoParams());

    failureOrLogount.fold(
      (failure) => state = Error(failure: failure),
      (r) => state = Loaded(),
    );
  }
}
