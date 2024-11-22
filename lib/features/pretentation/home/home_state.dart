import 'package:equatable/equatable.dart';

import '../../../../core/utils/load_status.dart';
import '../../domain/entities/auto_location.dart';
import '../../domain/entities/weather.dart';

class HomeState extends Equatable {
  final LoadStatus status;
  final WeatherResponseEntity? weather;
  final List<WeatherResponseEntity> weatherList;
  final bool isSearching;
  final List<LocationSuggestionEntity> suggestions;
  final String? cityName;
  final String errMsg;

  const HomeState({
    this.status = LoadStatus.Init,
    this.weather,
    this.weatherList = const [],
    this.isSearching = false,
    this.cityName,
    this.suggestions = const [],
    this.errMsg = '',
  });

  HomeState copyWith({
    LoadStatus? status,
    WeatherResponseEntity? weather,
    List<WeatherResponseEntity>? weatherList,
    bool? isSearching,
    String? cityName,
    List<LocationSuggestionEntity>? suggestions,
    String? errMsg,
  }) {
    return HomeState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      weatherList: weatherList ?? this.weatherList,
      isSearching: isSearching ?? this.isSearching,
      cityName: cityName ?? this.cityName,
      suggestions: suggestions ?? this.suggestions,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  List<Object?> get props => [status, weather, weatherList, suggestions];
}
