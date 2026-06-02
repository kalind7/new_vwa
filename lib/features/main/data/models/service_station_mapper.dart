import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../data/main_shell_mock_data.dart';

class ServiceStationMapper {
  const ServiceStationMapper._();

  static List<WashStationMock> fromNearestResponse(Map<String, dynamic> json) {
    if (json['success'] == false) {
      return const [];
    }

    final payload = json['data'];
    if (payload is! Map<String, dynamic>) {
      return const [];
    }

    final stations = payload['stations'];
    if (stations is! List) {
      return const [];
    }

    return stations
        .whereType<Map<String, dynamic>>()
        .map(_fromStationJson)
        .toList();
  }

  static List<WashStationMock> fromListResponse(Map<String, dynamic> json) {
    if (json['success'] == false) {
      return const [];
    }

    final stations = json['data'];
    if (stations is! List) {
      return const [];
    }

    return stations
        .whereType<Map<String, dynamic>>()
        .map(_fromStationJson)
        .toList();
  }

  static List<WashStationMock> fromSuggestResponse(Map<String, dynamic> json) {
    if (json['success'] == false) {
      return const [];
    }

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final suggestedStations = data['suggested_stations'];
      if (suggestedStations is List) {
        return suggestedStations
            .whereType<Map<String, dynamic>>()
            .map(_fromStationJson)
            .toList();
      }

      if (data['stations'] is List) {
        return fromNearestResponse(json);
      }

      if (data.containsKey('name')) {
        return [_fromStationJson(data)];
      }
    }

    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(_fromStationJson)
          .toList();
    }

    return const [];
  }

  static WashStationMock fromDetailResponse(Map<String, dynamic> json) {
    if (json['success'] == false) {
      throw const FormatException('Station detail failed');
    }

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return _fromStationJson(data);
    }

    return _fromStationJson(json);
  }

  static WashStationMock _fromStationJson(Map<String, dynamic> json) {
    final latitude = double.tryParse('${json['latitude']}') ?? 0;
    final longitude = double.tryParse('${json['longitude']}') ?? 0;
    final capacity = json['capacity'] is int
        ? json['capacity'] as int
        : int.tryParse('${json['capacity']}') ?? 0;
    final availableSlots = capacity > 0 ? capacity : 5;
    final distanceValue = json['user_distance'] ?? json['distance'];
    final distance = distanceValue == null
        ? 'Nearby'
        : '${_formatDistance(distanceValue)} away';
    final rating = '${json['average_rating'] ?? '0.0'}';
    final reviewCount = json['total_reviews'] is int
        ? json['total_reviews'] as int
        : int.tryParse('${json['total_reviews']}') ?? 0;
    final products = _parseProducts(json['products']);
    final price = _resolvePrice(json['products']);
    final services = products.map((product) => product.name).toList();
    final operatingHours = _parseOperatingHours(json);

    return WashStationMock(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? 'Service Station'}',
      location: '${json['address'] ?? 'Address unavailable'}',
      rating: rating,
      distance: distance,
      price: price,
      slots: '$availableSlots slots available',
      slotsColor: availableSlots >= 10
          ? AppColors.success50
          : const Color(0xFFFFF7ED),
      latitude: latitude,
      longitude: longitude,
      reviewCount: reviewCount,
      availableSlotsCount: availableSlots,
      services: services,
      products: products,
      operatingHours: operatingHours,
    );
  }

  static List<String> _parseOperatingHours(Map<String, dynamic> json) {
    final hours = <String>[];

    final operatingHours = json['operating_hours'];
    if (operatingHours is List) {
      for (final entry in operatingHours) {
        if (entry is Map<String, dynamic>) {
          final day = entry['day'] ?? entry['weekday'];
          final open = entry['open'] ?? entry['opening_time'] ?? entry['from'];
          final close = entry['close'] ?? entry['closing_time'] ?? entry['to'];
          if (day != null && open != null && close != null) {
            hours.add('$day: $open – $close');
          } else if (open != null && close != null) {
            hours.add('$open – $close');
          }
        } else if (entry != null) {
          hours.add('$entry');
        }
      }
    }

    if (hours.isNotEmpty) {
      return hours;
    }

    final opening =
        json['opening_time'] ?? json['open_time'] ?? json['opens_at'];
    final closing =
        json['closing_time'] ?? json['close_time'] ?? json['closes_at'];
    if (opening != null && closing != null) {
      return ['$opening – $closing'];
    }

    final businessHours = json['business_hours'];
    if (businessHours is String && businessHours.trim().isNotEmpty) {
      return [businessHours.trim()];
    }

    if (json['is_open'] == false) {
      return const ['Currently closed'];
    }

    return const [];
  }

  static List<StationProductMock> _parseProducts(Object? products) {
    if (products is! List) {
      return const [];
    }

    return products
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => StationProductMock(
            id: json['id'] is int
                ? json['id'] as int
                : int.tryParse('${json['id']}') ?? 0,
            name: '${json['name'] ?? json['title'] ?? 'Service'}',
            price: json['price']?.toString(),
          ),
        )
        .where((product) => product.id > 0)
        .toList();
  }

  static String _resolvePrice(Object? products) {
    if (products is! List || products.isEmpty) {
      return 'Price on request';
    }

    for (final product in products) {
      if (product is Map<String, dynamic>) {
        final price = product['price'];
        if (price != null && '$price'.isNotEmpty) {
          return 'Rs. ${_trimDecimal('$price')}';
        }
      }
    }

    return 'Price on request';
  }

  static String _formatDistance(Object value) {
    final parsed = double.tryParse('$value');
    if (parsed == null) {
      return '$value km';
    }
    if (parsed < 1) {
      return '${(parsed * 1000).round()} m';
    }
    return '${parsed.toStringAsFixed(parsed >= 10 ? 0 : 1)} km';
  }

  static String _trimDecimal(String value) {
    if (value.endsWith('.00')) {
      return value.substring(0, value.length - 3);
    }
    return value;
  }
}
