import 'package:flutter/material.dart';
import 'package:smart_cities/src/core/util/validator.dart';
import 'package:smart_cities/src/di/injection_container.dart' as di;

mixin BaseForm {
  final validator = di.sl<Validator>();

  void setControllerValue(TextEditingController controller, String value) {
    controller.text = value;

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
