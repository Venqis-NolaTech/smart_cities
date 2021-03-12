
import 'package:smart_cities/src/core/entities/catalog_item.dart';

import '../../../../../shared/provider/base_provider.dart';
import '../../../../../../app.dart';

class RouteProvider extends BaseProvider{


  bool isMunicipality= true;

  CatalogItem _realTimeSector= currentUser.municipality;
  CatalogItem get realTimeSector => _realTimeSector;
  set realTimeSector(CatalogItem value) {
    _realTimeSector=value;
    isMunicipality= false;
    notifyListeners();
  }

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

  bool validate() {
    if(selectedSector== null || selectedDate==null)
      return false;
    return true;
  }





}