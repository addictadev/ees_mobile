// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class MyShared {
  static late SharedPreferences sharedPreferences;
  static Future<void> initShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
