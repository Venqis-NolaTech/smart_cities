import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';



class PaymentsProvider extends BaseProvider{
  final LoggedUserUseCase loggedUserUseCase;

  PaymentsProvider({
    @required this.loggedUserUseCase,
  });

  Future loadData() async {
    state = Loading();

    final logged = await loggedUserUseCase(NoParams());

    await logged.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        state = Loaded();

        loadAccount();
      },
    );
  }

  Future<void> loadAccount() async  {




  }






}