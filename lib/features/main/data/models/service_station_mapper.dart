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
      if (data['stations'] is List) {
        return fromNearestResponse(json);
      }
      return [_fromStationJson(data)];
    }

    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(_fromStationJson).toList();
    }

    return const [];
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
    final price = _resolvePrice(json['products']);

    return WashStationMock(
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
    );
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
