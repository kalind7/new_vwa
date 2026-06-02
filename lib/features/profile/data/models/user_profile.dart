import '../../../../core/utils/api_url_resolver.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarPath,
    this.vehicles = const [],
  });

  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarPath;
  final List<UserVehicle> vehicles;

  String? get avatarUrl => resolveApiAssetUrl(avatarPath);

  String get displayName => name.trim().isEmpty ? 'User' : name.trim();

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final vehiclesRaw = payload['vehicles'];
    final vehicles = vehiclesRaw is List
        ? vehiclesRaw
              .whereType<Map<String, dynamic>>()
              .map(UserVehicle.fromJson)
              .toList()
        : const <UserVehicle>[];

    return UserProfile(
      id: payload['id'] as int? ?? 0,
      name: payload['name'] as String? ?? '',
      email: payload['email'] as String?,
      phone: payload['phone'] as String? ?? payload['mobile'] as String?,
      avatarPath: payload['avatar'] as String?,
      vehicles: vehicles,
    );
  }
}

class UserVehicle {
  const UserVehicle({
    required this.id,
    required this.vehicleNumber,
    this.vehicleType,
    this.isDefault = false,
  });

  final int id;
  final String vehicleNumber;
  final String? vehicleType;
  final bool isDefault;

  factory UserVehicle.fromJson(Map<String, dynamic> json) {
    return UserVehicle(
      id: json['id'] as int? ?? 0,
      vehicleNumber: json['vehicle_number'] as String? ?? '',
      vehicleType: json['vehicle_type'] as String?,
      isDefault: json['is_default'] == true,
    );
  }
}
