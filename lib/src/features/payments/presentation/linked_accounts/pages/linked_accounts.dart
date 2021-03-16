import 'package:flutter/material.dart';

import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/widget/linked_accounts.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class LinkedAccountsPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myAccounts),
        centerTitle: true,
        backgroundColor: AppColors.red,
          leading: IconButton(
            icon: Icon(MdiIcons.arrowLeft),
            color: AppColors.white,
            onPressed: () {},
          )
      ),
      body: Column(
        children: [
          LinkedAccount(linkedAccount: false),
          Spaces.verticalLargest(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(S.of(context).messageLinkedAccounts,
                style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister)),
          ),
          Spaces.verticalLargest(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: _buildButtomConnect(context),
          ),





        ],
      ),

    );
  }

  Widget _buildButtomConnect(BuildContext context) {
    return RoundedButton(
        color: AppColors.blueBtnRegister,
        title: S.of(context).connectAccount.toUpperCase(),
        style: kNormalStyle.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.white),
        onPressed: (){}
    ) ;
  }
}
