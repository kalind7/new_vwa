import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_paths.dart';
import 'main_shell_mock_data.dart';
import 'models/service_station_mapper.dart';
import 'wash_station_repository.dart';

class ApiWashStationRepository implements WashStationRepository {
  const ApiWashStationRepository(this._apiClient);

  final ApiClient _apiClient;

  static final _softErrorOptions = Options(
    validateStatus: (status) => status != null && status < 500,
  );

  @override
  Future<List<WashStationMock>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    try {
      return switch (source) {
        StationListSource.all => _fetchAll(),
        StationListSource.nearby => _fetchNearest(
          latitude: latitude,
          longitude: longitude,
        ),
        StationListSource.lessDistance => _fetchSuggestNearest(
          latitude: latitude,
          longitude: longitude,
          locationLabel: locationLabel,
        ),
      };
    } catch (_) {
      return const [];
    }
  }

  Future<List<WashStationMock>> _fetchAll() async {
    final data = await _getJson(ApiPaths.serviceStations);
    if (data == null) {
      return const [];
    }
    return ServiceStationMapper.fromListResponse(data);
  }

  Future<List<WashStationMock>> _fetchNearest({
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      return const [];
    }

    final data = await _getJson(
      ApiPaths.nearestStations,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': 10,
      },
    );
    if (data == null) {
      return const [];
    }
    return ServiceStationMapper.fromNearestResponse(data);
  }

  Future<List<WashStationMock>> _fetchSuggestNearest({
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    if (latitude == null || longitude == null) {
      return const [];
    }

    await _syncUserLocation(
      latitude: latitude,
      longitude: longitude,
      address: locationLabel,
    );

    final data = await _getJson(ApiPaths.suggestStationNearest);
    if (data == null) {
      return const [];
    }
    return ServiceStationMapper.fromSuggestResponse(data);
  }

  Future<void> _syncUserLocation({
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.saveLocation,
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'address': address ?? 'Current location',
        },
        options: _softErrorOptions,
      );
    } catch (_) {
      // Suggest may still work if the user already has a saved location.
    }
  }

  Future<Map<String, dynamic>?> _getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      options: _softErrorOptions,
    );
    return response.data;
  }
}
