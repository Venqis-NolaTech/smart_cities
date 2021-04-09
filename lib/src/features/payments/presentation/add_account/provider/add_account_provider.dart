import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';

import 'package:smart_cities/src/features/payments/domain/usescase/get_list_bank_use_case.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

class AddAccountBankProvider extends BaseProvider{
  final GetListBankUseCase getListBankUseCase;


  List<CatalogItem> listBanks=[];
  CatalogItem _bankSelected;
  CatalogItem get bankSelected => _bankSelected;
  set bankSelected(CatalogItem value) {
    _bankSelected=value;
    notifyListeners();
  }


  static final List<CatalogItem> paymentMethod=[
    CatalogItem(key: 'BANK ACCOUNT', value: 'Cuenta Bancaria'),
    CatalogItem(key: 'CREDITCARD', value: 'Tarjeta de Crédito'),
  ];

  static final List<CatalogItem> typeAccountBank=[
    CatalogItem(key: 'CURRENT', value: 'Corriente'),
    CatalogItem(key: 'SAVINGS', value: 'Ahorro'),
  ];

  static final List<CatalogItem> typeAccount=[
    CatalogItem(key: 'ARBITRIOS MUNICIPALES', value: 'Arbitrios Municipales'),
    CatalogItem(key: 'ASEO', value: 'Aseo'),
  ];

  CatalogItem _paymentMethodSelected= paymentMethod.first;
  CatalogItem get paymentMethodSelected => _paymentMethodSelected;
  set paymentMethodSelected(CatalogItem value) {
    _paymentMethodSelected=value;
    notifyListeners();
  }


  CatalogItem _typeAccountBankSelected= typeAccountBank.first;
  CatalogItem get typeAccountBankSelected => _typeAccountBankSelected;
  set typeAccountBankSelected(CatalogItem value) {
    _typeAccountBankSelected=value;
    notifyListeners();
  }



  AddAccountBankProvider({
    @required this.getListBankUseCase,
  });

  Future loadData() async {
    state = Loading();

    final logged = await getListBankUseCase(NoParams());

    await logged.fold(
          (failure) {
        state = Error(failure: failure);
      },
          (banks) {
            listBanks=banks;
          state = Loaded();
      },
    );



  }






}