import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../core/util/file_util.dart';

class UploadReportFileUseCase
    extends UseCase<List<String>, UploadReportFileParams> {
  UploadReportFileUseCase({
    @required this.firebaseStorage,
  });

  final FirebaseStorage firebaseStorage;

  @override
  Future<Either<Failure, List<String>>> call(UploadReportFileParams params,
      {Callback<double> callback}) async {
    try {
      final reportId = params.reportId;
      final files = params.files;

      List<String> uploadUrls = [];
      int count = 0;

      await Future.wait(files.map((File file) async {
        count++;

        final fileRoute =
            'reportFiles/${reportId}_$count.${file.extensionName}';
        final StorageReference storageRef =
            firebaseStorage.ref().child(fileRoute);

        StorageUploadTask uploadTask = storageRef.putFile(file);

        final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

        String bucket = await downloadUrl.ref.getBucket();
        String path = await downloadUrl.ref.getPath();

        uploadUrls.add('gs://$bucket/$path');
      }));

      return Right(uploadUrls);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }

    return Left(UnexpectedFailure());
  }
}

class UploadReportFileParams extends Equatable {
  final List<File> files;
  final String reportId;

  UploadReportFileParams({this.files, this.reportId});

  @override
  List<Object> get props => [files, reportId];
}
