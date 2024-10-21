import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base_client/baseClient_controller.dart';
import '../../home/home_controller.dart';
class SelectController extends GetxController with BaseController {
  var counterText = ''.obs;


  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;




  void setSchool(String? value) {
    _schoolValue = value;
  }

  void setTour(String? value) {
    _tourValue = value;
  }



  // Clear fields
  void clearFields() {
    _tourValue = null;
    _schoolValue = null;
    update();
  }
}
