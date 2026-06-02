import '../../../../core/utils/api_url_resolver.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarPath,
    this.vehicles = const [],
    this.locations = const [],
  });

  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarPath;
  final List<UserVehicle> vehicles;
  final List<UserSavedLocation> locations;

  String? get avatarUrl => resolveApiAssetUrl(avatarPath);

  String get displayName => name.trim().isEmpty ? 'User' : name.trim();

  /// Preferred saved location for home station suggestions.
  UserSavedLocation? get primaryLocation {
    if (locations.isEmpty) {
      return null;
    }
    for (final location in locations) {
      if (location.isDefault) {
        return location;
      }
    }
    return locations.first;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final userPayload = payload['user'] is Map<String, dynamic>
        ? payload['user'] as Map<String, dynamic>
        : payload;

    final vehiclesRaw = userPayload['vehicles'] ?? payload['vehicles'];
    final vehicles = vehiclesRaw is List
        ? vehiclesRaw
              .whereType<Map<String, dynamic>>()
              .map(UserVehicle.fromJson)
              .toList()
        : const <UserVehicle>[];

    final locationsRaw =
        userPayload['locations'] ??
        payload['locations'] ??
        userPayload['saved_locations'] ??
        payload['saved_locations'];
    final locations = UserSavedLocation.listFromJson(locationsRaw);

    return UserProfile(
      id: _readInt(userPayload['id'] ?? payload['id']),
      name: '${userPayload['name'] ?? payload['name'] ?? ''}',
      email: userPayload['email'] as String? ?? payload['email'] as String?,
      phone:
          userPayload['phone'] as String? ??
          userPayload['mobile'] as String? ??
          payload['phone'] as String? ??
          payload['mobile'] as String?,
      avatarPath:
          userPayload['avatar'] as String? ?? payload['avatar'] as String?,
      vehicles: vehicles,
      locations: locations,
    );
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    return int.tryParse('$value') ?? 0;
  }
}

class UserSavedLocation {
  const UserSavedLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.isDefault = false,
  });

  final int id;
  final double latitude;
  final double longitude;
  final String address;
  final bool isDefault;

  factory UserSavedLocation.fromJson(Map<String, dynamic> json) {
    return UserSavedLocation(
      id: UserProfile._readInt(json['id']),
      latitude: double.tryParse('${json['latitude']}') ?? 0,
      longitude: double.tryParse('${json['longitude']}') ?? 0,
      address: '${json['address'] ?? ''}'.trim(),
      isDefault:
          json['is_default'] == true ||
          json['isDefault'] == true ||
          json['default'] == true,
    );
  }

  static List<UserSavedLocation> listFromJson(Object? raw) {
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(UserSavedLocation.fromJson)
          .where((location) => location.address.isNotEmpty)
          .toList();
    }

    if (raw is Map<String, dynamic>) {
      return [UserSavedLocation.fromJson(raw)];
    }

    return const [];
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
      id: UserProfile._readInt(json['id']),
      vehicleNumber: json['vehicle_number'] as String? ?? '',
      vehicleType: json['vehicle_type'] as String?,
      isDefault: json['is_default'] == true,
    );
  }
}
