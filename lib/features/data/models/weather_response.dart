import '../../domain/entities/weather.dart';
import 'alert_weather_model.dart';
import 'current_weather_model.dart';
import 'daily_weather_model.dart';
import 'hourly_weather_model.dart';


class WeatherResponseModel extends WeatherResponseEntity {
  WeatherResponseModel({
    required super.lat,
    required super.lon,
    required super.timezone,
    required super.timezoneOffset,
    required super.current,
    required super.hourly,
    required super.daily,
    //required super.alert
  });

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherResponseModel(
      lat: json['lat'],
      lon: json['lon'],
      timezone: json['timezone'],
      timezoneOffset: json['timezone_offset'],
      current: CurrentWeatherModel.fromJson(json['current']),
      //alert: AlertWeatherModel.fromJson(json['alert']),
      hourly: (json['hourly'] as List)
          .map((hour) => HourlyWeatherModel.fromJson(hour))
          .toList(),
      daily: (json['daily'] as List)
          .map((day) => DailyWeatherModel.fromJson(day))
          .toList(),
    );
  }

  WeatherResponseEntity toEntity() {
    return WeatherResponseEntity(
      lat: lat,
      lon: lon,
      timezone: timezone,
      timezoneOffset: timezoneOffset,
      current: (current as CurrentWeatherModel).toEntity(),
    //  alert: (alert as AlertWeatherModel).toEntity(),
      hourly: hourly.map((hour) => (hour as HourlyWeatherModel).toEntity()).toList(),
      daily: daily.map((day) => (day as DailyWeatherModel).toEntity()).toList(),
    );
  }

}
