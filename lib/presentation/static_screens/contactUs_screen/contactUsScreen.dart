import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/validators.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controllers/static_controller.dart';

class Contactusscreen extends StatelessWidget {
  const Contactusscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StaticProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return Form(
          key: value.formKey,
          child: Column(
            children: [
              CustomeAppBar(text: 'اتصل بنا'),
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    3.height,
                    Center(child: Image.asset(AppAssets.appLogo, width: 70.w)),
                    4.height,
                    CustomText(text: 'الاسم بالكامل', fontSize: 16.sp),
                    AppTextField(
                      hintText: 'ادخل الاسم',
                      controller: value.nameController,
                      validator: (p0) => Validator.name(p0),
                    ),
                    2.height,
                    CustomText(text: 'رقم الجوال', fontSize: 16.sp),
                    AppTextField(
                      hintText: 'ادخل رقم الجوال',
                      controller: value.phoneController,
                      validator: (val) => Validator.phoneValidator(val),
                    ),
                    2.height,
                    CustomText(text: 'الرسالة', fontSize: 16.sp),
                    AppTextField(
                      hintText: 'ادخل الرسالة',
                      controller: value.messageController,
                      lines: 3,
                      validator: (p0) => Validator.text(p0),
                    ),
                    4.height,
                    AppButton('ارسال', onTap: () {
                      if (value.formKey.currentState!.validate()) {
                        // value.contactUs(context);
                      }
                    })
                  ],
                ),
              ))
            ],
          ),
        );
      }),
    );
  }
}
