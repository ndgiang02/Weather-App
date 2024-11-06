import 'package:equatable/equatable.dart';

import '../../domain/entities/auto_location.dart';

abstract class HomeWeatherState extends Equatable {
  const HomeWeatherState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeWeatherState {}

class HomeLoading extends HomeWeatherState {}

class HomeLoaded extends HomeWeatherState {

  final List<LocationSuggestionEntity> suggestions;

  const HomeLoaded(this.suggestions);

}

class HomeError extends HomeWeatherState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
