
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/providers/base_new_report_form_provider.dart';


class ReportFileList extends StatelessWidget {
  const ReportFileList({
    Key key,
    @required this.provider,
    @required this.addFile
  }) : super(key: key);

  final BaseNewReportFormProvider provider;
  final Function addFile;

  @override
  Widget build(BuildContext context) {
    return _buidlAttachmentList(context);
  }

  Widget _buidlAttachmentList(BuildContext context) {

    var listWidget= List.generate(provider.files.length, (index) => _buildItem(file: provider.files.elementAt(index)));
    listWidget.add(InkWell(
      onTap: addFile,
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImagePaths.rectangle),
                  fit: BoxFit.fill)),
        child: Icon(Icons.add, size: 50, color: AppColors.greyButtom.withOpacity(0.5)),
      ),
    )
    );

    return Container(
      color: Colors.grey.shade50,
      child: provider.files.isEmpty
          ? Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImagePaths.rectangle),
                fit: BoxFit.fill
            )
        ),
        child: InfoView(
          height: MediaQuery.of(context).size.height*0.4,
          image: Image.asset(AppImagePaths.camera),
          title: S.of(context).files,
          titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
          description: S.of(context).reportFileNotFound,
          descriptionStyle:
          kNormalStyle.copyWith(color: Colors.grey.shade500),
        ),
      ) : GridView.count(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: listWidget
      ),
    );

    /*return Container(
      child: GridView.count(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: listWidget
      ),
    );*/
  }

  Widget _buildItem({File file}) {
    return Stack(
        children: [
          Image.file(file, fit: BoxFit.fitWidth),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                MdiIcons.closeCircle,
                color: AppColors.red,
              ),
              onPressed: () => provider.removeFile(file),
            ),
          )
        ],
    );
  }
}
