import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getProfile();

  Future<Either<Failure, User>> editProfile(User user);

  Future<Either<Failure, User>> updatePhoto(File file);

  Future<Either<Failure, bool>> registerDeviceToken({
    String deviceToken,
    String lang,
  });

  Future<Either<Failure, Map<String, dynamic>>> getParams(String lang);


  Future<Either<Failure, List<CatalogItem>>> getMunicipality();

  Future<Either<Failure, List<CatalogItem>>> getSectores(String keyMunicipality);

  Future<Either<Failure, List<CatalogItem>>> getNeighborhood(String keySector);

}
