import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:photo_view/photo_view.dart';

import '../navigation_services/navigation_manager.dart';
import '../utils/app_colors.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primary),
        leading: InkWell(
          onTap: () => NavigationManager.pop(),
          child: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                child: Icon(
                  translator.activeLanguageCode == "en"
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
      ),
    );
  }
}
