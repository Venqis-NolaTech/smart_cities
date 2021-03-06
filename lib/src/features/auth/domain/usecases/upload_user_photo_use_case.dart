import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

class UploadUserPhotoUseCase extends UseCase<String, File> {
  UploadUserPhotoUseCase({
    @required this.firebaseStorage,
    @required this.firebaseAuth,
  });

  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth;

  @override
  Future<Either<Failure, String>> call(File file, {Callback callback}) async {
    try {
      final currentUser = firebaseAuth.currentUser;

      final fileRoute = 'profileImages/${currentUser.uid}.jpg';
      final StorageReference storageRef =
          firebaseStorage.ref().child(fileRoute);

      StorageUploadTask uploadTask = storageRef.putFile(file);

      final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

      String bucket = await downloadUrl.ref.getBucket();
      String path = await downloadUrl.ref.getPath();

      return Right('gs://$bucket/$path');
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }

    return Left(UnexpectedFailure());
  }
}
