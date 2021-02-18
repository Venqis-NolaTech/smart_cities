import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class SummaryReport extends StatefulWidget {
  final CreateReportProvider provider;

  SummaryReport({Key key, this.provider}) : super(key: key);

  @override
  _SummaryReportState createState() => _SummaryReportState();
}

class _SummaryReportState extends State<SummaryReport> {
  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return Container(
      child: Column(
        children: [

          buildHeader(screenHeight, context),
          buildSummary()


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
          Spaces.horizontalLarge(),
          Flexible(
              child: Text(S.of(context).questionPostYourName,
                  style: kSmallTextStyle.copyWith(
                      color: AppColors.blueBtnRegister,
                      fontWeight: FontWeight.w500))
          ),
          Expanded(child: Spaces.horizontalSmall()),
          Switch(
            value: widget.provider.postYourName,
            onChanged: (value) {
              setState(() {
                widget.provider.postYourName= value;
              });
            },
            activeColor: AppColors.blueLight,
          )

        ],
      ),
    );
  }

  Widget buildSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: double.infinity,),
          Text(S.of(context).title, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister)),
          Spaces.verticalSmall(),
          Text(widget.provider.titleReport ?? '', style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.5))),
          Spaces.verticalMedium(),
          Text(S.of(context).description, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister)),
          Spaces.verticalSmall(),
          Text(widget.provider.descriptionReport ?? '', style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.5))),
          Spaces.verticalLarge(),

          Text(S.of(context).category, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister)),
          Spaces.verticalSmall(),
          Text(widget.provider.selectedCategory!=null ? widget.provider.selectedCategory.value : '', style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.5))),

        ],
      ),
    );
  }
}
