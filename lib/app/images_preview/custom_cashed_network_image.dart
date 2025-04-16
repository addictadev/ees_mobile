import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'custom_asset_img.dart';
import '../utils/app_assets.dart';
import '../utils/network/end_points.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width = 90.0,
    this.height = 90.0,
    this.isBaseURL = false,
    this.fit = BoxFit.fill,
  });
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final bool isBaseURL;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: isBaseURL ? EndPoints.baseUrlImgs + imageUrl : imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Skeletonizer(
        enabled: true,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.w),
            child: const CustomImageAsset(
              assetName: AppAssets.logo,
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2.w),
          child: CustomImageAsset(
            assetName: AppAssets.logo,
            fit: BoxFit.fill,
            height: height,
            width: width,
          ),
        ),
      ),
    );
  }
}
