import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class AddPhotoHeader extends StatelessWidget {
  final Function takePhoto;

  const AddPhotoHeader({Key key, this.takePhoto}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 220.0,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImages.iconGallery,
            Spaces.verticalMedium(),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                onPressed: takePhoto,
                color: AppColors.blueBtnRegister,
                child: Text(S.of(context).addPhoto, style: kMediumTitleStyle.copyWith(color: Colors.white),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
