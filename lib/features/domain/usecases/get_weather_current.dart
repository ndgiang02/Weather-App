
import 'package:weatherapp/features/domain/entities/weather.dart';

import '../../../core/location/location_service.dart';
import '../repositories/weather_repositories.dart';

class GetWeatherByCurrentLocation {
  final WeatherRepository repository;
  final LocationService locationService;

  GetWeatherByCurrentLocation(this.repository, this.locationService);

  Future<WeatherResponseEntity> execute() async {
    final location = await locationService.getCurrentLocation();
    return repository.getWeatherLocation(location.latitude!, location.longitude!);
  }
}
