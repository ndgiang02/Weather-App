// lib/features/weather/data/models/weather_condition_model.dart

import '../../domain/entities/weather_condition.dart';

class WeatherConditionModel extends WeatherConditionEntity {
  WeatherConditionModel({
    required super.id,
    required super.main,
    required super.description,
    required super.icon,
  });

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) {
    return WeatherConditionModel(
      id: json["id"],
      main: json["main"],
      description: json["description"],
      icon: json["icon"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }

  WeatherConditionEntity toEntity() {
    return WeatherConditionEntity(
      id: id,
      main: main,
      description: description,
      icon: icon,
    );
  }
}
