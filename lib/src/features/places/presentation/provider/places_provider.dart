import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_all_category_places_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_nearby_places_by_category_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_places_by_category_use_case.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../shared/provider/base_provider.dart';

class PlacesProvider extends BaseProvider{
  final GetAllCategoryPlacesUseCase getAllCategoryPlacesUseCase;
  final GetNearbyPlacesByCategoryUseCase getNearbyPlacesByCategoryUseCase;
  final GetPlacesByCategoryUseCase getPlacesByCategoryUseCase;

  PlacesProvider({
    @required this.getAllCategoryPlacesUseCase,
    @required this.getNearbyPlacesByCategoryUseCase,
    @required this.getPlacesByCategoryUseCase
  });

  CatalogItem _selectedCategory;

  CatalogItem get selectedCategory => _selectedCategory;

  set selectedCategory(CatalogItem value) {
    _selectedCategory=value;
    notifyListeners();
  }




  Future<void> loadCategory() async {
    state= Loading();

    final failureOrReport = await getAllCategoryPlacesUseCase(NoParams());

    failureOrReport.fold(
      (failure) => state = Error(failure: failure),
      (listCategory) => state = Loaded<List<CatalogItem>>(value: listCategory),
    );


  }

}