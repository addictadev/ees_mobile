import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomeAppBar(
              text: 'الشروط و الاحكام', onTap: () => NavigationManager.pop()),
          CustomImageAsset(
            assetName: AppAssets.appLogo,
            width: 50.w,
          ),
          1.height,
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  physics: BouncingScrollPhysics(),
                  child: CustomText(
                      text: 'data static for term and condtions ' * 120)))
        ],
      ),
    );
  }
}
