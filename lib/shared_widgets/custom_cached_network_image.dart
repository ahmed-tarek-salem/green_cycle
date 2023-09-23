import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final double height;
  final double width;
  final String? imageUrl;
  final Color? colorLoading;
  final BoxFit? fit;
  const CustomCachedNetworkImage(
      {required this.height,
      required this.width,
      required this.imageUrl,
      this.colorLoading,
      this.fit,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ??
          "https://hawahabetary.designfy.net/dashboard-assets/images/default.png",
      height: height,
      width: width,
      placeholder: (context, url) => CustomProgressIndicator(
        color: colorLoading,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: fit ?? BoxFit.fill,
    );
  }
}
