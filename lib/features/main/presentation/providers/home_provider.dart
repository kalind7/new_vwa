import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/main_shell_mock_data.dart';
import '../../data/wash_station_repository.dart';

enum HomeStationTab { all, nearby, lessDistance }

class HomeProvider extends ChangeNotifier {
  HomeProvider({required WashStationRepository stationRepository})
    : _stationRepository = stationRepository;

  final WashStationRepository _stationRepository;

  String _currentLocation = 'Finding your location...';
  bool _isResolvingLocation = true;
  bool _isRequestingLocation = false;
  bool _shouldShowSettingsPrompt = false;
  bool _isLoadingStations = true;
  bool _isDisposed = false;
  HomeStationTab _selectedStationTab = HomeStationTab.all;
  List<WashStationMock> _stations = const [];
  double? _latitude;
  double? _longitude;

  String get currentLocation => _currentLocation;
  bool get isResolvingLocation => _isResolvingLocation;
  bool get shouldShowSettingsPrompt => _shouldShowSettingsPrompt;
  bool get isLoadingStations => _isLoadingStations;
  HomeStationTab get selectedStationTab => _selectedStationTab;
  List<WashStationMock> get visibleStations => _stations;

  String get emptyStateMessage {
    return switch (_selectedStationTab) {
      HomeStationTab.all => 'No service stations available right now.',
      HomeStationTab.nearby =>
        'No nearby washing stations found. Try enabling location access.',
      HomeStationTab.lessDistance =>
        'No suggested stations found for your location.',
    };
  }

  Future<void> loadStations() async {
    _isLoadingStations = true;
    _notifyListeners();

    try {
      _stations = await _stationRepository.fetchStations(
        source: _sourceForTab(_selectedStationTab),
        latitude: _latitude,
        longitude: _longitude,
        locationLabel: _currentLocation,
      );
    } finally {
      _isLoadingStations = false;
      _notifyListeners();
    }
  }

  Future<void> resolveCurrentLocation({bool retryAfterDeny = false}) async {
    if (_isRequestingLocation) {
      return;
    }

    _isRequestingLocation = true;
    _setLocationState(
      label: 'Finding your location...',
      isResolving: true,
      showSettingsPrompt: false,
    );

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setLocationState(
          label: 'Turn on location services',
          isResolving: false,
        );
        await loadStations();
        await Geolocator.openLocationSettings();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _setLocationState(
          label: 'Location permission required',
          isResolving: false,
        );
        _isRequestingLocation = false;
        await loadStations();
        if (retryAfterDeny) {
          await Future<void>.delayed(const Duration(milliseconds: 450));
          await resolveCurrentLocation();
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _setLocationState(
          label: 'Enable location from settings',
          isResolving: false,
          showSettingsPrompt: true,
        );
        await loadStations();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 12),
        ),
      );
      _latitude = position.latitude;
      _longitude = position.longitude;
      final locationLabel = await _locationLabelFor(position);

      _setLocationState(label: locationLabel, isResolving: false);
      await loadStations();
    } catch (_) {
      _setLocationState(label: 'Current area unavailable', isResolving: false);
      await loadStations();
    } finally {
      _isRequestingLocation = false;
    }
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  void clearSettingsPrompt() {
    if (!_shouldShowSettingsPrompt) {
      return;
    }

    _shouldShowSettingsPrompt = false;
    _notifyListeners();
  }

  Future<void> setStationTab(HomeStationTab tab) async {
    if (_selectedStationTab == tab) {
      return;
    }

    _selectedStationTab = tab;
    _notifyListeners();
    await loadStations();
  }

  StationListSource _sourceForTab(HomeStationTab tab) {
    return switch (tab) {
      HomeStationTab.all => StationListSource.all,
      HomeStationTab.nearby => StationListSource.nearby,
      HomeStationTab.lessDistance => StationListSource.lessDistance,
    };
  }

  void _setLocationState({
    required String label,
    required bool isResolving,
    bool showSettingsPrompt = false,
  }) {
    _currentLocation = label;
    _isResolvingLocation = isResolving;
    _shouldShowSettingsPrompt = showSettingsPrompt;
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

  Future<String> _locationLabelFor(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      return 'Current area detected';
    }

    final place = placemarks.first;
    final area = _firstNonEmpty([
      place.subLocality,
      place.locality,
      place.name,
      place.street,
    ]);
    final city = _firstNonEmpty([
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
    ]);

    if (area == null && city == null) {
      return 'Current area detected';
    }
    if (area == null) {
      return city!;
    }
    if (city == null || area.toLowerCase() == city.toLowerCase()) {
      return area;
    }

    return '$area, $city';
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return null;
  }
}
