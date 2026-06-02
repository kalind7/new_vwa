import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Stores only station IDs locally. Station payloads always come from the API.
class SavedStationIdsStorage {
  const SavedStationIdsStorage(this._prefs);

  static const _storageKey = 'saved_station_ids_v1';
  static const _legacyStorageKey = 'saved_service_stations_v1';

  final SharedPreferences _prefs;

  Future<List<String>> loadIds() async {
    await _migrateLegacySnapshotsIfNeeded();

    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }
      return decoded.map((id) => '$id').where((id) => id.isNotEmpty).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> isSaved(String stationId) async {
    final ids = await loadIds();
    return ids.contains(stationId);
  }

  Future<List<String>> addId(String stationId) async {
    final ids = await loadIds();
    if (ids.contains(stationId)) {
      return ids;
    }
    final updated = [...ids, stationId];
    await _persist(updated);
    return updated;
  }

  Future<List<String>> removeId(String stationId) async {
    final updated = (await loadIds()).where((id) => id != stationId).toList();
    await _persist(updated);
    return updated;
  }

  Future<List<String>> toggleId(String stationId) async {
    if (await isSaved(stationId)) {
      return removeId(stationId);
    }
    return addId(stationId);
  }

  Future<void> _persist(List<String> ids) async {
    await _prefs.setString(_storageKey, jsonEncode(ids));
  }

  /// Migrates full-station JSON snapshots from the pre-API saved flow.
  Future<void> _migrateLegacySnapshotsIfNeeded() async {
    final legacyRaw = _prefs.getString(_legacyStorageKey);
    if (legacyRaw == null || legacyRaw.isEmpty) {
      return;
    }

    final migratedIds = <String>[];
    try {
      final decoded = jsonDecode(legacyRaw);
      if (decoded is List) {
        for (final item in decoded) {
          if (item is Map && item['id'] != null) {
            final id = '${item['id']}';
            if (id.isNotEmpty && !migratedIds.contains(id)) {
              migratedIds.add(id);
            }
          }
        }
      }
    } catch (_) {}

    final existing = _prefs.getString(_storageKey);
    if (migratedIds.isNotEmpty && (existing == null || existing.isEmpty)) {
      await _persist(migratedIds);
    }

    await _prefs.remove(_legacyStorageKey);
  }
}
