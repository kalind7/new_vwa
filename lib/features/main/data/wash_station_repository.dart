import 'main_shell_mock_data.dart';

enum StationListSource { all, nearby, lessDistance }

abstract class WashStationRepository {
  Future<List<WashStationMock>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
  });
}

class MockWashStationRepository implements WashStationRepository {
  const MockWashStationRepository();

  @override
  Future<List<WashStationMock>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
  }) async {
    return nearbyStations;
  }
}
