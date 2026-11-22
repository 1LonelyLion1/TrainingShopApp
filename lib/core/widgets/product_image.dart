import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Изображение с дисковым кешем, поэтому просмотренные товары видны офлайн.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
    if (url.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      placeholder: (_, _) =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget: (_, _, _) => placeholder,
    );
  }
}
