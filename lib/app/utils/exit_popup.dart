// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../images_preview/custom_asset_img.dart';

class ExitPopUp extends StatefulWidget {
  const ExitPopUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExitPopUpState createState() => _ExitPopUpState();
}

class _ExitPopUpState extends State<ExitPopUp>
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
            width: 300,
            decoration: ShapeDecoration(
                color: const Color.fromARGB(255, 248, 244, 244),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
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
                    'Do you want to exit the application?'.tr(),
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
                          'Yes'.tr(),
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: () => exit(0),
                      ),
                      TextButton(
                        child: Text(
                          'No'.tr(),
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
