import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/pages/selected_neighborhood_page.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/pages/selected_sector_page.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/widget/header_report.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class DescriptionReport extends StatelessWidget {
  final CreateReportProvider provider;

  DescriptionReport({Key key, this.provider}) : super(key: key);

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [

          buildHeader(screenHeight, context),
          _buildForm(context),
          buildTexts(context)

        ],
      ),
    );
  }

  Widget buildHeader(double screenHeight, BuildContext context) {
    return Container(
        height: screenHeight*0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Spaces.horizontalMedium(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(S.of(context).tree, style: kMediumTitleStyle.copyWith(color: AppColors.blueLight, fontWeight: FontWeight.bold),),
            ),
            Spaces.horizontalSmall(),
            Flexible(
              child: Wrap(
                children: [
                  Text(S.of(context).titleReport, style: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500)),
                  Text(S.of(context).privacyPolitics,  style: kSmallTextStyle.copyWith(color: AppColors.blueButton, fontWeight: FontWeight.w500))
                ],
              ),
            )

          ],
        ),
      );
  }

  Widget buildTexts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      Spaces.horizontalSmall(),
                      Flexible(child: Text(S.of(context).rule1, style: kSmallestTextStyle.copyWith(color: Colors.green))),
                      Spaces.horizontalSmall(),
                      Icon(Icons.close, color: Colors.red),
                      Spaces.horizontalSmall(),
                      Flexible(child: Text(S.of(context).rule2, style: kSmallestTextStyle.copyWith(color: Colors.red))),
                    ],
                  ),
                  Spaces.verticalMedium(),
                  Row(
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      Spaces.horizontalSmall(),
                      Flexible(child: Text(S.of(context).ruleTree, style: kSmallestTextStyle.copyWith(color: Colors.green))),
                      Spaces.horizontalSmall(),
                      Icon(Icons.close, color: Colors.red),
                      Spaces.horizontalSmall(),
                      Flexible(child: Text(S.of(context).ruleFour, style: kSmallestTextStyle.copyWith(color: Colors.red))),
                    ],
                  ),


                  Spaces.verticalLargest(),


                ],
              ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Form(
        key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text(S.of(context).title, style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister)),
                ],
              ),
              TextFormField(
                maxLines: 2,
                onChanged: (value){
                  provider.titleReport= value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: S.of(context).exampleTitle
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value) {

                },
                style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
              ),
              Divider(),
              Spaces.verticalMedium(),
              Row(
                children: [
                  Text(S.of(context).description, style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister)),
                ],
              ),
              Spaces.verticalLarge(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyButtom.withOpacity(0.2))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    maxLines: 10,
                    onChanged: (value){
                      provider.descriptionReport= value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: S.of(context).exampleDescription
                    ),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                    },
                    style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
                  ),
                ),
              ),







            ],
          )
      ),
    );
  }


  void showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InfoAlertDialog(
        message: S.of(context).sectorValid,
        cancelAction: false,
        onConfirm: () => {}//Navigator.of(context).pop(),
      ),
    );
  }
}
