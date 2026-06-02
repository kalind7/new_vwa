import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'main_shell_mock_data.dart';

/// Persists bookmarked stations locally until a backend favorites API exists.
class SavedStationsStorage {
  const SavedStationsStorage(this._prefs);

  static const _storageKey = 'saved_service_stations_v1';

  final SharedPreferences _prefs;

  Future<List<WashStationMock>> loadStations() async {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(WashStationMock.fromJson)
          .where((station) => station.id.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> isSaved(String stationId) async {
    final stations = await loadStations();
    return stations.any((station) => station.id == stationId);
  }

  Future<List<WashStationMock>> saveStation(WashStationMock station) async {
    final stations = await loadStations();
    if (stations.any((item) => item.id == station.id)) {
      return stations;
    }

    final updated = [...stations, station];
    await _persist(updated);
    return updated;
  }

  Future<List<WashStationMock>> removeStation(String stationId) async {
    final updated = (await loadStations())
        .where((station) => station.id != stationId)
        .toList();
    await _persist(updated);
    return updated;
  }

  Future<List<WashStationMock>> toggleStation(WashStationMock station) async {
    if (await isSaved(station.id)) {
      return removeStation(station.id);
    }
    return saveStation(station);
  }

  Future<void> _persist(List<WashStationMock> stations) async {
    final encoded = jsonEncode(
      stations.map((station) => station.toJson()).toList(),
    );
    await _prefs.setString(_storageKey, encoded);
  }
}
