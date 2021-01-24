import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/catalog_item.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/report_repository.dart';

class GetAllCategoryUseCase extends UseCase<List<CatalogItem>, NoParams> {
  final ReportRepository reportRepository;

  GetAllCategoryUseCase({@required this.reportRepository});

  @override
  Future<Either<Failure, List<CatalogItem>>> call(
    NoParams params, {
    Callback callback,
  }) {
    return reportRepository.getAllCategory();
  }
}
