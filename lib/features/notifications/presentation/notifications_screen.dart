import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_spacing.dart';
import '../../../config/app_text_styles.dart';
import '../../../core/di/app_dependencies.dart';
import '../../../shared/widgets/app_loading_overlay.dart';
import '../../../shared/widgets/app_screen_header.dart';
import '../../../shared/widgets/app_toast.dart';
import '../data/notification_list_remote_data_source.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var _isLoading = true;
  List<AppNotification> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final dataSource = context
        .read<AppDependencies>()
        .notificationListRemoteDataSource;
    final result = await dataSource.fetchNotifications();
    if (!mounted) {
      return;
    }
    result.fold(
      (failure) => AppToast.showError(context, failure.message),
      (items) => setState(() => _items = items),
    );
    setState(() => _isLoading = false);
  }

  Future<void> _markRead(AppNotification item) async {
    if (item.isRead) {
      return;
    }
    final dataSource = context
        .read<AppDependencies>()
        .notificationListRemoteDataSource;
    await dataSource.markAsRead(item.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: buildAppScreenHeader(context, title: 'Notifications'),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _load,
            child: _items.isEmpty && !_isLoading
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Text(
                          'No notifications yet.\nBooking updates will appear here.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textMdRegular.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return InkWell(
                        onTap: () => _markRead(item),
                        borderRadius: BorderRadius.circular(12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: item.isRead
                                ? AppColors.white
                                : AppColors.brand25,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.gray200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: AppTextStyles.textMdSemiBold.copyWith(
                                    color: AppColors.gray900,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  item.message,
                                  style: AppTextStyles.textSmRegular.copyWith(
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_isLoading) const AppLoadingOverlay(),
        ],
      ),
    );
  }
}
