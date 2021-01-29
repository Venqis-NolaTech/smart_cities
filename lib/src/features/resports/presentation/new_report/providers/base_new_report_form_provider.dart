import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/entities/catalog_item.dart';
import '../../../../../shared/provider/base_provider.dart';

class DataKey {
  // global key
  static const UID = "uid";
  static const TYPE_PROCEDURE = "type_procedure";
  static const IS_ANONYMOUS = "anonymous";

  // denoncier keys
  static const FIRST_NAME = "first_name";
  static const LAST_NAME = "last_name";
  static const DNI = "dni";
  static const PROVINCE = "province";
  static const GENDER = "gender";
  static const CODE_AREA = "code_area";
  static const PHONE_NUMBER = "phone_number";
  static const AGE = "age";
  static const INSTITUTION = "institution";
  static const RIGHT_VIOLATED = "right_violated";
  static const YEAR = "year";
  static const NATIONALITY = "nationality";

  // report keys
  static const MUNICIPALITY = "municipality";
  static const SECTOR = "sector";
  static const NEIGHBORHOOD = "neighborhood";
  static const TITLE = "title";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const IMAGES = "images";
  static const LATITUDE = "latitude";
  static const LONGITUDE = "longitude";
  static const STREET = "street";
  static const NUMBER_ADDRESS = "numberAddress";
  static const ISANONYMOUS = "isAnonymous";
  // files
  static const FILES = "files";


  //comment key
  static const COMMENT = "comment";
  static const PICTUREURL = "pictureURL";
}

enum DataType {
  denounced,
  involved,
  entity,
}

const int kMaxFiles = 3;

abstract class BaseNewReportFormProvider extends BaseProvider {
  final List<File> _files = [];

  List<File> get files => _files;

  CatalogItem reportType;

  Future initData();

  Future submitData();

  void addFile(File file) {
    files.add(file);

    notifyListeners();
  }

  int getFilesSize() {
    if (_files.isNotEmpty)
      return _files.map((file) => file.lengthSync()).reduce((a, b) => a + b);

    return 0;
  }

  void removeFile(File file) {
    files.remove(file);

    notifyListeners();
  }

  bool addFileIsValid() =>
      _files.length < kMaxFiles;

  @protected
  void addData(List<Map<String, String>> dataPull, Map<String, String> data) {
    final uid = data[DataKey.UID];
    final index = dataPull.indexWhere((i) => i[DataKey.UID] == uid);

    if (index > -1) {
      dataPull[index] = data;
    } else {
      dataPull.add(data);
    }

    notifyListeners();
  }

  @protected
  void removeData(
      List<Map<String, String>> dataPull, Map<String, String> data) {
    dataPull.remove(data);

    notifyListeners();
  }
}
