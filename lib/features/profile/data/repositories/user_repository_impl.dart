import 'package:fpdart/fpdart.dart';

import '../../../../config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../datasources/vehicle_remote_data_source.dart';
import '../../../main/data/booking_flow_mock_data.dart';
import '../models/user_profile.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({
    required ProfileRemoteDataSource profileRemoteDataSource,
    required VehicleRemoteDataSource vehicleRemoteDataSource,
  }) : _profileRemoteDataSource = profileRemoteDataSource,
       _vehicleRemoteDataSource = vehicleRemoteDataSource;

  final ProfileRemoteDataSource _profileRemoteDataSource;
  final VehicleRemoteDataSource _vehicleRemoteDataSource;

  @override
  Future<Either<Failure, UserProfile>> fetchProfile() async {
    if (AppConfig.useMockData) {
      return right(
        const UserProfile(
          id: 0,
          name: 'Demo User',
          email: 'demo@vwa.app',
          phone: '9800000000',
          vehicles: [
            UserVehicle(
              id: 1,
              vehicleNumber: 'BA PA 1097',
              vehicleType: 'bike',
            ),
          ],
        ),
      );
    }

    return _profileRemoteDataSource.fetchProfile();
  }

  @override
  Future<Either<Failure, void>> addVehicles(List<String> vehicleNumbers) async {
    final plates = vehicleNumbers
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (plates.isEmpty) {
      return left(const ValidationFailure('Add at least one vehicle number.'));
    }

    if (AppConfig.useMockData) {
      return right(null);
    }

    return _vehicleRemoteDataSource.addVehicles(vehicleNumbers: plates);
  }

  @override
  Future<Either<Failure, List<VehicleMock>>> fetchVehicles() async {
    if (AppConfig.useMockData) {
      return right(vehicles);
    }

    return _vehicleRemoteDataSource.fetchVehicles();
  }

  @override
  Future<Either<Failure, void>> updateVehicle({
    required String vehicleId,
    required String vehicleNumber,
  }) async {
    if (AppConfig.useMockData) {
      return right(null);
    }

    return _vehicleRemoteDataSource.updateVehicle(
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
    );
  }

  @override
  Future<Either<Failure, void>> deleteVehicle(String vehicleId) async {
    if (AppConfig.useMockData) {
      return right(null);
    }

    return _vehicleRemoteDataSource.deleteVehicle(vehicleId);
  }

  @override
  Future<Either<Failure, void>> setDefaultVehicle(String vehicleId) async {
    if (AppConfig.useMockData) {
      return right(null);
    }

    return _vehicleRemoteDataSource.setDefaultVehicle(vehicleId);
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (AppConfig.useMockData) {
      return right(
        UserProfile(
          id: 0,
          name: name,
          email: email,
          phone: phone,
          vehicles: const [
            UserVehicle(
              id: 1,
              vehicleNumber: 'BA PA 1097',
              vehicleType: 'bike',
            ),
          ],
        ),
      );
    }

    return _profileRemoteDataSource.updateProfile(
      name: name,
      email: email,
      phone: phone,
    );
  }
}
