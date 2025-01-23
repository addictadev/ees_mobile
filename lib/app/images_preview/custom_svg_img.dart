import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgImage extends StatelessWidget {
  const CustomSvgImage({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
  });
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final svgPicture = SvgPicture.asset(
      assetName,
      width: width,
      height: height,
    );

    if (color != null) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        child: svgPicture,
      );
    }

    return svgPicture;
  }
}
