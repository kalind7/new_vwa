import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../data/main_shell_mock_data.dart';
import 'service_station_api_models.dart';

/// Maps live API JSON → presentation [WashStationMock] for existing UI widgets.
/// When [AppConfig.useMockData] is true, UI uses [nearbyStations] instead.
class ServiceStationMapper {
  const ServiceStationMapper._();

  static const _weekdays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

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
        .map((item) => toPresentation(ServiceStation.fromJson(item)))
        .toList();
  }

  static List<WashStationMock> fromListResponse(Map<String, dynamic> json) {
    return ServiceStationListResponse.fromJson(
      json,
    ).data.map(toPresentation).toList();
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
            .map((item) => toPresentation(ServiceStation.fromJson(item)))
            .toList();
      }

      if (data['stations'] is List) {
        return fromNearestResponse(json);
      }

      if (data.containsKey('name')) {
        return [toPresentation(ServiceStation.fromJson(data))];
      }
    }

    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => toPresentation(ServiceStation.fromJson(item)))
          .toList();
    }

    return const [];
  }

  static WashStationMock fromDetailResponse(Map<String, dynamic> json) {
    return toPresentation(ServiceStationDetailResponse.fromJson(json).data);
  }

  static WashStationMock toPresentation(ServiceStation station) {
    final availableSlots = station.capacity != null && station.capacity! > 0
        ? station.capacity!
        : 5;
    final distance = station.userDistance == null
        ? 'Nearby'
        : '${_formatDistance(station.userDistance!)} away';

    final products = station.products
        .map(
          (product) => StationProductMock(
            id: product.id,
            name: product.name,
            price: product.price,
          ),
        )
        .toList();

    var serviceNames = station.services
        .where((service) => service.displayName.isNotEmpty)
        .map((service) => service.displayName)
        .toList();

    if (serviceNames.isEmpty) {
      serviceNames = products.map((product) => product.name).toList();
    }

    return WashStationMock(
      id: '${station.id}',
      name: station.name,
      location: station.address.isEmpty
          ? 'Address unavailable'
          : station.address,
      rating: station.averageRating ?? '0.0',
      distance: distance,
      price: _resolvePrice(station.products),
      slots: '$availableSlots slots available',
      slotsColor: availableSlots >= 10
          ? AppColors.success50
          : const Color(0xFFFFF7ED),
      latitude: station.latitude,
      longitude: station.longitude,
      reviewCount: station.totalReviews ?? 0,
      availableSlotsCount: availableSlots,
      services: serviceNames,
      products: products,
      operatingHours: _formatOperatingHours(station.operatingHours),
    );
  }

  static List<String> _formatOperatingHours(List<StationOperatingHour> hours) {
    if (hours.isEmpty) {
      return const [];
    }

    return hours.map((hour) {
      final dayLabel = hour.dayOfWeek >= 0 && hour.dayOfWeek < _weekdays.length
          ? _weekdays[hour.dayOfWeek]
          : 'Day ${hour.dayOfWeek}';
      if (hour.isClosed) {
        return '$dayLabel: Closed';
      }
      final open = _formatTime(hour.openTime);
      final close = _formatTime(hour.closeTime);
      if (open.isEmpty || close.isEmpty) {
        return '$dayLabel: Hours not set';
      }
      return '$dayLabel: $open – $close';
    }).toList();
  }

  static String _formatTime(String? raw) {
    if (raw == null || raw.isEmpty) {
      return '';
    }
    final parts = raw.split(':');
    if (parts.length < 2) {
      return raw;
    }
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }

  static String _resolvePrice(List<StationProduct> products) {
    if (products.isEmpty) {
      return 'Price on request';
    }

    for (final product in products) {
      final price = product.price;
      if (price != null && price.isNotEmpty) {
        return 'Rs. ${_trimDecimal(price)}';
      }
    }

    return 'Price on request';
  }

  static String _formatDistance(double value) {
    if (value < 1) {
      return '${(value * 1000).round()} m';
    }
    return '${value.toStringAsFixed(value >= 10 ? 0 : 1)} km';
  }

  static String _trimDecimal(String value) {
    if (value.endsWith('.00')) {
      return value.substring(0, value.length - 3);
    }
    return value;
  }
}
