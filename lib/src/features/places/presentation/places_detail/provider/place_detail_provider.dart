import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_place_by_id_use_case.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

class PlaceDetailsProvider extends BaseProvider{

  final GetPlaceByIdUseCase getPlaceByIdUseCase;

  PlaceDetailsProvider({@required this.getPlaceByIdUseCase});

  String _placeId;

  @override
  Future<void> refreshData() async {
    super.refreshData();

    getPlaceById(_placeId);
  }


  void getPlaceById(String id) async {
    print('place id $id');
    state = Loading();
    _placeId = id;

    final failureOrReport = await getPlaceByIdUseCase(id);

    failureOrReport.fold(
          (failure) => state = Error(failure: failure),
          (place) => state = Loaded<Place>(value: place),
    );
  }

}