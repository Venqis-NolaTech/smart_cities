import 'dart:io';

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';

import '../../../../../app.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/user_utils.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_data_source.dart';
import '../datasources/remote/user_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    @required this.firebaseStorage,
    @required this.userDataSource,
    @required this.userLocalDataSource,
  });

  final FirebaseStorage firebaseStorage;
  final UserDataSource userDataSource;
  final UserLocalDataSource userLocalDataSource;


  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final user = await userDataSource.getProfile();
      return user != null ? Right(user) : Left(UserNotFoundFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, User>> editProfile(User user) async {
    try {
      final request = UserModel.fromEntity(user);
      final userEdited = await userDataSource.editProfile(request);

      return _handleUser(userEdited);
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, User>> updatePhoto(File file) async {
    try {
      var user = userLocalDataSource.getUser();

      final photoURL = await UserUtils.uploadUserPhoto(
        firebaseStorage,
        user.uid,
        file,
      );

      final userEdited = await userDataSource.updatePhoto(photoURL);

      return _handleUser(userEdited);
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, bool>> registerDeviceToken(
      {String deviceToken, String lang}) async {
    try {
      final success = await userDataSource.registerDeviceToken(
        deviceToken: deviceToken,
        lang: lang,
      );

      return success ? Right(success) : Left(UnexpectedFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getParams(String lang) async {
    try {
      final params = await userDataSource.getParams(lang);
      return params != null ? Right(params) : Left(InfoNotFoundFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  // private methods --
  Either<Failure, UserModel> _handleUser(User user) {
    if (user != null) {
      currentUser = user;
      userLocalDataSource.setUser(user);
      return Right(currentUser);
    }

    return Left(UserNotFoundFailure());
  }

  @override
  Future<Either<Failure, List<CatalogItem>>> getMunicipality() async {
    try {
      final listado = await userDataSource.getMunicipality();
      return listado != null ? Right(listado) : Left(InfoNotFoundFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }



  Failure _handleFailure(e, StackTrace s) {
    FirebaseCrashlytics.instance.recordError(e, s);
    return UnexpectedFailure();
  }

  @override
  Future<Either<Failure, List<CatalogItem>>> getNeighborhood(String keySector) async {
    try {
      final listado = await userDataSource.getNeighborhood(keySector);
      return listado != null ? Right(listado) : Left(InfoNotFoundFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, List<CatalogItem>>> getSectores(String keyMunicipality) async {

    try {
      final listado = await userDataSource.getSectores(keyMunicipality);
      return listado != null ? Right(listado) : Left(InfoNotFoundFailure());
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }

  }
  // -- private methods
}
