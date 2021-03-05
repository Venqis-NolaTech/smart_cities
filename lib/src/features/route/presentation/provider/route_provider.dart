
import 'package:smart_cities/src/core/entities/catalog_item.dart';

import '../../../../shared/provider/base_provider.dart';

class RouteProvider extends BaseProvider{


  /// corregimiento
  CatalogItem _selectedSector;

  CatalogItem get selectedSector => _selectedSector;

  set selectedSector(CatalogItem value) {
    _selectedSector=value;
    notifyListeners();
  }

  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate=value;
    notifyListeners();
  }





}