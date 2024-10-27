import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ClubItemPhotoView extends StatelessWidget {
  final CachedNetworkImageProvider itemPhoto;

  const ClubItemPhotoView({
    super.key,
    required this.itemPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFFFCFCFC)),
      ),
      body: PhotoView(
        imageProvider: itemPhoto,
        backgroundDecoration: const BoxDecoration(color: Color(0xFF111111)),
        maxScale: PhotoViewComputedScale.covered * 2,
        minScale: PhotoViewComputedScale.contained * 0.5,
      ),
    );
  }
}
