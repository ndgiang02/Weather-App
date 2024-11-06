part of 'suggestion_cubit.dart';

abstract class SuggestionState extends Equatable {
  const SuggestionState();

  @override
  List<Object?> get props => [];
}

class SuggestionInitial extends SuggestionState {}

class SuggestionLoading extends SuggestionState {}

class SuggestionLoaded extends SuggestionState {

  final List<LocationSuggestionEntity> suggestions;

  const SuggestionLoaded(this.suggestions);

}

class SuggestionError extends SuggestionState {
  final String message;

  const SuggestionError(this.message);

  @override
  List<Object?> get props => [message];
}
