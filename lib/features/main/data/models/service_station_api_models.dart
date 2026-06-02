/// API models generated from live `GET service-stations` responses (quicktype-style).
library;

class ServiceStationListResponse {
  const ServiceStationListResponse({required this.success, required this.data});

  final bool success;
  final List<ServiceStation> data;

  factory ServiceStationListResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = raw is List
        ? raw
              .whereType<Map<String, dynamic>>()
              .map(ServiceStation.fromJson)
              .toList()
        : const <ServiceStation>[];

    return ServiceStationListResponse(
      success: json['success'] == true,
      data: list,
    );
  }
}

class ServiceStationDetailResponse {
  const ServiceStationDetailResponse({
    required this.success,
    required this.data,
  });

  final bool success;
  final ServiceStation data;

  factory ServiceStationDetailResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return ServiceStationDetailResponse(
      success: json['success'] == true,
      data: raw is Map<String, dynamic>
          ? ServiceStation.fromJson(raw)
          : ServiceStation.fromJson(json),
    );
  }
}

class ServiceStation {
  const ServiceStation({
    required this.id,
    required this.name,
    this.companyName,
    this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.email,
    this.capacity,
    this.averageRating,
    this.totalReviews,
    this.products = const [],
    this.operatingHours = const [],
    this.services = const [],
    this.userDistance,
  });

  final int id;
  final String name;
  final String? companyName;
  final String? description;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? email;
  final int? capacity;
  final String? averageRating;
  final int? totalReviews;
  final List<StationProduct> products;
  final List<StationOperatingHour> operatingHours;
  final List<StationServiceItem> services;
  final double? userDistance;

  factory ServiceStation.fromJson(Map<String, dynamic> json) {
    return ServiceStation(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      companyName: json['company_name'] as String?,
      description: json['description'] as String?,
      address: '${json['address'] ?? ''}',
      latitude: double.tryParse('${json['latitude']}') ?? 0,
      longitude: double.tryParse('${json['longitude']}') ?? 0,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      capacity: json['capacity'] is int
          ? json['capacity'] as int
          : int.tryParse('${json['capacity']}'),
      averageRating: json['average_rating']?.toString(),
      totalReviews: json['total_reviews'] is int
          ? json['total_reviews'] as int
          : int.tryParse('${json['total_reviews']}'),
      products:
          (json['products'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(StationProduct.fromJson)
              .toList() ??
          const [],
      operatingHours:
          (json['operating_hours'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(StationOperatingHour.fromJson)
              .toList() ??
          const [],
      services:
          (json['services'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(StationServiceItem.fromJson)
              .toList() ??
          const [],
      userDistance: double.tryParse(
        '${json['user_distance'] ?? json['distance']}',
      ),
    );
  }
}

class StationProduct {
  const StationProduct({
    required this.id,
    required this.name,
    this.price,
    this.durationMinutes,
    this.description,
  });

  final int id;
  final String name;
  final String? price;
  final int? durationMinutes;
  final String? description;

  factory StationProduct.fromJson(Map<String, dynamic> json) {
    return StationProduct(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      price: json['price']?.toString(),
      durationMinutes: json['duration_minutes'] is int
          ? json['duration_minutes'] as int
          : int.tryParse('${json['duration_minutes']}'),
      description: json['description'] as String?,
    );
  }
}

class StationOperatingHour {
  const StationOperatingHour({
    required this.dayOfWeek,
    this.openTime,
    this.closeTime,
    this.isClosed = false,
  });

  final int dayOfWeek;
  final String? openTime;
  final String? closeTime;
  final bool isClosed;

  factory StationOperatingHour.fromJson(Map<String, dynamic> json) {
    return StationOperatingHour(
      dayOfWeek: json['day_of_week'] is int
          ? json['day_of_week'] as int
          : int.tryParse('${json['day_of_week']}') ?? 0,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      isClosed: json['is_closed'] == true,
    );
  }
}

class StationServiceItem {
  const StationServiceItem({
    required this.id,
    required this.name,
    this.serviceName,
    this.description,
    this.isAvailable = true,
  });

  final int id;
  final String name;
  final String? serviceName;
  final String? description;
  final bool isAvailable;

  String get displayName =>
      (serviceName?.trim().isNotEmpty == true ? serviceName! : name).trim();

  factory StationServiceItem.fromJson(Map<String, dynamic> json) {
    return StationServiceItem(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      serviceName: json['service_name'] as String?,
      description: json['description'] as String?,
      isAvailable: json['is_available'] != false,
    );
  }
}
