import 'package:flutter/foundation.dart';

import '../../data/main_shell_mock_data.dart';
import '../../data/saved_stations_storage.dart';

class SavedStationsProvider extends ChangeNotifier {
  SavedStationsProvider(this._storage) {
    loadSavedStations();
  }

  final SavedStationsStorage _storage;

  List<WashStationMock> _stations = const [];
  bool _isLoading = false;

  List<WashStationMock> get stations => _stations;
  bool get isLoading => _isLoading;

  Future<void> loadSavedStations() async {
    _isLoading = true;
    notifyListeners();

    _stations = await _storage.loadStations();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isSaved(String stationId) => _storage.isSaved(stationId);

  Future<bool> toggleStation(WashStationMock station) async {
    _stations = await _storage.toggleStation(station);
    notifyListeners();
    return _stations.any((item) => item.id == station.id);
  }

  Future<void> removeStation(String stationId) async {
    _stations = await _storage.removeStation(stationId);
    notifyListeners();
  }
}
