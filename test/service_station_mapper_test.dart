import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/features/main/data/models/service_station_mapper.dart';

void main() {
  group('ServiceStationMapper', () {
    test('maps nearest stations response', () {
      final stations = ServiceStationMapper.fromNearestResponse({
        'success': true,
        'data': {
          'stations': [
            {
              'name': 'Hero Honda Washing Station',
              'address': 'Lazimpat, Kathmandu',
              'latitude': '27.72150000',
              'longitude': '85.32010000',
              'capacity': 6,
              'average_rating': '4.5',
              'total_reviews': 12,
              'user_distance': 0.61,
              'products': [
                {'price': '200.00'},
              ],
            },
          ],
        },
      });

      expect(stations, hasLength(1));
      expect(stations.first.name, 'Hero Honda Washing Station');
      expect(stations.first.location, 'Lazimpat, Kathmandu');
      expect(stations.first.price, 'Rs. 200');
      expect(stations.first.distance, contains('away'));
    });

    test('maps list response', () {
      final stations = ServiceStationMapper.fromListResponse({
        'success': true,
        'data': [
          {
            'name': 'New Service Station',
            'address': 'Sinamangal, Kathmandu',
            'latitude': '27.69910000',
            'longitude': '85.35110000',
            'capacity': 10,
            'average_rating': '0.00',
            'total_reviews': 0,
            'products': [],
          },
        ],
      });

      expect(stations, hasLength(1));
      expect(stations.first.name, 'New Service Station');
      expect(stations.first.price, 'Price on request');
    });
    test('maps suggest response with suggested_stations array', () {
      final stations = ServiceStationMapper.fromSuggestResponse({
        'success': true,
        'data': {
          'suggested_stations': [
            {
              'name': 'Hero Honda Washing Station',
              'address': 'Lazimpat, Kathmandu',
              'latitude': '27.72150000',
              'longitude': '85.32010000',
              'capacity': 6,
              'average_rating': '4.0',
              'total_reviews': 3,
              'distance': 0.61,
              'products': [
                {'price': '200.00'},
              ],
            },
          ],
          'total_suggestions': 1,
        },
      });

      expect(stations, hasLength(1));
      expect(stations.first.name, 'Hero Honda Washing Station');
      expect(stations.first.price, 'Rs. 200');
    });

    test('returns empty list when suggest response fails', () {
      final stations = ServiceStationMapper.fromSuggestResponse({
        'success': false,
        'message': 'Service station not found',
      });

      expect(stations, isEmpty);
    });
  });
}
