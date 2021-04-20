import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/presentation/multiple_payments/widget/item_payment.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/page/payment_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class Payment{
  final bool selected;
  final String id;
  final String card;
  final String total;
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
                          paymentList = [
                            Payment(selected: slectAll, id: 'ID 1234213', card: 'MC ***3131', total: '1,234'),
                            Payment(selected: slectAll, id: 'ID 23241', card: 'MC ***3131',total: '200'),
                            Payment(selected: slectAll, id: 'ID 23499', card: 'MC ***3131', total: '1,314')
                          ];
                        });

                      })
                    ],

                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: getList(paymentList),
                ),
              ],
            ),

          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('TOTAL'),
                    ),

                    Text('\$1,234')
                  ],
                ),

                Spaces.horizontalSmall(),

                _btnPayment()

              ],
            ),
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
        child: Row(
          children: [

            Icon(MdiIcons.informationOutline, color: AppColors.blueFacebook),
            Spaces.horizontalMedium(),
            Expanded(
              child: Text(
                S.of(context).messageMultiplePayment,
                textAlign: TextAlign.start,
                style: kNormalStyle.copyWith(color: AppColors.primaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getList(List<dynamic> list){
    return List<Widget>.generate(list.length, (index) {
      return ItemPayment(
        payment: list[index],
        onTap: () => {} ,
      );
    });

  }
}
