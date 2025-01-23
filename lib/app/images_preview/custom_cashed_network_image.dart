import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/show_toast.dart';
import '../utils/network/end_points.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width = 100.0,
    this.height = 100.0,
    this.isBaseURL = false,
    this.fit = BoxFit.cover,
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
      placeholder: (context, url) => loadingIndicator,
      errorWidget: (context, url, error) => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.w),
          child: const CustomImageAsset(
            assetName: AppAssets.logo,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
