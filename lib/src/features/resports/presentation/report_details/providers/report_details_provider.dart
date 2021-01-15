import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/like_report_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/update_report_comment_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/upload_comment_report_file_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/upload_report_file_use_case.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/providers/base_new_report_form_provider.dart';


import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/usecases/create_report_comment_use_case.dart';
import '../../../domain/usecases/get_report_by_id_use_case.dart';

class ReportDetailsProvider extends BaseNewReportFormProvider {
  ReportDetailsProvider({
    @required this.getReportByIdUseCase,
    @required this.createReportCommentUseCase,
    @required this.updateReportCommentUseCase,
    @required this.likeReportUseCase,
    @required this.uploadReportFileUseCase,
    bool inTest,
  }) : super();

  final GetReportByIdUseCase getReportByIdUseCase;
  final CreateReportCommentUseCase createReportCommentUseCase;
  final UpdateReportCommentUseCase updateReportCommentUseCase;
  final LikeReportUseCase likeReportUseCase;
  final UploadCommentReportFileUseCase uploadReportFileUseCase;

  ViewState commentPostState = Idle();

  String _reportId;

  String _comment = "";

  String get comment => _comment;

  set comment(String comment) {
    _comment = comment;

    notifyListeners();
  }

  bool _isAnonymous= false;

  set isAnonymous(bool value) {
    _isAnonymous = value;

    notifyListeners();
  }


  @override
  Future<void> refreshData() async {
    super.refreshData();

    getReportById(_reportId);
  }

  void getReportById(String id) async {
    print('reporte $id');
    state = Loading();

    _reportId = id;

    final failureOrReport = await getReportByIdUseCase(id);

    failureOrReport.fold(
      (failure) => state = Error(failure: failure),
      (report) => state = Loaded<Report>(value: report),
    );
  }

  void likeReport() async {
    if (_reportId == null) return;
    state = Loading();

    final failureOrSuccess = await likeReportUseCase(_reportId);

    failureOrSuccess.fold(
      (failure) => state = Error(failure: failure),
      (report) => state = Loaded<Report>(value: report),
    );
  }

  void createComment() async {
    state = Loading();

    final params = CreateReportCommentParams(
      reportId: _reportId,
      comment: {
        DataKey.COMMENT : comment,
        DataKey.ISANONYMOUS  : _isAnonymous,
        /*"pictureURL" : [
          "gs://smartcities-devel.appspot.com/reportscomments/default.png"
        ]*/
      },
    );

    final failureOrCommentCreated = await createReportCommentUseCase(params);

    await failureOrCommentCreated.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (commentCreated)  async {

        if(commentCreated!=null){
          final urls = await _uploadFiles(commentCreated.id);

          if (urls.isNotEmpty) {
            final request = {DataKey.PICTUREURL: urls};

            await _updateComment(_reportId, commentCreated.id, request);
          }

          files.clear();
          state = Loaded<ReportComment>(value: commentCreated);
          _comment = "";
          isAnonymous= false;
          refreshData();


        }
      },
    );
  }

  Future<List<String>> _uploadFiles(String commentId) async {
    List<String> urls = [];

    if (files.isNotEmpty) {
      final params = UploadCommentFileParams(
        files: files,
        commentId: commentId,
      );

      final failureOrSuccess = await uploadReportFileUseCase(params);
      failureOrSuccess.fold(
            (failure) => state = Error(failure: failure),
            (fileUrls) => urls = fileUrls,
      );
    }

    return urls;
  }

  Future _updateComment(String reportId, String commentId, Map<String, dynamic> request) async {
    final params = UpdateReportCommentParams(
        reportId: reportId,
        commentId: commentId,
        request: request);

    final failureOrSuccess = await updateReportCommentUseCase(params);

    failureOrSuccess.fold(
          (failure) => state = Error(failure: failure),
          (report) => state = Loaded(value: report),
    );
  }

  @override
  Future initData() {

  }

  @override
  Future submitData() {

  }
}
