import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/main_shell_mock_data.dart';
import '../../data/wash_station_repository.dart';

enum HomeStationTab { nearby, lessDistance }

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
  HomeStationTab _selectedStationTab = HomeStationTab.nearby;
  List<WashStationMock> _stations = const [];

  String get currentLocation => _currentLocation;
  bool get isResolvingLocation => _isResolvingLocation;
  bool get shouldShowSettingsPrompt => _shouldShowSettingsPrompt;
  bool get isLoadingStations => _isLoadingStations;
  HomeStationTab get selectedStationTab => _selectedStationTab;

  List<WashStationMock> get visibleStations {
    final stations = List<WashStationMock>.of(_stations);
    if (_selectedStationTab == HomeStationTab.lessDistance) {
      stations.sort(
        (first, second) => _distanceValue(
          first.distance,
        ).compareTo(_distanceValue(second.distance)),
      );
    }
    return stations;
  }

  Future<void> loadStations() async {
    _isLoadingStations = true;
    _notifyListeners();

    _stations = await _stationRepository.fetchNearbyStations();
    _isLoadingStations = false;
    _notifyListeners();
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
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 12),
        ),
      );
      final locationLabel = await _locationLabelFor(position);

      _setLocationState(label: locationLabel, isResolving: false);
    } catch (_) {
      _setLocationState(label: 'Current area unavailable', isResolving: false);
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

  void setStationTab(HomeStationTab tab) {
    if (_selectedStationTab == tab) {
      return;
    }

    _selectedStationTab = tab;
    _notifyListeners();
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

  double _distanceValue(String distance) {
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(distance);
    return double.tryParse(match?.group(0) ?? '') ?? double.maxFinite;
  }
}
