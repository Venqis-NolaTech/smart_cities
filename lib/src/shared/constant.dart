import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';

import 'app_colors.dart';

// global ----
const kSmallestTextStyle = TextStyle(
  fontSize: 10.0,
  fontFamily: 'Roboto',
);

const kSmallTextStyle = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Roboto',
);

const kNormalStyle = TextStyle(
  fontSize: 14.0,
  fontFamily: 'Roboto',
);

const kTitleStyle = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Roboto',
  //fontWeight: FontWeight.bold,
);

const kMediumTitleStyle = TextStyle(
  fontSize: 20.0,
  fontFamily: 'Roboto',
  //fontWeight: FontWeight.bold,
);

const kBigTitleStyle = TextStyle(
  fontSize: 24.0,
  fontFamily: 'Roboto',
);

const kBiggerTitleStyle = TextStyle(
  fontSize: 30.0,
  //fontWeight: FontWeight.bold,
);
// ---- global

// main menu ----
const kMenuBigTitleStyle = TextStyle(
  fontSize: 44.0,
  fontWeight: FontWeight.bold,
  color: AppColors.white,
);

const kMenuTitleStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: AppColors.white,
);

const kMenuSubtitleStyle = TextStyle(
  fontSize: 10.0,
  color: AppColors.white,
);
// ---- main menu

// sms code ----
const kSmsCodeInputStyle = TextStyle(
  fontSize: 36.0,
  fontWeight: FontWeight.bold,
);
// ---- sms code

class ScreenSize {
  static const Size small = Size(320.0, 592.0);
  static const Size medium = Size(360.0, 592.0);
}

const kRadiusBorderTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintText: 'Enter value',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide(color: AppColors.divider, width: 0.5),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide(color: AppColors.divider, width: 0.5),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide(color: AppColors.divider, width: 0.5),
  ),
);

const String kDefaultCountryCode = "+507";

const LatLng kDefaultLocation = LatLng(8.9824623, -79.5548891);

const kDNIMasks = [
  'x-xxxx-xxxxx',
  'PE-xxxx-xxxxxx',
  'E-xxxx-xxxxx',
  'N-xxxx-xxxxx',
  '1AV-xxxx-xxxxx',
  '1PI-xxxx-xxxxx',
];



/*******************************/


void showInfoDialog(
    String message,
    BuildContext context, {
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