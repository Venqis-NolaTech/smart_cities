import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
import 'package:smart_cities/src/features/payments/domain/usescase/get_detail_account_use_case.dart';
import 'package:smart_cities/src/features/payments/domain/usescase/get_linked_account_use_case.dart';
import 'package:smart_cities/src/shared/provider/base_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';



class PaymentsProvider extends BaseProvider{
  final LoggedUserUseCase loggedUserUseCase;
  final GetLinkedAccountUseCase getLinkedAccountUseCase;
  final GetDetailAccountUseCase getDetailAccountUseCase;

  List<Account> listAccounts=[];



  PaymentsProvider({
    @required this.loggedUserUseCase,
    @required this.getLinkedAccountUseCase,
    @required this.getDetailAccountUseCase,
  });

  Future loadData() async {
    state = Loading();

    final logged = await loggedUserUseCase(NoParams());

    await logged.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        loadAccount();
      },
    );
  }

  Future<void> loadAccount() async  {

    state = Loading();

    final failureOrAccount = await getLinkedAccountUseCase(NoParams());

    await failureOrAccount.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (accounts) {
        listAccounts= accounts;
        state = Loaded(value: accounts);
      },
    );
  }

  Future loadDetail(String id) async {

    state = Loading();

    final failureOrAccount = await getDetailAccountUseCase(GetDetailAccountParams(idAccount: id));

    await failureOrAccount.fold(
          (failure) {
        state = Error(failure: failure);
      },
          (account) {
        state = Loaded(value: account);
      },
    );


  }






}