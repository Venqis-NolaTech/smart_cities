
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/providers/base_new_report_form_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/widget/report_file_list.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/image_utils.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class ReportFiles extends StatefulWidget {
  final BaseNewReportFormProvider provider;
  final bool addBottomPadding;

  const ReportFiles({Key key, this.provider, this.addBottomPadding= false}) : super(key: key);

  @override
  _ReportFilesState createState() => _ReportFilesState();
}

class _ReportFilesState extends State<ReportFiles> {

  @protected
  bool addAttachmentsDisabled = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
            children: [

              widget.provider.files.isEmpty
                ? Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImagePaths.rectangle),
                          fit: BoxFit.fill
                      )
                  ),
                  child: InfoView(
                      height: MediaQuery.of(context).size.height*0.5,
                      image: Image.asset(AppImagePaths.camera),
                      title: S.of(context).files,
                      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
                      description: S.of(context).reportFileNotFound,
                      descriptionStyle:
                          kNormalStyle.copyWith(color: Colors.grey.shade500),
                    ),
                )
                : ReportFileList( files: widget.provider.files, onPressend: _onTapFile),
              Spaces.verticalMedium(),
              _buildMessage(),
              Spaces.verticalMedium(),
              _buildButtoms(context),
              widget.addBottomPadding ?  Spaces.verticalLargest() : Container(),
              widget.addBottomPadding ?  Spaces.verticalLargest() : Container(),

          ]
        ,
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return  widget.provider.files.isEmpty ?
    Row(
      children: [
        Icon(Icons.close, color: Colors.red),
        Spaces.horizontalSmall(),
        Flexible(child: Text(S.of(context).infoFile, style: kSmallestTextStyle.copyWith(color: Colors.red))),
      ],
    ):
    Row(
      children: [
        Icon(Icons.check, color: Colors.green),
        Spaces.horizontalSmall(),
        Flexible(child: Text(S.of(context).uptoPhoto, style: kSmallestTextStyle.copyWith(color: Colors.green))),
      ],
    );
  }

  Widget _buildButtoms(BuildContext context) {


    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: FlatButton(
              onPressed: ()=> showFilePicker(ImageSource.gallery),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(S.of(context).addPhotoExisting,
                  style: kNormalStyle.copyWith(
                    color: AppColors.blueLight,
                    fontWeight: FontWeight.w500,
                  )),
            ),
              shape: RoundedRectangleBorder(
                //borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColors.blueLight)
              )
          ),
        ),
        Spaces.verticalMedium(),
        SizedBox(
          width: double.infinity,
          child: FlatButton(
            onPressed: ()=> showFilePicker(ImageSource.camera),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(S.of(context).takePhoto,
                  style: kNormalStyle.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            color: AppColors.blueBtnRegister,
          ),
        )
      ],
    );
  }


  void showFilePicker(ImageSource imagesource) async {
    if (addAttachmentsDisabled) return;

    final addFileIsValid = widget.provider.addFileIsValid();

    if (!addFileIsValid) {
      showInfoDialog(
        S.of(context).maxFilesAndFileSizeMessage,
      );
      return;
    }

    ImageUtil.getImagePicker(context,  imagesource, ()=>addAttachmentsDisabled = true, (file){
      if (file != null)
        widget.provider.addFile(file);
      addAttachmentsDisabled = false;
    });

  }

  void showInfoDialog(
      String message, {
        String confirmTitle,
        String cancelTitle,
        bool cancelAction = false,
        Function onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (context) => InfoAlertDialog(
        message: message,
        confirmTitle: confirmTitle,
        cancelTitle: cancelTitle,
        cancelAction: cancelAction,
        onConfirm: () {
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }


  void _onTapFile(File file) {
    //widget.provider.removeFile(file);
  }
}
