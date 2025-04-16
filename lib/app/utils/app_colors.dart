import 'package:flutter/material.dart';

class AppColors {
  factory AppColors() {
    return _instance;
  }
  AppColors._();
  static final AppColors _instance = AppColors._();
  // App main colors
  //#FF9F43
  static const primary = Color(0xff487CD6);

  static const Color white = Color(0xffFFFFFF);
  static const Color whiteBg = Color(0xffF5F9FF);
  static const Color black = Color(0xff000000);
  static const Color btnColor = Color(0xff084ABB);
  static const Color lightOrange = Color(0xffD69448);
  static const Color orange = Color(0xffF56E35);
  static const Color darkOrange = Color(0xffD69448);
  static const Color brown = Color(0xffFCF2E6);
  static const Color lightBrown = Color(0xffBD7669);
  static const Color lightBlue = Color(0xff9EB3E5);
  static const Color red = Color(0xffD64848);
  static const Color green = Color(0xff66CC99);
  static const Color grey = Color.fromARGB(87, 226, 226, 226);
  static const Color blueColor = Color(0xff5D80D3);
  static const Color bluebgColor = Color(0xffEDF0F6);
  static const Color blueLightProfileColor = Color(0xff00A1F3);
  static const Color transparent = Colors.transparent;
  static const Color titleColor = Color(0xff203255);

  LinearGradient orangeGradient =
      const LinearGradient(colors: [darkOrange, orange, lightOrange]);

  LinearGradient blackWhiteGradient = LinearGradient(
      colors: [black.withOpacity(0.6), transparent],
      transform: const GradientRotation(145),
      stops: const [0.25, 1]);
}
