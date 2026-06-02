import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../config/app_assets.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.avatarUrl, required this.size});

  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl;
    if (url != null && url.isNotEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, _) => _placeholder(size),
          errorWidget: (_, _, _) => _placeholder(size),
        ),
      );
    }

    return _placeholder(size);
  }

  Widget _placeholder(double size) {
    return Image.asset(
      AppAssets.homeAvatar,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
