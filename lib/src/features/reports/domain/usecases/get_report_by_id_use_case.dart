import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../auth/domain/repositories/user_local_repository.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetReportByIdUseCase extends UseCase<Report, String> {
  GetReportByIdUseCase({
    @required this.reportRepository,
    @required this.userLocalRepository,
  });

  final ReportRepository reportRepository;
  final UserLocalRepository userLocalRepository;

  @override
  Future<Either<Failure, Report>> call(
    String id, {
    Callback callback,
  }) async =>
      reportRepository.getReportById(id);

  // @override
  // Future<Either<Failure, Report>> call(
  //   String id, {
  //   Callback callback,
  // }) async {

  //   final failureOrUser = userLocalRepository.getCurrentUser();

  //   return failureOrUser.fold(
  //     (failure) {
  //       return Left(failure);
  //     },
  //     (user) async {
  //       return await reportRepository.getReportById(id);

  //       // return failureOrReport.fold(
  //       //   (failure) {
  //       //     return Left(failure);
  //       //   },
  //       //   (report) {
  //       //     final isFavorite = false;
  //           //= user?.reports?.contains(report.id) ?? false;

  //           // return Right(
  //           //   ReportModel(
  //           //     id: report.id,
  //           //     status: report.status,
  //           //     latitude: report.latitude,
  //           //     longitude: report.longitude,
  //           //     category: report.category,
  //           //     title: report.title,
  //           //     description: report.description,
  //           //     // pictureUrls: report.pictureUrls,
  //           //     // pdfUrl: report.pdfUrl,
  //           //     managedBy: report.managedBy,
  //           //     lastComments: report.lastComments,
  //           //     favorite: isFavorite,
  //           //     createdAt: report.createdAt,
  //           //     updatedAt: report.updatedAt,
  //           //   ),
  //           // );
  //         // },
  //       );
  //     },
  //   );
  // }
}
