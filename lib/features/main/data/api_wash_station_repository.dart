import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/failure_mapper.dart';
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
  Future<Either<Failure, List<WashStationMock>>> fetchStations({
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
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, List<WashStationMock>>> _fetchAll() async {
    final result = await _getJson(ApiPaths.serviceStations);
    return result.map((data) {
      if (data == null) {
        return const <WashStationMock>[];
      }
      return ServiceStationMapper.fromListResponse(data);
    });
  }

  Future<Either<Failure, List<WashStationMock>>> _fetchNearest({
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      return right(const []);
    }

    final result = await _getJson(
      ApiPaths.nearestStations,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': 10,
      },
    );
    return result.map((data) {
      if (data == null) {
        return const <WashStationMock>[];
      }
      return ServiceStationMapper.fromNearestResponse(data);
    });
  }

  Future<Either<Failure, List<WashStationMock>>> _fetchSuggestNearest({
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    if (latitude == null || longitude == null) {
      return right(const []);
    }

    await _syncUserLocation(
      latitude: latitude,
      longitude: longitude,
      address: locationLabel,
    );

    final result = await _getJson(ApiPaths.suggestStationNearest);
    return result.map((data) {
      if (data == null) {
        return const <WashStationMock>[];
      }
      return ServiceStationMapper.fromSuggestResponse(data);
    });
  }

  Future<void> _syncUserLocation({
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.locations,
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

  @override
  Future<Either<Failure, WashStationMock?>> fetchStationDetail(
    String stationId,
  ) async {
    if (stationId.isEmpty) {
      return right(null);
    }

    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.serviceStationDetails(stationId),
      );
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode != 200) {
        return left(
          mapHttpErrorResponse(
            statusCode: statusCode,
            responseData: response.data,
          ),
        );
      }

      final data = response.data;
      if (data == null) {
        return right(null);
      }
      return right(ServiceStationMapper.fromDetailResponse(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, Map<String, dynamic>?>> _getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode != 200) {
      return left(
        mapHttpErrorResponse(
          statusCode: statusCode,
          responseData: response.data,
        ),
      );
    }
    return right(response.data);
  }
}
