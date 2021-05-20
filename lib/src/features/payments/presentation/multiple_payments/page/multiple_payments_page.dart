import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/presentation/multiple_payments/widget/item_payment.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/page/payment_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class Payment{
  bool selected;
  String id;
  String card;
  String total;
  Payment({this.selected, this.id, this.card, this.total});
}

class MultiplePaymentsPage extends StatefulWidget {
  static const id = "multiple_payments_page";

  static dynamic pushNavigate(
      BuildContext context, {
        bool replace = false
      }) {
    if (replace) {
      return Navigator.pushNamedAndRemoveUntil(context, id, (route) => false);
    } else {
      return Navigator.pushNamed(context, id);
    }
  }

  @override
  _MultiplePaymentsPageState createState() => _MultiplePaymentsPageState();
}

class _MultiplePaymentsPageState extends State<MultiplePaymentsPage> {
  var slectAll= false;

  List<Payment> paymentList = [
    Payment(selected: false, id: 'ID 1234213', card: 'MC ***3131', total: '1,234'),
    Payment(selected: false, id: 'ID 23241', card: 'MC ***3131',  total: '200'),
    Payment(selected: false, id: 'ID 23499', card: 'MC ***3131', total: '1,314')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).payments),
        centerTitle: true,
        backgroundColor: AppColors.red,
        actions: [
          FlatButton(
              onPressed: _onBackPressed,
              child: Text(
                S.of(context).cancel,
                style: kSmallTextStyle.copyWith(color: AppColors.white),
              ))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Seleccionar Todo'),
                      Checkbox(value: slectAll, onChanged: (value){
                        slectAll= !slectAll;
                        setState(() {
                          setState(() {
                            paymentList.forEach((element) {
                              element.selected= true;
                            });
                          });

                        });

                      })
                    ],

                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: getList(),
                ),
              ],
            ),

          ),


          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Container(
                height: 1,
                color: Colors.grey.shade300,
              ),
              Spaces.verticalSmall(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(

                  children: [
                    Expanded(
                      child: Text('TOTAL', style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.primaryText),),
                    ),

                    Text('\$1,234', style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.primaryText),)
                  ],
                ),
              ),

              Spaces.verticalSmall(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _btnPayment(),
              )

            ],
          )
        ],
      ),

    );
  }

  Widget _btnPayment() {
    return RoundedButton(
        color: AppColors.blueBtnRegister,
        borderColor: AppColors.blueBtnRegister,
        elevation: 0,
        title: S.of(context).toPay.toUpperCase(),
        style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white),
        onPressed: () async {
          PaymentPage.pushNavigate(context, replace: false);
        }
    );
  }


  Widget _buildHeader(BuildContext context) {

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).multiplePayments.toUpperCase(),
              textAlign: TextAlign.start,
              style: kTitleStyle.copyWith(   color: AppColors.primaryText),
            ),
            Spaces.verticalSmall(),
            Text(
              S.of(context).messageMultiplePayment,
              textAlign: TextAlign.center,
              style: kNormalStyle.copyWith(color: AppColors.primaryText),
            )


          ],
        ),
      ),
    );
  }

  List<Widget> getList(){
    return List<Widget>.generate(paymentList.length, (index) {
      return ItemPayment(
        payment: paymentList[index],
        onTap: () => {} ,
        onSelect: (value){
          setState(() {
            paymentList[index].selected= value;
          });
        },
      );
    });

  }

  void _onBackPressed() {
    Navigator.pop(context);
  }
}
