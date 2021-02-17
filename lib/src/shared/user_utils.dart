import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/util/string_util.dart';
import 'constant.dart';

class UserUtils {
  static Future<String> uploadUserPhoto(
    FirebaseStorage firebaseStorage,
    String userUID,
    File file,
  ) async {
    String url = '';

    try {
      if (file == null || userUID == null) return url;

      final fileRoute = 'profileImages/$userUID.jpg';
      final StorageReference storageRef =
          firebaseStorage.ref().child(fileRoute);

      StorageUploadTask uploadTask = storageRef.putFile(file);

      final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

      String bucket = await downloadUrl.ref.getBucket();
      String path = await downloadUrl.ref.getPath();

      url = 'gs://$bucket/$path';
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);

      throw UnexpectedFailure();
    }

    return url;
  }

  static List<String> parseNames(String names) {
    if (names.isNullOrEmpty) return ["", ""];

    var namesSplit = names.trim().split(' ');
    var firstName = namesSplit.first;
    var lastName = namesSplit.last;

    if (namesSplit.length == 3) {
      firstName = namesSplit[0];
      lastName = '${namesSplit[1]} ${namesSplit[2]}';
    } else if (namesSplit.length == 4) {
      firstName = '${namesSplit[0]} ${namesSplit[1]}';
      lastName = '${namesSplit[2]} ${namesSplit[3]}';
    } else if (namesSplit.length == 5) {
      firstName = '${namesSplit[0]} ${namesSplit[1]} ${namesSplit[2]}';
      lastName = '${namesSplit[3]} ${namesSplit[4]}';
    }

    return [firstName, lastName];
  }

  static List<String> parsePhoneNumber(String phoneNumber) {
    if (phoneNumber == null) return [kDefaultCountryCode, null];

    final start = phoneNumber.indexOf('+');
    final end = phoneNumber.indexOf(' ');

    final contryCode = start > -1 && end > -1
        ? phoneNumber.substring(start, end)
        : kDefaultCountryCode;

    final phone = phoneNumber
        .replaceFirst(contryCode, '')
        .replaceAll(RegExp(r'[()-\s]'), '')
        .formatPhoneNumber();

    return [contryCode, phone];
  }

  static launchCall(String phone, BuildContext context) async {
    String telf = 'tel:$phone';
    if (await canLaunch(telf)) {
      await launch(telf);
    } else {
      throw('Error No se pudo iniciar la aplicacion');
    }
  }
}
