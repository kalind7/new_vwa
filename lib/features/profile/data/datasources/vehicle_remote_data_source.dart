import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../../../main/data/booking_flow_mock_data.dart';

class VehicleRemoteDataSource {
  const VehicleRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// Registers each plate with a separate POST (API accepts one `vehicle_number` per request).
  Future<Either<Failure, void>> addVehicles({
    required List<String> vehicleNumbers,
    String vehicleType = 'bike',
  }) async {
    if (vehicleNumbers.isEmpty) {
      return left(const ValidationFailure('Add at least one vehicle number.'));
    }

    for (final raw in vehicleNumbers) {
      final plate = raw.trim();
      final result = await _addSingleVehicle(
        vehicleNumber: plate,
        vehicleType: vehicleType,
      );
      final failure = result.fold((left) => left, (_) => null);
      if (failure != null) {
        return left(failure);
      }
    }

    return right(null);
  }

  Future<Either<Failure, List<VehicleMock>>> fetchVehicles() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.vehicles,
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid vehicles response from server.'),
        );
      }

      final list = data['data'] is List
          ? data['data'] as List
          : data['vehicles'] is List
          ? data['vehicles'] as List
          : data['data'] is Map<String, dynamic> &&
                (data['data'] as Map)['vehicles'] is List
          ? (data['data'] as Map)['vehicles'] as List
          : const [];

      final vehicles = list
          .whereType<Map<String, dynamic>>()
          .map(
            (json) => VehicleMock(
              id: '${json['id'] ?? ''}',
              plate: '${json['vehicle_number'] ?? json['number'] ?? ''}'.trim(),
              isDefault: json['is_default'] == true,
              vehicleType: '${json['vehicle_type'] ?? 'bike'}',
            ),
          )
          .where((vehicle) => vehicle.id.isNotEmpty && vehicle.plate.isNotEmpty)
          .toList();

      return right(vehicles);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, void>> updateVehicle({
    required String vehicleId,
    required String vehicleNumber,
    String vehicleType = 'bike',
  }) async {
    try {
      await _apiClient.dio.put<Map<String, dynamic>>(
        ApiPaths.vehicleDetails(vehicleId),
        data: {'vehicle_number': vehicleNumber, 'vehicle_type': vehicleType},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, void>> deleteVehicle(String vehicleId) async {
    try {
      await _apiClient.dio.delete<Map<String, dynamic>>(
        ApiPaths.vehicleDetails(vehicleId),
        options: Options(headers: const {'Accept': 'application/json'}),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, void>> setDefaultVehicle(String vehicleId) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.setDefaultVehicle(vehicleId),
        options: Options(headers: const {'Accept': 'application/json'}),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, void>> _addSingleVehicle({
    required String vehicleNumber,
    required String vehicleType,
  }) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.vehicles,
        data: {'vehicle_number': vehicleNumber, 'vehicle_type': vehicleType},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }
}
