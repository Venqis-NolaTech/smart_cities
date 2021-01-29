import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/get_current_location_use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/get_all_category_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/get_neighborhood_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/get_sectores_use_case.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/paginated_provider.dart';

import '../../../../../../app.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/util/list_util.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../domain/usecases/create_report_use_case.dart';
import '../../../domain/usecases/update_report_use_case.dart';
import '../../../domain/usecases/upload_report_file_use_case.dart';

import 'base_new_report_form_provider.dart';

class CreateReportProvider extends BaseNewReportFormProvider {
  CreateReportProvider( {
    @required this.createReportUseCase,
    @required this.updateReportUseCase,
    @required this.uploadReportFileUseCase,

    @required this.getAllCategoryUseCase,
    @required this.getSectoresUseCase,
    @required this.getNeighborhoodUseCase,
    @required this.getCurrentLocationUseCase,
    @required this.loggedUserUseCase,
  });

  final CreateReportUseCase createReportUseCase;
  final UpdateReportUseCase updateReportUseCase;
  final UploadReportFileUseCase uploadReportFileUseCase;
  final GetAllCategoryUseCase getAllCategoryUseCase;


  final GetSectoresUseCase getSectoresUseCase;
  final GetNeighborhoodUseCase getNeighborhoodUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final LoggedUserUseCase loggedUserUseCase;


  String nameStreet;
  String numberStreet;
  String titleReport;
  String descriptionReport;
  bool postYourName= true;

  /// VECINDARIOS
  List<CatalogItem> allNeighborhood=[];
  CatalogItem _selectedNeighborhood;

  CatalogItem get selectedNeighborhood => _selectedNeighborhood;

  set selectedNeighborhood(CatalogItem value) {
    _selectedNeighborhood=value;
    notifyListeners();
  }

  /// SECTORES
  List<CatalogItem> allSectores=[];
  CatalogItem _selectedSector;

  CatalogItem get selectedSector => _selectedSector;

  set selectedSector(CatalogItem value) {
    _selectedSector=value;
    notifyListeners();
  }


  /// CATEGORIA
  List<CatalogItem> allCategory=[];

  CatalogItem _selectedCategory;

  CatalogItem get selectedCategory => _selectedCategory;

  set selectedCategory(CatalogItem value) {
    _selectedCategory=value;
    notifyListeners();
  }

  ///UBICATION
  Position _location;

  Position get location => _location;

  final Map<String, dynamic> _reportData = {
    //DataKey.ISSUE_DATE: DateTime.now().toIso8601String(),
  };
  Map<String, dynamic> get reportData => _reportData;

  bool _isAnonymous = true;

  bool get isAnonymous => _isAnonymous;

  set isAnonymous(bool value) {
    _isAnonymous = value;
    notifyListeners();
  }

  /*final List<File> _photos = [];

  List<File> get photos => _photos;

  bool get isPhotoNotEmpty => _photos.isNotEmpty;


  void addPhoto(File photo, {bool notify = true}) {
    _photos.add(photo);

    if (notify) notifyListeners();
  }

  void removePhoto(File photo) {
    _photos.remove(photo);

    notifyListeners();
  }

  bool addPhotoIsValid() => _photos.length < kMaxFiles;*/


  @override
  Future initData() async {
    state = Loading();

    final logged = await loggedUserUseCase(NoParams());

    await logged.fold(
          (failure) {
        state = Error(failure: failure);
      },
          (user) async {
        if (user != null) {

          if (_location == null) await _getCurrentLocation();


          final failureOrSuccess = await getAllCategoryUseCase(NoParams());

          await failureOrSuccess.fold(
                (failure) {
              state = Error(failure: failure);
            },
                (listCategory) async {
              if (listCategory.isNotNullOrNotEmpty) {
                allCategory = listCategory;
                state = Loaded();
              } else {
                state = Error(failure: UnexpectedFailure());
              }
            },
          );

          var result= await getSectoresUseCase(NoParams());

          await result?.fold(
                (failure) {
              print('fallo al actualizar sectores');
            },
                (list) async {
              if (list.isNotNullOrNotEmpty) {
                allSectores = list;
                print('actualizada listado de sectores');
                notifyListeners();
              }
            },
          );


        }
      },
    );




  }

  Future<void> getNeighborhood() async {
    state = Loading();
    var result = await getNeighborhoodUseCase(selectedSector.key);

    await result.fold(
      (failure) => state = Error(failure: failure),
      (list) async {
        if (list.isNotNullOrNotEmpty) {
          allNeighborhood = list;
          print('actualizada listado de vecindarios');
        }
        state = Loaded();
      },
    );
  }



  Future<void> _getCurrentLocation() async {
    final failureOrLocation = await getCurrentLocationUseCase(NoParams());
    final location = failureOrLocation.fold(
            (_) => Position(
          latitude: kDefaultLocation.latitude,
          longitude: kDefaultLocation.longitude,
        ),
            (location) => location);

    _location = location;

    failureOrLocation.fold(
            (failure) {
              state = Error(failure: failure);
            },
            (location) => null);

  }




  @override
  Future submitData() async {
    final payload = {
      DataKey.MUNICIPALITY: currentUser.municipality.key,
      DataKey.SECTOR: selectedSector.key,
      DataKey.NEIGHBORHOOD: selectedNeighborhood.key,
      DataKey.TITLE: titleReport,
      DataKey.DESCRIPTION: descriptionReport,
      DataKey.LATITUDE: location.latitude,
      DataKey.LONGITUDE: location.longitude,
      DataKey.CATEGORY: selectedCategory.key,
      DataKey.STREET: nameStreet,
      DataKey.NUMBER_ADDRESS: numberStreet,
      DataKey.ISANONYMOUS: !postYourName
    };

    await _createReport(payload);
  }


  Future _createReport(Map<String, dynamic> request) async {
    if (request != null && request.isEmpty) return;

    state = Loading();

    final failureOrSuccess = await createReportUseCase(request);

    await failureOrSuccess.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (report) async {
        if (report != null) {
          final urls = await _uploadFiles(report.id);

          if (urls.isNotNullOrNotEmpty) {
            final request = {DataKey.IMAGES: urls};

            await _updateReport(report.id, request);
          } else {
            state = Loaded(value: report);
          }
        } else {
          state = Error(failure: UnexpectedFailure());
        }
      },
    );
  }

  Future _updateReport(String reportId, Map<String, dynamic> request) async {
    final params = UpdateReportParams(reportId: reportId, request: request);

    final failureOrSuccess = await updateReportUseCase(params);

    failureOrSuccess.fold(
      (failure) => state = Error(failure: failure),
      (report) => state = Loaded(value: report),
    );
  }

  Future<List<String>> _uploadFiles(String reportId) async {
    List<String> urls = [];

    if (files.isNotEmpty) {
      final params = UploadReportFileParams(
        files: files,
        reportId: reportId,
      );

      final failureOrSuccess = await uploadReportFileUseCase(params);
      failureOrSuccess.fold(
        (failure) => state = Error(failure: failure),
        (fileUrls) => urls = fileUrls,
      );
    }

    return urls;
  }

  bool isValidLocation() {
    if(selectedSector==null || selectedNeighborhood==null || nameStreet==null  || numberStreet==null){
      return false;
    }else
      return true;
  }



  bool isValidDescription() {
    if(titleReport==null || descriptionReport ==null){
      return false;
    }else
      return true;
  }

  @override
  Future<Either<Failure, PageData<ReportComment>>> processRequest() {

  }
}
