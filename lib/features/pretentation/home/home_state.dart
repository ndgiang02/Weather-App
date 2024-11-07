import 'package:equatable/equatable.dart';

import '../../../../core/utils/load_status.dart';
import '../../domain/entities/weather.dart';


class HomeState extends Equatable {
  final LoadStatus status;
  final WeatherResponseEntity? weather;
  final List<WeatherResponseEntity> weatherList;

  const HomeState({this.status = LoadStatus.Init,this.weather, this.weatherList = const []});

  HomeState copyWith({LoadStatus? status,WeatherResponseEntity? weather, List<WeatherResponseEntity>? weatherList}) {
    return HomeState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      weatherList: weatherList ?? this.weatherList,
    );
  }

  @override
  List<Object?> get props => [status,weather, weatherList];
}
