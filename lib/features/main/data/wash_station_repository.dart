import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import 'main_shell_mock_data.dart';

enum StationListSource { all, nearby, lessDistance }

abstract class WashStationRepository {
  Future<Either<Failure, List<WashStationMock>>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
    String? locationLabel,
  });

  Future<Either<Failure, WashStationMock?>> fetchStationDetail(
    String stationId,
  );
}

class MockWashStationRepository implements WashStationRepository {
  const MockWashStationRepository();

  @override
  Future<Either<Failure, List<WashStationMock>>> fetchStations({
    required StationListSource source,
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    return right(nearbyStations);
  }

  @override
  Future<Either<Failure, WashStationMock?>> fetchStationDetail(
    String stationId,
  ) async {
    for (final station in nearbyStations) {
      if (station.id == stationId) {
        return right(station);
      }
    }
    return right(nearbyStations.isNotEmpty ? nearbyStations.first : null);
  }
}
