import '../../../core/network/api_client.dart';
import '../../../core/network/api_paths.dart';
import 'main_shell_mock_data.dart';
import 'models/service_station_mapper.dart';
import 'wash_station_repository.dart';

class ApiWashStationRepository implements WashStationRepository {
  const ApiWashStationRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<WashStationMock>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
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
        ),
      };
    } catch (_) {
      return const [];
    }
  }

  Future<List<WashStationMock>> _fetchAll() async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.serviceStations,
    );
    final data = response.data;
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

    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.nearestStations,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': 10,
      },
    );
    final data = response.data;
    if (data == null) {
      return const [];
    }
    return ServiceStationMapper.fromNearestResponse(data);
  }

  Future<List<WashStationMock>> _fetchSuggestNearest({
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      return const [];
    }

    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.suggestStationNearest,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    final data = response.data;
    if (data == null) {
      return const [];
    }
    return ServiceStationMapper.fromSuggestResponse(data);
  }
}
