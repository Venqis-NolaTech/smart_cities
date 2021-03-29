import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';

import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/reports/domain/usecases/get_sectores_use_case.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../shared/provider/base_provider.dart';

class SelectSectorProvider extends BaseProvider {
  final LoggedUserUseCase loggedUserUseCase;
  final GetSectoresUseCase getSectoresUseCase;

  SelectSectorProvider(
      {@required this.loggedUserUseCase, @required this.getSectoresUseCase});

  List<CatalogItem> allSectores = [];

  Future loadData() async {
    state = Loading();

    var result = await getSectoresUseCase(NoParams());

    await result?.fold(
          (failure) {
        print('fallo al actualizar sectores');
        state = Error(failure: failure);
      },
          (list) async {
        if (list != null) {
          allSectores = list;
          print('actualizada listado de sectores');
          notifyListeners();
        }

        state = Loaded();
      },
    );

  }
}
