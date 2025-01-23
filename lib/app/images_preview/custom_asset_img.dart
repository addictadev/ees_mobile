import 'package:flutter/material.dart';

class CustomImageAsset extends StatelessWidget {
  const CustomImageAsset(
      {super.key,
      required this.assetName,
      this.width,
      this.height,
      this.color,
      this.opacity,
      this.fit});
  final String assetName;
  final double? width;
  final double? height;
  final double? opacity;
  final Color? color;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      opacity: AlwaysStoppedAnimation(opacity ?? 1.0),
    );

    if (color != null) {
      image = ColorFiltered(
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        child: image,
      );
    }

    return image;
  }
}
