import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_in/pages/sign_in_page.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/page/add_account_page.dart';
import 'package:smart_cities/src/features/payments/presentation/detail_account/page/detail_account_page.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/provider/payments_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/widget/account_list_item.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/widget/linked_accounts.dart';
import 'package:smart_cities/src/features/reports/presentation/tab_report/widget/btn_iniciar.dart';
import 'package:smart_cities/src/shared/app_colors.dart';

import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class LinkedAccountsPage extends StatefulWidget {
  @override
  _LinkedAccountsPageState createState() => _LinkedAccountsPageState();
}

class _LinkedAccountsPageState extends State<LinkedAccountsPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;

    return BaseView<PaymentsProvider>(
        onProviderReady: (provider) => provider.loadData(),
        builder: (context, provider, child) {
          final currentState = provider.currentState;

          /*if (currentState is Error) {
            final failure = currentState.failure;
            return _buildErrorView(context, failure);
          }*/

          return ModalProgressHUD(
              inAsyncCall: currentState is Loading,
              child: Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  backgroundColor: AppColors.red,
                  centerTitle: true,
                  title: Text(S.of(context).myAccounts),
                  leading: IconButton(
                    icon: Icon(MdiIcons.arrowLeft),
                    color: AppColors.white,
                    onPressed: () => Navigator.pop(context),
                  )
                ),
                floatingActionButton:
                currentState is Error && currentState.failure is UserNotFoundFailure ? Container() :
                FloatingActionButton(
                  onPressed: () => AddAccountPage.pushNavigate(context),
                  child: Icon(Icons.add),
                  backgroundColor: AppColors.blueBtnRegister,
                ) ,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                        LinkedAccount(
                            numAccount: provider.listAccounts.length,
                            height: size.height * 0.3,
                            isLogged: currentState is Error &&
                                    currentState.failure is UserNotFoundFailure
                                ? false
                                : true),

                        currentState is Error && currentState.failure is UserNotFoundFailure ?
                        _buildErrorView(context, currentState.failure) :

                        _buildContentList(provider, size.height)

                    ],
                  ),
                )


              ));
        });
  }

  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.5,
      image: Container(),
      title: failure is UserNotFoundFailure ? S.of(context).userNotFoundMessagePayments : S.of(context).unexpectedErrorMessage,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: '',
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: failure is UserNotFoundFailure ?
      ButtonLogin(title: S.of(context).connectAccount.toUpperCase(), actionLogin:()=> actionLogin(context),)
          : Container(),
    );
  }

  actionLogin(BuildContext context) {
    SignInPage.pushNavigate(context);
  }

  List<Widget> getList(List<Account> accounts){
    return List<Widget>.generate(accounts.length, (index) {
        return AccountItem(
          account: accounts[index],
          isFirst: index == 0,
          isLast: index == accounts.length - 1,
          topAndBottomPaddingEnabled: false,
          onTap: () => DetailAccountPage.pushNavigate(context, replace: false, args: DetailAccountPageArgs(account: accounts[index])) ,
        );
    });

  }
  Widget _buildListAccounst(List<dynamic> accounts, PaymentsProvider provider) {




    return ListView.builder(
      itemCount: accounts.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => AccountItem(
        account: accounts[index],
        isFirst: index == 0,
        isLast: index == accounts.length - 1,
        topAndBottomPaddingEnabled: false,
        onTap: () => {},
      ),
    );
  }

  Widget _buildContentList(PaymentsProvider provider, double heigth) {

    if(provider.currentState is Loaded){
      return Column(
          mainAxisSize: MainAxisSize.min,
          children: getList((provider.currentState as Loaded).value)
      );
    }else
      return Container();

  }
}
