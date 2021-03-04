import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/util/device_info.dart';

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
    @required this.deviceInfo,
    bool inTest,
  });

  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignInWithFacebookUseCase signInUserWithFacebookUseCase;
  final SignInWithGoogleUseCase signInUserWithGoogleUseCase;
  final DeviceInfo deviceInfo;

  bool _isHideSocialLogin = false;
  bool get isHideSocialLogin => _isHideSocialLogin;

  _setIsHideSocialLogin(bool value) {
    _isHideSocialLogin = value;

    notifyListeners();
  }

  void checkHideSocialLogin() async {
    final String jsonStr = remoteParams['hide_social_login'];

    if (jsonStr== null || jsonStr.isEmpty) return;

    final Map<String, dynamic> jsonMap = json.decode(jsonStr);

    if (jsonMap.isEmpty) return;

    final hideSocialLogin = HideSocialLogin.fromJson(jsonMap);

    final currentBuildNumber = await deviceInfo.buildNumber();
    final versionBuildNumber = hideSocialLogin.buildNumber;

    final isSameOs = hideSocialLogin.os == Platform.operatingSystem ||
        hideSocialLogin.os == "all";
    final isSameVersion = currentBuildNumber == versionBuildNumber;

    if (isSameOs && isSameVersion) _setIsHideSocialLogin(hideSocialLogin.hide);
  }

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

class HideSocialLogin {
  final String version;
  final String os;
  final bool hide;

  HideSocialLogin({this.version, this.os, this.hide});

  factory HideSocialLogin.fromJson(Map<String, dynamic> json) =>
      HideSocialLogin(
        version: json['version'],
        os: json['os'],
        hide: json['hide'],
      );

  int get buildNumber {
    if (version.isEmpty || version== null || version.indexOf(RegExp(r'(|)')) == -1)
      return 0;

    final start = version.indexOf('(') + 1;
    final end = version.indexOf(')');

    return int.parse(version.substring(start, end));
  }
}