import 'package:meta/meta.dart';

import '../../../../../../app.dart';
import '../../../../../core/usecases/use_case.dart';
import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/usecases/signin_with_email_use_case.dart';
import '../../../domain/usecases/signin_with_facebook_use_case.dart';
import '../../../domain/usecases/signin_with_google_use_case.dart';

class SignInProvider extends BaseProvider {
  SignInProvider({
    @required this.signInWithEmailUseCase,
    @required this.signInUserWithFacebookUseCase,
    @required this.signInUserWithGoogleUseCase,
    bool inTest,
  });

  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignInWithFacebookUseCase signInUserWithFacebookUseCase;
  final SignInWithGoogleUseCase signInUserWithGoogleUseCase;

  void loading() => state = Loading();

  void loaded() => state = Loaded();

  Future<void> accesWithEmail({
    @required String email,
    @required String password,
  }) async {
    state = Loading();

    final params = SignInWithEmailUseCaseParams(
      email: email,
      password: password,
    );

    final result = await signInWithEmailUseCase(params);

    result.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        currentUser = user;

        state = Loaded();
      },
    );
  }

  Future<void> accessWithFacebook() async {
    state = Loading();

    final result = await signInUserWithFacebookUseCase(NoParams());

    result.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        currentUser = user;

        state = Loaded();
      },
    );
  }

  Future<void> accessWithGoogle() async {
    state = Loading();

    final result = await signInUserWithGoogleUseCase(NoParams());

    result.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        currentUser = user;

        state = Loaded();
      },
    );
  }
}
