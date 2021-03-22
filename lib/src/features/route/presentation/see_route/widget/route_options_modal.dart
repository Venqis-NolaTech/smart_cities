import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/route/presentation/rate_service/page/rate_service_page.dart';
import 'package:smart_cities/src/features/route/presentation/report_lack_collection/page/report_lack_collection_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_item_list.dart';

class RouteOptionsModal extends StatelessWidget {
  final textStyle = TextStyle(
    color: AppColors.blueBtnRegister,
    fontWeight: FontWeight.bold,
  );
  final Function changeSector;
  final Function onSelectSector;

  RouteOptionsModal({Key key, this.changeSector, this.onSelectSector})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widget = [];
    final Map<String, Function> options = {
      S.of(context).reportTakeOutTrash: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, ReportLackCollectionPage.id);
      }, //=>  Navigator.pushNamed(context, ),
      S.of(context).rateService: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, RateServicePage.id);
      },
      S.of(context).changeSector: () {
        Navigator.pop(context);
        changeSector();
      },
      S.of(context).whenTakeOutTrash: () {
        Navigator.pop(context);
        //Navigator.pushNamed(context, ReportLackCollectionPage.id);
        onSelectSector();
      },
      //S.of(context).cancel: ()=> Navigator.pop(context)
    };

    options.forEach((key, value) {
      widget.add(CustomItemList(
          title: key,
          onTap: value,
          selected: false,
          isDivider: true,
          textStyle: textStyle));
    });

    widget.add(CustomItemList(
        title: S.of(context).cancel,
        onTap: ()=> Navigator.pop(context),
        selected: false,
        isDivider: true,
        textStyle: textStyle.copyWith(color: AppColors.primaryText)));

    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        child: Column(
          children: widget,
        ),
      ),
    );
  }
}
