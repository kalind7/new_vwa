import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/failure_mapper.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_paths.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;
}

class NotificationListRemoteDataSource {
  const NotificationListRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, List<AppNotification>>> fetchNotifications() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.notifications,
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final data = response.data?['data'];
      if (data is! Map<String, dynamic>) {
        return right([]);
      }

      final items = data['notifications'];
      if (items is! List) {
        return right([]);
      }

      return right(
        items
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => AppNotification(
                id: '${item['id']}',
                title: item['title']?.toString() ?? '',
                message: item['message']?.toString() ?? '',
                type: item['type']?.toString() ?? '',
                isRead: item['is_read'] == true,
                createdAt: item['created_at']?.toString() ?? '',
              ),
            )
            .toList(),
      );
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.notificationRead(id),
        options: Options(headers: const {'Accept': 'application/json'}),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.notificationsReadAll,
        options: Options(headers: const {'Accept': 'application/json'}),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }
}
