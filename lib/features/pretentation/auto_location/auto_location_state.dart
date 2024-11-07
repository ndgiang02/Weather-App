part of 'auto_location_cubit.dart';

class AutoLocationState extends Equatable {
  final LoadStatus status;
  final List<LocationSuggestionEntity> suggestions;

   AutoLocationState({
    this.status = LoadStatus.Init,
    this.suggestions = const [],
  });

  AutoLocationState copyWith({
    LoadStatus? status,
    List<LocationSuggestionEntity>? suggestions,
  }) {
    return AutoLocationState(
      status: status ?? this.status,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  @override
  List<Object> get props => [status, suggestions];
}
