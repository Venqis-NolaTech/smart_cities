import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/blog/presentation/pages/blog_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class FeatureNews extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BlogPage.pushNavigate(
        context,
        args: BlogPageArgs(),
      ),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('NOVIEMBRE',
                    textAlign: TextAlign.start,
                    style: kSmallestTextStyle.copyWith(
                      color: AppColors.blueBtnRegister,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            Spaces.verticalMedium(),
            Row(
              children: [
                Expanded(
                    child: Text('Noticia Destacada',
                        style: kMediumTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ))),
                Text('VER TODAS',
                    style: kSmallestTextStyle.copyWith(
                      color: AppColors.blueBtnRegister,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    )),
                Icon(Icons.chevron_right, color: AppColors.blueBtnRegister)
              ],
            ),
            AppImages.defaultImage
          ],
        ),
      ),
    );
  }
}
