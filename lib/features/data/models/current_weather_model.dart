import 'weather_condition.dart';

import '../../domain/entities/current_weather.dart';

class CurrentWeatherModel extends CurrentWeatherEntity {
  CurrentWeatherModel({
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
    required super.dt,
    required super.weather,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      dt: json["dt"],
      temp: json["temp"].toDouble(),
      feelsLike: json["feels_like"].toDouble(),
      pressure: json["pressure"],
      humidity: json["humidity"],
      dewPoint: json["dew_point"].toDouble(),
      uvi: json["uvi"].toDouble(),
      clouds: json["clouds"],
      visibility: json["visibility"],
      windSpeed: json["wind_speed"].toDouble(),
      windDeg: json["wind_deg"],
      weather: WeatherConditionModel.fromJson(json["weather"][0]),
    );
  }

  CurrentWeatherEntity toEntity() {
    return CurrentWeatherEntity(
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
      'weather': weather,
    };
  }
}
