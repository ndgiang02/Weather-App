import 'dart:developer';

import '../entities/auto_location.dart';
import '../repositories/auto_repositories.dart';


class GetAutoUseCase {

  final AutocompleteRepository autocompleteRepository;

  GetAutoUseCase(this.autocompleteRepository);

  Future<List<LocationSuggestionEntity>> execute(String cityName) async {
    try {
      final suggestions = await autocompleteRepository.getLocationSuggestions(cityName);
      return suggestions;
    } catch (e, stacktrace) {
      log("Error in execute: $e");
      log("Stacktrace in execute: $stacktrace");
      rethrow;
    }
  }

}