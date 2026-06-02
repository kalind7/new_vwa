import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vwa/features/main/data/main_shell_mock_data.dart';
import 'package:vwa/features/main/data/saved_station_ids_storage.dart';
import 'package:vwa/features/main/data/saved_stations_repository.dart';
import 'package:vwa/features/main/data/wash_station_repository.dart';

class _FakeStationRepository implements WashStationRepository {
  _FakeStationRepository(this._details);

  final Map<String, WashStationMock> _details;

  @override
  Future<WashStationMock?> fetchStationDetail(String stationId) async {
    return _details[stationId];
  }

  @override
  Future<List<WashStationMock>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    return _details.values.toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SavedStationsRepository', () {
    test('resolves saved ids via station detail API', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = SavedStationIdsStorage(prefs);
      await storage.addId('2');

      final detail = nearbyStations.first.copyWith(id: '2');
      final repository = SavedStationsRepository(
        storage: storage,
        stationRepository: _FakeStationRepository({'2': detail}),
      );

      final result = await repository.fetchSavedStations();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected success'), (stations) {
        expect(stations, hasLength(1));
        expect(stations.first.id, '2');
      });
    });

    test('migrates legacy saved JSON snapshots to ids', () async {
      SharedPreferences.setMockInitialValues({
        'saved_service_stations_v1':
            '[{"id":"2","name":"Legacy Station","location":"KTM"}]',
      });
      final prefs = await SharedPreferences.getInstance();
      final storage = SavedStationIdsStorage(prefs);

      final ids = await storage.loadIds();

      expect(ids, ['2']);
      expect(prefs.getString('saved_service_stations_v1'), isNull);
    });
  });
}
