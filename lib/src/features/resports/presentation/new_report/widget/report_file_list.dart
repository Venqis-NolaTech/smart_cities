
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';

class ReportFileList extends StatelessWidget {
  const ReportFileList({
    Key key,
    @required this.files,
    this.onPressend,
  }) : super(key: key);

  final List<File> files;
  final Function(File) onPressend;


  @override
  Widget build(BuildContext context) {
    return _buidlAttachmentList(context);
  }

  Widget _buidlAttachmentList(BuildContext context) {

    var listWidget= List.generate(files.length, (index) => _buildItem(file: files.elementAt(index)));
    listWidget.add(Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImagePaths.rectangle),
                fit: BoxFit.fill)),
      child: Icon(Icons.add, size: 50, color: AppColors.greyButtom.withOpacity(0.5)),
    )
    );

    return Container(
      child: GridView.count(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: listWidget
      ),
    );
  }

  Widget _buildItem({File file}) {
    return GestureDetector(onTap: onPressend(file) ,child: Container(child: Image.file(file, fit: BoxFit.fitWidth,)));
  }
}
