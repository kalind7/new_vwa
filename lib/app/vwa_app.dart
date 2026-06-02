import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'connectivity_gate.dart';
import '../config/app_theme.dart';
import '../shared/utils/keyboard_utils.dart';

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
      builder: (context, child) {
        final wrappedChild = child == null
            ? const SizedBox.shrink()
            : DismissKeyboardOnTap(child: ConnectivityGate(child: child));
        return BotToastInit()(context, wrappedChild);
      },
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}
