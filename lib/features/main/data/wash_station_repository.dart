import 'main_shell_mock_data.dart';

enum StationListSource { all, nearby, lessDistance }

abstract class WashStationRepository {
  Future<List<WashStationMock>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
    String? locationLabel,
  });

  Future<WashStationMock?> fetchStationDetail(String stationId);
}

class MockWashStationRepository implements WashStationRepository {
  const MockWashStationRepository();

  @override
  Future<List<WashStationMock>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    return nearbyStations;
  }

  @override
  Future<WashStationMock?> fetchStationDetail(String stationId) async {
    for (final station in nearbyStations) {
      if (station.id == stationId) {
        return station;
      }
    }
    return nearbyStations.isNotEmpty ? nearbyStations.first : null;
  }
}
