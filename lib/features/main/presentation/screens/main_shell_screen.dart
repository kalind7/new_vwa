import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_colors.dart';
import '../providers/main_shell_provider.dart';
import '../widgets/main_bottom_nav.dart';
import 'home_tab.dart';
import 'my_wash_tab.dart';
import 'profile_tab.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tabs = [HomeTab(), MyWashTab(), ProfileTab()];

    return ChangeNotifierProvider(
      create: (_) => MainShellProvider(),
      child: Consumer<MainShellProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: IndexedStack(index: provider.currentIndex, children: tabs),
            bottomNavigationBar: MainBottomNav(
              currentIndex: provider.currentIndex,
              onChanged: provider.setTab,
            ),
          );
        },
      ),
    );
  }
}
