import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_cities/generated/i18n.dart';

extension TimeOfDayExtension on TimeOfDay {
  String get formatted {
    if (this == null) return "";

    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, this.hour, this.minute);
    final format = DateFormat('h:mm a');
    return format.format(dt);
  }
}


String strfTime(DateTime time, BuildContext context){
  var month='';
  switch(time.month){
    case 1 :
      month= S.of(context).january;
      break;
    case 2 :
      month= S.of(context).february;
      break;
    case 3 :
      month= S.of(context).march;
      break;
    case 4 :
      month= S.of(context).april;
      break;
    case 5 :
      month= S.of(context).may;
      break;
    case 6 :
      month= S.of(context).june;
      break;
    case 7 :
      month= S.of(context).july;
      break;
    case 8 :
      month= S.of(context).august;
      break;
    case 9 :
      month= S.of(context).september;
      break;
    case 10 :
      month= S.of(context).october;
      break;
    case 11 :
      month= S.of(context).november;
      break;
    case 12 :
      month= S.of(context).december;
      break;
  }

  return month;

}