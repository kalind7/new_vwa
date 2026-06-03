import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../data/main_shell_mock_data.dart';
import '../../data/wash_station_repository.dart';

class StationSearchProvider extends ChangeNotifier {
  StationSearchProvider({required WashStationRepository stationRepository})
    : _stationRepository = stationRepository;

  final WashStationRepository _stationRepository;

  List<WashStationMock> _stations = const [];
  String? _loadErrorMessage;
  String _query = '';
  bool _showSearchResults = false;
  bool _isDisposed = false;
  WashStationMock? _selectedStation;

  List<WashStationMock> get stations => _stations;
  String? get loadErrorMessage => _loadErrorMessage;
  String get query => _query;
  bool get showSearchResults => _showSearchResults;
  WashStationMock? get selectedStation => _selectedStation;

  LatLng get initialCenter {
    final station = _stations.isNotEmpty
        ? _stations.first
        : nearbyStations.first;
    return LatLng(station.latitude, station.longitude);
  }

  List<WashStationMock> get filteredStations {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    return _stations.where((station) {
      return station.name.toLowerCase().contains(normalizedQuery) ||
          station.location.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  Future<void> loadStations() async {
    final result = await _stationRepository.fetchStations(
      source: StationListSource.all,
      locationLabel: null,
    );
    result.fold(
      (failure) {
        _stations = const [];
        _loadErrorMessage = failure.message;
      },
      (stations) {
        _stations = stations;
        _loadErrorMessage = null;
      },
    );
    _notifyListeners();
  }

  void clearLoadErrorMessage() {
    if (_loadErrorMessage == null) {
      return;
    }
    _loadErrorMessage = null;
    _notifyListeners();
  }

  void updateQuery(String query) {
    _query = query;
    _showSearchResults = true;
    _selectedStation = null;
    _notifyListeners();
  }

  void showSearch() {
    if (_showSearchResults) {
      return;
    }

    _showSearchResults = true;
    _notifyListeners();
  }

  void selectStation(WashStationMock station) {
    _selectedStation = station;
    _query = station.name;
    _showSearchResults = false;
    _notifyListeners();
  }

  void clearMapSelection() {
    _selectedStation = null;
    _showSearchResults = false;
    _notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _notifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}
