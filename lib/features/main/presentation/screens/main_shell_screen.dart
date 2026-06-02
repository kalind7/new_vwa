import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_config.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
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
      child: _MainShellProfileLoader(
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
                body: Stack(
                  children: [
                    IndexedStack(
                      index: provider.currentIndex,
                      children: tabs,
                    ),
                    const _MainShellFcmSync(),
                  ],
                ),
                bottomNavigationBar: MainBottomNav(
                  currentIndex: provider.currentIndex,
                  onChanged: provider.setTab,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MainShellProfileLoader extends StatefulWidget {
  const _MainShellProfileLoader({required this.child});

  final Widget child;

  @override
  State<_MainShellProfileLoader> createState() => _MainShellProfileLoaderState();
}

class _MainShellProfileLoaderState extends State<_MainShellProfileLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<UserProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _MainShellFcmSync extends StatefulWidget {
  const _MainShellFcmSync();

  @override
  State<_MainShellFcmSync> createState() => _MainShellFcmSyncState();
}

class _MainShellFcmSyncState extends State<_MainShellFcmSync> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFcmToken());
  }

  Future<void> _syncFcmToken() async {
    if (!AppConfig.enableFirebaseNotifications || !mounted) {
      return;
    }

    final remote = context.read<AppDependencies>().notificationRemoteDataSource;
    await NotificationService(
      notificationRemote: remote,
    ).syncTokenWithBackend();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
