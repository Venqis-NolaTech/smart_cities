import 'package:meta/meta.dart';

import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/usecases/forgot_password_use_case.dart';

class ForgotPasswordProvider extends BaseProvider {
  ForgotPasswordProvider({@required this.forgotPasswordUseCase});

  final ForgotPasswordUseCase forgotPasswordUseCase;

  void loading() => state = Loading();

  void loaded() => state = Loaded();

  Future<void> sendEmail(String email) async {
    state = Loading();

    final result = await forgotPasswordUseCase(email);

    result.fold(
      (failure) => state = Error(failure: failure),
      (_) => state = Loaded(),
    );
  }
}
