import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';


abstract class PlacesRepository{


  Future<Either<Failure, dynamic>> listCategory();
  Future<Either<Failure, dynamic>> listPlaces();
  Future<Either<Failure, dynamic>> listPlacesByCategory();
  Future<Either<Failure, dynamic>> getPlace();

  Future<Either<Failure, dynamic>> sendComment();
  Future<Either<Failure, dynamic>> getComments();
  Future<Either<Failure, dynamic>> getMyComments();
  Future<Either<Failure, dynamic>> getNearbyPlaces();

}