import 'package:flutter/material.dart';

import '../../config/app_assets.dart';

class AppRotatingLogoLoader extends StatefulWidget {
  const AppRotatingLogoLoader({super.key, this.size = 24});

  final double size;

  @override
  State<AppRotatingLogoLoader> createState() => _AppRotatingLogoLoaderState();
}

class _AppRotatingLogoLoaderState extends State<AppRotatingLogoLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        AppAssets.splashLogo,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
      ),
    );
  }
}
