// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../app/images_preview/custom_asset_img.dart';
import '../../../../controllers/home_controller.dart';

class CartPopup extends StatefulWidget {
  const CartPopup({super.key, this.productId, this.variantId, this.propertyId});
  final String? productId, variantId, propertyId;
  @override
  // ignore: library_private_types_in_public_api
  _CartPopupState createState() => _CartPopupState();
}

class _CartPopupState extends State<CartPopup>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            width: 90.w,
            decoration: ShapeDecoration(
                color: const Color.fromARGB(255, 248, 244, 244),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomImageAsset(
                    width: 100,
                    height: 66,
                    assetName: AppAssets.appLogo,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    'السلة تحتوي على منتجات من بائع مختلف، هل تريد مسح السلة الحالية وإضافة المنتج الجديد؟',
                    style:
                        const TextStyle(color: AppColors.primary, fontSize: 16),
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'نعم'.tr(),
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .forceAddToCart(widget.productId,
                                  widget.variantId, widget.propertyId);
                        },
                      ),
                      TextButton(
                        child: Text(
                          'لا'.tr(),
                          style: const TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
