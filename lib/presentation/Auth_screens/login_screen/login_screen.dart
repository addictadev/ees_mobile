import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              20.height,
              Image.asset(AppAssets.appLogo),
              2.height,
              CustomText(
                  text: 'أهلًا بك!', fontSize: AppFonts.t1, isBold: true),
              1.height,
              CustomText(
                  text: 'دلوقتي تقدر تشوف الاف المنتجات وتعمل طلبيتك بسهولة'),
              2.height,
              AppTextField(
                hintText: 'ادخل رقم الموبايل',
              )
            ],
          )),
    );
  }
}
