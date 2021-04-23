import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/widget/add_credit_card.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/widget/creditcard_list.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/widget/item_card.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';



class PaymentPage extends StatefulWidget {
  static const id = "payment_page";

  static dynamic pushNavigate(
      BuildContext context, {
        bool replace = false,
      }) {
    if (replace) {
      return Navigator.pushNamedAndRemoveUntil(
        context,
        id,
            (route) => false,
        //arguments: args,
      );
    } else {
      return Navigator.pushNamed(context, id); //arguments: args);
    }
  }

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseView<AddAccountBankProvider>(
        onProviderReady: (provider) => provider.loadData(),
        builder: (context, provider, child) {

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: AppColors.red,
              title: Text(S.of(context).card),
              centerTitle: true,
            ),

            body: IndexedStack(
              index: _stepIndex,
              children: [
                AddCreditCard(provider: provider, payment: moveToPayment),
                CreditCardList(provider: provider, creditCardList: [dynamic, dynamic, dynamic],
                addCard: moveAddCard, payment: ()=> Navigator.pop(context)),

              ],
            ),
          );


        });

  }

  List<Widget> getList(List<dynamic> cards){
    return List<Widget>.generate(cards.length, (index) {
      return ItemCreditCard(
        background: (index%2) != 0 ? Colors.white : AppColors.greyButtom.withOpacity(0.2),
        onTap: (){

        },
      );
    });

  }

  void moveToPayment() {
    setState(() {
      _stepIndex=1;
    });
  }

  void moveAddCard(){
    setState(() {
      _stepIndex=0;
    });
  }


}
