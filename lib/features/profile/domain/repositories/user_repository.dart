import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../main/data/booking_flow_mock_data.dart';
import '../../data/models/user_profile.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfile>> fetchProfile();

  Future<Either<Failure, void>> addVehicles(List<String> vehicleNumbers);

  Future<Either<Failure, List<VehicleMock>>> fetchVehicles();

  Future<Either<Failure, void>> updateVehicle({
    required String vehicleId,
    required String vehicleNumber,
  });

  Future<Either<Failure, void>> deleteVehicle(String vehicleId);

  Future<Either<Failure, void>> setDefaultVehicle(String vehicleId);

  Future<Either<Failure, UserProfile>> updateProfile({
    required String name,
    required String email,
    required String phone,
  });
}
