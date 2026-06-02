import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_assets.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../shared/widgets/app_screen.dart';
import '../../domain/splash_navigation_resolver.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateFromSplash());
  }

  Future<void> _navigateFromSplash() async {
    if (!mounted) {
      return;
    }

    final localStorage = context.read<AppDependencies>().localStorage;
    final destination = await SplashNavigationResolver(localStorage).resolve();

    if (!mounted) {
      return;
    }

    final route = switch (destination) {
      SplashDestination.mainShell => AppRoutes.mainShell,
      SplashDestination.onboarding => AppRoutes.onboarding,
      SplashDestination.login => AppRoutes.login,
    };

    await Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
      backgroundColor: AppColors.white,
      padding: EdgeInsets.zero,
      child: Center(
        child: Image(
          image: AssetImage(AppAssets.splashLogo),
          width: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
