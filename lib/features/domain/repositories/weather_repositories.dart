import '../entities/weather.dart';

abstract class WeatherRepository {

  Future<WeatherResponseEntity> getWeatherLocation(double lat, double lon);

}