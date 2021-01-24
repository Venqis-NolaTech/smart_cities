


import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/repositories/user_repository.dart';

class ValidateEmailUseCase implements UseCase<User, NoParams> {
  final FirebaseAuth firebaseAuth;
  final UserRepository userRepository;

  ValidateEmailUseCase({
    @required this.firebaseAuth,
    @required this.userRepository,
  });

  @override
  Future<Either<Failure, User>> call(NoParams params, {callback}) async {
    String projectAppID= '';
    try {
      projectAppID = await GetVersion.appID;
      final user = await userRepository.getProfile();

      user.fold(
              (l) => Left(UnexpectedFailure()),
              (user) async {

                var actionCodeSettings = ActionCodeSettings(
                    url: 'https://smartcitiesdevel.page.link/?email=' + user.email,
                    iOSBundleId: projectAppID,
                    androidPackageName: projectAppID,
                    handleCodeInApp: true,
                    androidInstallApp: true,
                    dynamicLinkDomain: 'smartcitiesdevel.page.link',
                    androidMinimumVersion: '16');

                firebaseAuth.sendSignInLinkToEmail(email: user.email, actionCodeSettings: actionCodeSettings).then((value) {
                  print('email enviado satisfactoriamente');

                }).catchError((error){
                  print(error.toString());
                  Left(UnexpectedFailure());
                });

                Right(user);

          });



    } on PlatformException {
      Left(UnexpectedFailure());
    }

  }



}