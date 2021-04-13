import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_in/pages/sign_in_page.dart';
import 'package:smart_cities/src/features/home/presentation/provider/home_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/pages/general_report.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';



class ReportWidget extends StatelessWidget {
  final HomeProvider provider;

  ReportWidget({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: screenWidth*0.40,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              buildHeaderReport(context),
              Spaces.verticalMedium(),

              Flexible(
                child: Text(
                  S.of(context).incidentSectorQuestion,
                  textAlign: TextAlign.center,
                  style: kNormalStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),


              Spaces.verticalMedium(),

              Flexible(
                child: Text(
                  S.of(context).letUsKnow,
                  textAlign: TextAlign.center,
                  style: kNormalStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Spaces.verticalMedium(),

              FlatButton(
                onPressed: () {
                  if(provider.isLogged)
                    Navigator.pushNamed(context, NewReport.id);
                  else
                    SignInPage.pushNavigate(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColors.blueLight)),
                child: Text(
                  S.of(context).newReport,
                  maxLines: 1,
                  style: kSmallestTextStyle.copyWith(
                    color: AppColors.blueLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );


  }

  Row buildHeaderReport(BuildContext context) {
    return Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Image.asset(AppImagePaths.iconReport),
                Spaces.horizontalSmall(),
                Text(
                  S.of(context).report,
                  textAlign: TextAlign.center,
                  style: kMediumTitleStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
  }
}
