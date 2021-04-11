import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';

import 'package:smart_cities/src/features/payments/domain/usescase/get_list_bank_use_case.dart';
import 'package:smart_cities/src/features/payments/domain/usescase/save_accounts_use_case.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';



class DataKey{
  static const BANK_ACCOUNT = "BANK ACCOUNT";
  static const CREDITCARD = "CREDITCARD";

}
class AddAccountBankProvider extends BaseProvider{
  final GetListBankUseCase getListBankUseCase;
  final SaveAccountsUseCase saveAccountsUseCase;


  AddAccountBankProvider({
    @required this.getListBankUseCase,
    @required this.saveAccountsUseCase,
  });



  String holderName;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  String accountNumber= '';
  String accountHolderName= '';



  List<CatalogItem> listBanks=[];
  CatalogItem _bankSelected;
  CatalogItem get bankSelected => _bankSelected;
  set bankSelected(CatalogItem value) {
    _bankSelected=value;
    notifyListeners();
  }


  static final List<CatalogItem> paymentMethod=[
    CatalogItem(key: DataKey.BANK_ACCOUNT, value: 'Cuenta Bancaria'),
    CatalogItem(key: DataKey.CREDITCARD, value: 'Tarjeta de Crédito'),
  ];

  static final List<CatalogItem> typeAccountBank=[
    CatalogItem(key: 'CURRENT', value: 'Corriente'),
    CatalogItem(key: 'SAVINGS', value: 'Ahorro'),
  ];

  static final List<CatalogItem> typeAccount=[
    CatalogItem(key: 'ARBITRIOS MUNICIPALES', value: 'Arbitrios Municipales'),
    CatalogItem(key: 'ASEO', value: 'Aseo'),
  ];


  // tipo de cuenta a crear, relacion con typeAccount aseo o arbitrios municipales
  CatalogItem _typeAccountSelected;
  CatalogItem get typeAccountSelected => _typeAccountSelected;
  set typeAccountSelected(CatalogItem value) {
    _typeAccountSelected=value;
    notifyListeners();
  }

  // metodo de pago seleccionado cuenta bancaria o tarjeta
  CatalogItem _paymentMethodSelected;
  CatalogItem get paymentMethodSelected => _paymentMethodSelected;
  set paymentMethodSelected(CatalogItem value) {
    _paymentMethodSelected=value;
    notifyListeners();
  }

  // tipo de cuenta bancaria, relacion con typeAccountBank
  CatalogItem _typeAccountBankSelected;
  CatalogItem get typeAccountBankSelected => _typeAccountBankSelected;
  set typeAccountBankSelected(CatalogItem value) {
    _typeAccountBankSelected=value;
    notifyListeners();
  }



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

  Future sendAccount() async {

    //TODO envio con tarjeta
    Map<String, dynamic> data;

    if(paymentMethodSelected.key == DataKey.CREDITCARD){
      data={
        "accountOwner" : holderName,
        "accountType" : typeAccountSelected.key,
        "systemCode" : "12345",
        "paymentMethod" : paymentMethodSelected.key,
        "paymentOwner": paymentMethodSelected.key == 'BANK ACCOUNT'
            ? accountHolderName
            : cardHolderName,
        "creditCardNumber" : cardNumber,
        "creditCardExpDate" : expiryDate,
        "creditCardCVV" : cvvCode
      };
    }else{

      data={
        "accountOwner" : holderName,
        "accountType" : typeAccountSelected.key,
        "systemCode" : "123456",
        "paymentMethod" : paymentMethodSelected.key,
        "paymentOwner": paymentMethodSelected.key == DataKey.BANK_ACCOUNT
            ? accountHolderName
            : cardHolderName,
        "bank" :  bankSelected.key,
        "bankType" : typeAccountBankSelected.key,
        "bankNumber" : accountNumber
      };

    }


    state= Loading();
    var result= await saveAccountsUseCase(CreateAccountParams(data: data));

    result.fold(
          (failure) => state = Error(failure: failure),
          (account) => state = Loaded(value: account),
    );

  }









}