import 'package:flutter/material.dart';

class ValidateTools {
  bool validarTextFields(
    List<TextEditingController> controllers, {
    List<TextEditingController>? numbercontrollers,
  }) {
    bool isControllerFilled = controllers.every(
      (tec) => tec.text.trim().isNotEmpty && tec.text.trim().length > 3,
    );

    if (numbercontrollers != null) {
      bool isNumberControllerFilled = numbercontrollers.every(
        (tec) => tec.text.trim().isNotEmpty,
      );
      return isNumberControllerFilled && isNumberControllerFilled;
    }
    return isControllerFilled;
  }
}
