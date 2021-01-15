import 'package:meta/meta.dart';
import 'package:smart_cities/app.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/features/resports/domain/usecases/like_report_use_case.dart';

import '../../../../../core/usecases/use_case.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../../auth/domain/usecases/get_current_location_use_case.dart';
import '../../../domain/usecases/get_nearby_reports_use_case.dart';

class NearbyReportProvider extends BaseProvider {
  NearbyReportProvider({
    @required this.getCurrentLocationUseCase,
    @required this.getNearbyReportsUseCase,
    @required this.loggedUserUseCase,
    @required this.likeReportUseCase,

  });

  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetNearbyReportsUseCase getNearbyReportsUseCase;
  final LoggedUserUseCase loggedUserUseCase;
  final LikeReportUseCase likeReportUseCase;


  final distance = 1000.0;

  Position _location;

  Position get location => _location;

  @override
  Future<void> refreshData() async {
    super.refreshData();

    loadReports();
  }

  Future loadReports() async {
    state = Loading();

    final logged = await loggedUserUseCase(NoParams());

    await logged.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) async {
        if (_location == null) await _getCurrentLocation();

        _getNearbyReports();
      },
    );
  }

  Future refreshLocation() async {
    await _getCurrentLocation();

    notifyListeners();
  }

  void _getCurrentLocation() async {
    final failureOrLocation = await getCurrentLocationUseCase(NoParams());
    final location = failureOrLocation.fold(
        (_) => Position(
              latitude: kDefaultLocation.latitude,
              longitude: kDefaultLocation.longitude,
            ),
        (location) => location);

    _location = location;
  }

  void _getNearbyReports() async {
    final params = NearbyParams(
      latitude: _location.latitude,
      longitude: _location.longitude,
      distance: distance,
      municipality: currentUser.municipality.key
    );

    final failureOrReports = await getNearbyReportsUseCase(params);

    failureOrReports.fold(
      (failure) => state = Error(failure: failure),
      (reports) => state = Loaded(value: reports),
    );
  }


  void followReport(Report report) async {

    state = Loading();

    final failureOrSuccess = await likeReportUseCase(report.id);

    failureOrSuccess.fold(
          (failure) => state = Error(failure: failure),
          (report) => state = Loaded<Report>(value: report),
    );

  }
}
