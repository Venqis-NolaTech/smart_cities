import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../../app.dart';




class HomeProvider extends BaseProvider {
  final LoggedUserUseCase loggedUserUseCase;

  bool isLogged= currentUser == null ? false : true;

  HomeProvider({@required this.loggedUserUseCase});

  void loadData() async {
    state = Loading();



  }




}