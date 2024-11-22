/*
import 'package:weatherapp/features/domain/entities/alert_weather.dart';

class AlertWeatherModel extends AlertEntity {
  AlertWeatherModel({
    required super.senderName,
    required super.event,
    required super.description,
    required super.startTime,
    required super.endTime,
  });

  factory AlertWeatherModel.fromJson(Map<String, dynamic> json) {
    return AlertWeatherModel(
      senderName: json['sender_name'],
      event: json['event'],
      startTime: json['start'],
      endTime: json['end'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_name': senderName,
      'event': event,
      'start': startTime,
      'end': endTime,
      'description': description,
    };
  }

  AlertEntity toEntity() {
    return AlertEntity(
      senderName: senderName,
      event: event,
      startTime: startTime,
      endTime: endTime ,
      description: description,
    );
  }
}
*/
