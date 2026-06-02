import 'package:flutter/foundation.dart';

import '../../data/main_shell_mock_data.dart';
import '../../data/saved_stations_repository.dart';

class SavedStationsProvider extends ChangeNotifier {
  SavedStationsProvider(this._repository) {
    loadSavedStations();
  }

  final SavedStationsRepository _repository;

  List<WashStationMock> _stations = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<WashStationMock> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSavedStations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchSavedStations();

    result.fold((failure) {
      _errorMessage = failure.message;
      _stations = const [];
    }, (stations) => _stations = stations);

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isSaved(String stationId) => _repository.isSaved(stationId);

  Future<bool> toggleStation(WashStationMock station) async {
    final isSaved = await _repository.toggleSaved(station);
    await loadSavedStations();
    return isSaved;
  }
}
