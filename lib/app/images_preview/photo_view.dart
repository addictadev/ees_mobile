import 'package:cached_network_image/cached_network_image.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomeAppBar(text: 'صورة المنتج'),
          Expanded(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.8,
              initialScale: PhotoViewComputedScale.contained,
              backgroundDecoration: BoxDecoration(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
