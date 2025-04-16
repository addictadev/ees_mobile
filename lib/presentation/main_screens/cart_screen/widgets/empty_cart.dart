import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

import '../../../../app/images_preview/custom_asset_img.dart';
import '../../../../app/navigation_services/navigation_manager.dart';
import '../../../../app/utils/app_assets.dart';
import '../../../../app/widgets/app_button.dart';
import '../../../../app/widgets/app_text.dart';
import '../../main_nav_screen.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: CustomImageAsset(
          assetName: AppAssets.emptyCart,
          width: 45.w,
        )),
        1.height,
        CustomText(
          text: 'لا يوجد منتجات في العربة',
          fontSize: 18.sp,
          fontweight: FontWeight.w500,
        ),
        1.height,
        CustomText(
            text: 'تقدر تضيف منتجات في العربة وتعمل فاتورة\n بضغطة واحدة',
            color: Colors.grey),
        2.height,
        AppButton(
          'اطلب الان',
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
          onTap: () {
            NavigationManager.navigatToAndFinish(MainScreen(
              currentIndex: 0,
            ));
          },
        ),
      ],
    );
  }
}
