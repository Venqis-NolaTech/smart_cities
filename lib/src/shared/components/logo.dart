import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:flutter/material.dart';

import '../app_images.dart';



class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Spaces.verticalSmall(),
          Image.asset(
            AppImagePaths.logo,
            fit: BoxFit.contain,
            height: 170,
          ),
          Spaces.verticalSmall(),
          Text(
            S.of(context).municipality.toUpperCase(),
            style: kNormalStyle.copyWith(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500, //medium
              color: AppColors.white,
            ),
          ),
          //Spaces.verticalSmall(),
          Text(
            S.of(context).cocle, style: kBiggerTitleStyle.copyWith(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          ),
          Spaces.verticalLarge(),

        ],
      ),
    );
  }
}

/*class Logo extends StatelessWidget {
  const Logo({
    Key key,
    this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        color: Colors.white.withOpacity(0.8),
        alignment: Alignment.bottomCenter,
        height: 200.0,
        child: Image.asset(
          AppImagePaths.logo,
          width: 256,
        ),
      ),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - size.width / 4,
      size.height,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}*/
