part of 'auto_location_cubit.dart';

class AutoLocationState extends Equatable {
  final LoadStatus status;
  final WeatherResponseEntity? weather;
  final List<LocationSuggestionEntity> suggestions;
  final String errMsg;

   const AutoLocationState({
    this.status = LoadStatus.Init,
     this.weather,
    this.suggestions = const [],
     this.errMsg = '',
  });

  AutoLocationState copyWith({
    LoadStatus? status,
    WeatherResponseEntity? weather,
    List<LocationSuggestionEntity>? suggestions,
    String? errMsg,
  }) {
    return AutoLocationState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      suggestions: suggestions ?? this.suggestions,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  List<Object> get props => [status, suggestions];
}
