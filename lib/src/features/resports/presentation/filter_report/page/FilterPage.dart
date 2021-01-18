import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/features/resports/presentation/filter_report/widget/filter_item_view.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/general_report_provider.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';

import '../../../../../shared/app_colors.dart';
import '../../../../../shared/constant.dart';
import '../../../../../../generated/i18n.dart';



class FilterReportPage extends StatefulWidget {
  static const id = "filter_report_page";

  @override
  _FilterReportPageState createState() => _FilterReportPageState();
}

class _FilterReportPageState extends State<FilterReportPage> {
  List<Widget> list=[];

  @override
  Widget build(BuildContext context) {

    return BaseView<GeneralReportProvider>(
      onProviderReady: (provider) => provider.getParam(),
      builder: (context, provider, child){
        final currentState = provider.currentState;

        return ModalProgressHUD(
            inAsyncCall: currentState is Loading,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.red,
                centerTitle: true,
                title: Text(S.of(context).filterReport),
              ),
              body: SingleChildScrollView(
                child: Column(children: _buildWidget(currentState, provider)),
              ),
            ));
      },
    );


  }

  List<Widget> _buildWidget(ViewState state, GeneralReportProvider provider) {

    if(!(state is Loaded))
      return [];


    var filters= (state as Loaded<List<FilterReportItem>>).value;
    list.clear();
    list.add(SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Text(
            S.of(context).titleFilter,
            style: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister),
            textAlign: TextAlign.start,
          ),
        )));

    list.addAll(List<Widget>.generate(filters.length, (index) =>
        FilterItemView(
          item: filters[index], onChanged: (value) => provider.setParam(filters[index]))));


    list.add(btnNext(context));

    return list;
  }


  Widget btnNext(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).nextPage.toUpperCase(),
            style: kTitleStyle.copyWith(fontWeight: FontWeight.w400, color: AppColors.white,),
            onPressed: () {
              Navigator.pop(context);
            }

        )
    );
  }



}
