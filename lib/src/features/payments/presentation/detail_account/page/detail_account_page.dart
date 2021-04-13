import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
import 'package:smart_cities/src/features/payments/presentation/detail_account/widget/item_invoice.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/provider/payments_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/widget/account_list_item.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/page/payment_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class DetailAccountPageArgs {
  final Account account;

  DetailAccountPageArgs({
    this.account,
  });
}


class DetailAccountPage extends StatelessWidget {
  static const id = "detail_account_page";
  final DetailAccountPageArgs args;

  const DetailAccountPage({
    Key key,
    this.args
  }) : super(key: key);

  static dynamic pushNavigate(
      BuildContext context, {
        bool replace = false,
        DetailAccountPageArgs args,
      }) {
    if (replace) {
      return Navigator.pushNamedAndRemoveUntil(
        context,
        id,
            (route) => false,
        arguments: args,
      );
    } else {
      return Navigator.pushNamed(context, id, arguments: args);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;
    return BaseView<PaymentsProvider>(
      onProviderReady: (provider)=> provider.loadDetail(args.account.id),
      builder: (context, provider, child ) {


        return ModalProgressHUD(
          inAsyncCall: provider.currentState is Loading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.red,
              title: Text(S.of(context).detail),
              centerTitle: true,
            ),
            body: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    Stack(
                      children: [
                        Container(
                          color: AppColors.greyButtom,
                          height: screenHeight*0.2),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildHeader(args.account, context),
                            AccountItem(
                              account: args.account,
                              isFirst: false,
                              isLast: false,
                              topAndBottomPaddingEnabled: false,
                              onTap: () => {},
                            ),
                          ],
                        ),


                      ],
                    ),


                    _btnPayment(context, provider),
                    Spaces.verticalLarge(),
                    Text(S.of(context).previousInvoices.toUpperCase(), style: kTitleStyle.copyWith(),),
                    Spaces.verticalMedium(),
                    _buildContentList()


                  ],
                ),
              ),
            ),
          ),
        );



      }
    );
  }

  void _onBackPressed() {
  }

  Widget _buildHeader(Account account, BuildContext context) {
    return Container(
      //height: height,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spaces.verticalSmall(),
            Text('\$ 1,314', style: kMenuBigTitleStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),),
            Spaces.verticalSmall(),
            Text(S.of(context).balanceToDate, style: kNormalStyle.copyWith(color: AppColors.white),),
            Spaces.verticalSmall(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).nextPayment, style: kNormalStyle.copyWith(color: AppColors.white),),
                Spaces.horizontalLarge(),
                Container(
                    color: AppColors.blueLight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('00.00.0000', style: kNormalStyle.copyWith(color: AppColors.white) ),
                    )),
              ],
            ) ,
            Spaces.verticalMedium(),
          ],
        ),
      ),
    );


  }

  Widget _btnPayment(BuildContext context, PaymentsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: RoundedButton(
          color: AppColors.blueBtnRegister,
          borderColor: AppColors.white,
          elevation: 0,
          title: S.of(context).payment.toUpperCase(),
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white),
          onPressed: () async {
            PaymentPage.pushNavigate(context, replace: false);
            /*Navigator.pushNamedAndRemoveUntil(
              context,
              MainPage.id,
              ModalRoute.withName(MainPage.id),
            );*/
          }
      ),
    );
  }

  Widget _buildContentList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: getList([dynamic, dynamic, dynamic]),
    );
  }

  List<Widget> getList(List<dynamic> invoices){
    return List<Widget>.generate(invoices.length, (index) {
      return ItemInvoice(
        background: (index%2) != 0 ? Colors.white : AppColors.greyButtom.withOpacity(0.2),
        onTap: (){

        },
      );
    });

  }

/*

 */

}
