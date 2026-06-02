import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_colors.dart';
import '../../../../shared/widgets/app_confirmation_dialog.dart';
import '../providers/main_shell_provider.dart';
import '../widgets/main_bottom_nav.dart';
import 'home_tab.dart';
import 'my_wash_tab.dart';
import 'profile_tab.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  Future<void> _confirmExit(BuildContext context) async {
    final shouldExit = await showAppConfirmationDialog(
      context: context,
      title: 'Exit app?',
      message: 'Do you want to exit the app?',
      confirmLabel: 'Yes',
      cancelLabel: 'No',
    );

    if (shouldExit && context.mounted) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const tabs = [HomeTab(), MyWashTab(), ProfileTab()];

    return ChangeNotifierProvider(
      create: (_) => MainShellProvider(initialIndex: initialIndex),
      child: Consumer<MainShellProvider>(
        builder: (context, provider, _) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) {
                _confirmExit(context);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: IndexedStack(index: provider.currentIndex, children: tabs),
              bottomNavigationBar: MainBottomNav(
                currentIndex: provider.currentIndex,
                onChanged: provider.setTab,
              ),
            ),
          );
        },
      ),
    );
  }
}
