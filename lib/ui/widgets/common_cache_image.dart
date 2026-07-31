import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/ui/widgets/common_shimmer.dart';

class CommonCacheImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CommonCacheImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          CommonShimmer.rectangular(
            height: height ?? double.infinity,
            width: width ?? double.infinity,
          ),
      errorWidget: (context, url, error) => errorWidget ?? _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColour.white.withValues(alpha: 0.05),
      child: const Center(
        child: Icon(
          Icons.pets_rounded,
          color: AppColour.primaryAccent,
          size: 24,
        ),
      ),
    );
  }
}
