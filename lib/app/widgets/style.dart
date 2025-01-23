import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

BoxDecoration getBoxDecoration(
    {Color? fillColor,
    Color? borderColor,
    double? radus,
    List<Color>? gradientColors,
    bool withShadwos = true,
    String? imageUrl,
    String? baseUrl,
    Alignment? start,
    dynamic border,
    end}) {
  ImageProvider? imageProvider;

  if (baseUrl != null) {
    if (baseUrl.startsWith('http') || baseUrl.startsWith('https')) {
      imageProvider = NetworkImage(baseUrl + imageUrl!.toString());
    } else {
      imageProvider = AssetImage(imageUrl!.toString());
    }
  }

  return BoxDecoration(
    borderRadius: border ?? BorderRadius.circular(radus ?? 3.w),
    color: fillColor ?? Colors.white,
    border: Border.all(color: borderColor ?? Colors.transparent),
    boxShadow: withShadwos
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(0, 3.0),
              blurRadius: 5.0,
            ),
          ]
        : [],
    gradient: gradientColors != null
        ? LinearGradient(
            begin: start ?? Alignment.topRight,
            end: end ?? Alignment.bottomLeft,
            colors: gradientColors,
          )
        : null,
    image: imageProvider != null
        ? DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          )
        : null,
  );
}
