import 'package:meta/meta.dart';

import '../../../../../core/usecases/use_case.dart';
import '../../../../../shared/provider/base_provider.dart';
import '../../../domain/usecases/send_email_verification_use_case.dart';

class EmailConfirmationProvider extends BaseProvider {
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;

  EmailConfirmationProvider({@required this.sendEmailVerificationUseCase});

  void refresh() => notifyListeners();

  Future<void> sendEmailVerification() async  {
    var result= await sendEmailVerificationUseCase(NoParams());

    result.fold((l) => print('fallo al enviar correo de validacion'), (r) => 'correo enviado exitosamente');
  }
}
