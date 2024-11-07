import 'weather_condition.dart';

import '../../domain/entities/daily_weather.dart';

class DailyWeatherModel extends DailyWeatherEntity {
  DailyWeatherModel({
    required super.dt,
    required super.sunrise,
    required super.sunset,
    required super.moonrise,
    required super.moonset,
    required super.moonPhase,
    required super.summary,
    required super.temp,
    required super.feelsLike,
    required super.pressure,
    required super.humidity,
    required super.dewPoint,
    required super.windSpeed,
    required super.windDeg,
    required super.windGust,
    required super.weather,
    required super.clouds,
    required super.pop,
    required super.rain,
    required super.uvi,
  });

  factory DailyWeatherModel.fromJson(Map<String, dynamic> json) {
    return DailyWeatherModel(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      moonPhase: json['moon_phase'].toDouble(),
      summary: json['summary'],
      temp: Temp(
        day: json['temp']['day'].toDouble(),
        min: json['temp']['min'].toDouble(),
        max: json['temp']['max'].toDouble(),
        night: json['temp']['night'].toDouble(),
        eve: json['temp']['eve'].toDouble(),
        morn: json['temp']['morn'].toDouble(),
      ),
      feelsLike: Temp(
        day: json['feels_like']['day'].toDouble(),
        night: json['feels_like']['night'].toDouble(),
        eve: json['feels_like']['eve'].toDouble(),
        morn: json['feels_like']['morn'].toDouble(),
        max: 0.0,
        min: 0.0,
      ),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'].toDouble(),
      windSpeed: json['wind_speed'].toDouble(),
      windDeg: json['wind_deg'],
      windGust: json['wind_gust'].toDouble(),
      weather: WeatherConditionModel.fromJson(json["weather"][0]),
      clouds: json['clouds'],
      pop: json['pop'].toDouble(),
      rain: json['rain'] != null ? json['rain'].toDouble() : 0.0,
      uvi: json['uvi'].toDouble(),
    );
  }

  DailyWeatherEntity toEntity() {
    return DailyWeatherEntity(
      temp: temp,
      feelsLike: feelsLike,
      pressure: pressure,
      humidity: humidity,
      dewPoint: dewPoint,
      uvi: uvi,
      clouds: clouds,
      windSpeed: windSpeed,
      windDeg: windDeg,
      dt: dt,
      weather: weather,
      windGust: windGust,
      pop: pop,
      sunrise: sunrise,
      sunset: sunset,
      moonrise: moonrise,
      moonset: moonset,
      moonPhase: moonPhase,
      summary: summary,
      rain: rain,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'sunrise': sunrise,
      'sunset': sunset,
      'moonrise': moonrise,
      'moonset': moonset,
      'moon_phase': moonPhase,
      'summary': summary,
      'temp': {
        'day': temp.day,
        'min': temp.min,
        'max': temp.max,
        'night': temp.night,
        'eve': temp.eve,
        'morn': temp.morn,
      },
      'feels_like': {
        'day': feelsLike.day,
        'night': feelsLike.night,
        'eve': feelsLike.eve,
        'morn': feelsLike.morn,
      },
      'pressure': pressure,
      'humidity': humidity,
      'dew_point': dewPoint,
      'wind_speed': windSpeed,
      'wind_deg': windDeg,
      'wind_gust': windGust,
      'weather': weather,
      'clouds': clouds,
      'pop': pop,
      'rain': rain,
      'uvi': uvi,
    };
  }
}
