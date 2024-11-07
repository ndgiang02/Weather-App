import 'current_weather.dart';
import 'daily_weather.dart';
import 'hourly_weather.dart';

class WeatherResponseEntity {
  final double lat;
  final double lon;
  final String timezone;
  final int timezoneOffset;
  final CurrentWeatherEntity current;
  final List<HourlyWeatherEntity> hourly;
  final List<DailyWeatherEntity> daily;

  WeatherResponseEntity({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.current,
    required this.hourly,
    required this.daily,
  });
}
