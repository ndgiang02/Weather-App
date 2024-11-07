
import '../entities/weather.dart';
import '../repositories/weather_repositories.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<WeatherResponseEntity> execute(double lat, double lon) {
    return repository.getWeatherLocation(lat, lon);
  }
}
