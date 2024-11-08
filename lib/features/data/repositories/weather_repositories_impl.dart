import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repositories.dart';
import '../data_source/weather_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource weatherDataSource;

  WeatherRepositoryImpl(this.weatherDataSource);

  @override
  Future<WeatherResponseEntity> getWeatherLocation(double lat, double lon) async {
    final result = await weatherDataSource.getWeather(lat, lon);
    return result.toEntity();
  }

}