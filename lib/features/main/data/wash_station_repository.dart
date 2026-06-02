import 'main_shell_mock_data.dart';

abstract class WashStationRepository {
  Future<List<WashStationMock>> fetchNearbyStations();
}

class MockWashStationRepository implements WashStationRepository {
  const MockWashStationRepository();

  @override
  Future<List<WashStationMock>> fetchNearbyStations() async {
    return nearbyStations;
  }
}
