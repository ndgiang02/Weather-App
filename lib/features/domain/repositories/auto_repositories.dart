import '../entities/auto_location.dart';

abstract class AutocompleteRepository {

  Future<List<LocationSuggestionEntity>> getLocationSuggestions(String query);
}