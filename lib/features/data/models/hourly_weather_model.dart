import 'weather_condition.dart';

import '../../domain/entities/hourly_weather.dart';

class HourlyWeatherModel extends HourlyWeatherEntity {
  HourlyWeatherModel({
    required super.dt,
    required super.temp,
    required super.feelsLike,
    required super.pressure,
    required super.humidity,
    required super.dewPoint,
    required super.uvi,
    required super.clouds,
    required super.visibility,
    required super.windSpeed,
    required super.windDeg,
    required super.windGust,
    required super.weather,
    required super.pop,
    super.rain,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      dt: json['dt'],
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'].toDouble(),
      uvi: json['uvi'].toDouble(),
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: json['wind_speed'].toDouble(),
      windDeg: json['wind_deg'],
      windGust: json['wind_gust'].toDouble(),
      weather: WeatherConditionModel.fromJson(json["weather"][0]),
      pop: json['pop'].toDouble(),
      rain: json['rain'] != null ? json['rain']['1h']?.toDouble() : null,
    );
  }

  HourlyWeatherEntity toEntity() {
    return HourlyWeatherEntity(
      temp: temp,
      feelsLike: feelsLike,
      pressure: pressure,
      humidity: humidity,
      dewPoint: dewPoint,
      uvi: uvi,
      clouds: clouds,
      visibility: visibility,
      windSpeed: windSpeed,
      windDeg: windDeg,
      dt: dt,
      weather: weather,
      windGust: windGust,
      pop: pop,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'temp': temp,
      'feels_like': feelsLike,
      'pressure': pressure,
      'humidity': humidity,
      'dew_point': dewPoint,
      'uvi': uvi,
      'clouds': clouds,
      'visibility': visibility,
      'wind_speed': windSpeed,
      'wind_deg': windDeg,
      'wind_gust': windGust,
      'weather': weather,
      'pop': pop,
      'rain': rain != null ? {'1h': rain} : null,
    };
  }
}
