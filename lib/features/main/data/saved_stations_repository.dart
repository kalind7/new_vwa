import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import 'main_shell_mock_data.dart';
import 'saved_station_ids_storage.dart';
import 'wash_station_repository.dart';

/// Resolves saved station IDs to live API station data (no mock snapshots).
class SavedStationsRepository {
  const SavedStationsRepository({
    required SavedStationIdsStorage storage,
    required WashStationRepository stationRepository,
  }) : _storage = storage,
       _stationRepository = stationRepository;

  final SavedStationIdsStorage _storage;
  final WashStationRepository _stationRepository;

  Future<List<String>> loadSavedIds() => _storage.loadIds();

  Future<bool> isSaved(String stationId) => _storage.isSaved(stationId);

  Future<bool> toggleSaved(WashStationMock station) async {
    final updated = await _storage.toggleId(station.id);
    return updated.contains(station.id);
  }

  Future<Either<Failure, List<WashStationMock>>> fetchSavedStations() async {
    final ids = await _storage.loadIds();
    if (ids.isEmpty) {
      return right(const []);
    }

    final stations = <WashStationMock>[];
    for (final id in ids) {
      final detailResult = await _stationRepository.fetchStationDetail(id);
      detailResult.fold((_) {}, (detail) {
        if (detail != null) {
          stations.add(detail);
        }
      });
    }

    return right(stations);
  }
}
