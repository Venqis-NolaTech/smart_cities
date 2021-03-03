import 'dart:io';

import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/get_municipality_use_case.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';

import '../../../../../app.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../core/util/device_info.dart';
import '../../../../shared/provider/base_provider.dart';
import '../../../../shared/provider/view_state.dart';
import '../../../auth/domain/usecases/get_params_use_case.dart';
import '../../../auth/domain/usecases/get_token_use_case.dart';
import '../../../auth/domain/usecases/logged_user_use_case.dart';
import '../../../auth/domain/usecases/refresh_profile_use_case.dart';
import '../../../welcome/presentation/page/welcome_page.dart';

class SplashProvider extends BaseProvider {
  SplashProvider({
    @required this.loggedUserUseCase,
    @required this.getTokenUseCase,
    @required this.getParamsUseCase,
    @required this.refreshProfileUseCase,
    @required this.deviceInfo,
    @required this.getMunicipalityUseCase,

    //@required this.getAllProvinceUseCase,
    //@required this.getAllInstitutionUseCase,
    //@required this.getAllRightsVioledUseCase,
    //@required this.getAllNationalityUseCase,
    bool inTest,
  }) : super(inTest: inTest);

  final LoggedUserUseCase loggedUserUseCase;
  final GetTokenUseCase getTokenUseCase;
  final GetParamsUseCase getParamsUseCase;
  final RefreshProfileUseCase refreshProfileUseCase;
  final DeviceInfo deviceInfo;

  final GetMunicipalityUseCase getMunicipalityUseCase;

  //final GetAllProvinceUseCase getAllProvinceUseCase;
  //final GetAllInstitutionUseCase getAllInstitutionUseCase;
  //final GetAllRightsVioledUseCase getAllRightsVioledUseCase;
  //final GetAllNationalityUseCase getAllNationalityUseCase;

  String _initialRoute = WelcomePage.id; //intro

  String get initialRoute => _initialRoute;

  Function(String) _callback;

  Future<void> initializeApp({Function(String) callback}) async {
    state = Loading();

    _callback = callback;

    await _checkUserIsLogged();

    if (currentUser!=null && _callback != null) {
      Future.delayed(
        Duration(milliseconds: 250),
            () => _callback(_initialRoute),
      );

      state= Loaded(value: currentUser);

    }else{
      //await _initializeRemoteParams();
      await _checkPermission();
      state= Loaded();
      if (_callback != null) {
        Future.delayed(
          Duration(milliseconds: 250),
              () => _callback(_initialRoute),
        );
      }
    }
  }


  Future _initializeRemoteParams() async {

    final failureOrProvinces = await getMunicipalityUseCase(NoParams());

    failureOrProvinces.fold(
      (_) {},
      (data) {
        //municipalitys = data;
        print('guardando el listado de municipios');
      },
    );

  }

  Future _checkUserIsLogged() async {
    final logged = await loggedUserUseCase(NoParams());

    await logged.fold(
      (failure) {
        //state = Error(failure: failure);
      },
      (user) async {
        if (user != null) {

          _initialRoute = MainPage.id; //temporal para pruebas
          currentUser = user;
          //await refreshProfileUseCase(null);
          //state = Loaded(value: user);
        }
      },
    );

  }

  // Future _getToken() async {
  //   final failureOrSuccess = await getTokenUseCase(NoParams());

  //   authHeaders = failureOrSuccess.fold(
  //     (_) => null,
  //     (token) => {"Authorization": 'Bearer $token'},
  //   );
  // }

  Future _checkPermission() async {
    bool permissionLocationisGranded = await Permission.location.isGranted;
    bool permissionStoreGranded = await Permission.storage.isGranted;

    bool validOsVersion = true;

    if (Platform.isAndroid) {
      int androidVersion = await deviceInfo.androidVersion();
      validOsVersion = androidVersion > 23;
    }

    if (permissionLocationisGranded && validOsVersion) {
      if (!permissionLocationisGranded) await Permission.location.request();
      if (!permissionStoreGranded) await Permission.storage.request();
    }
  }
}
