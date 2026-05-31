import 'package:flutter/material.dart';

import 'app_routes.dart';
import '../config/app_theme.dart';

class VwaApp extends StatelessWidget {
  const VwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Washing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
