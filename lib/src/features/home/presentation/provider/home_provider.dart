import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';




class HomeProvider extends BaseProvider {
  final LoggedUserUseCase loggedUserUseCase;

  bool isLogged;

  HomeProvider({@required this.loggedUserUseCase});

  void loadData() async {
    state = Loading();

    if(isLogged==null) {
      final logged = await loggedUserUseCase(NoParams());
      await logged.fold((failure) {
        isLogged = false;
      }, (user) {
        if (user != null) isLogged = true;
        isLogged = false;
      });
    }

  }




}