
import '../../domain/entities/auto_location.dart';
import '../../domain/repositories/auto_repositories.dart';
import '../data_source/auto_data_source.dart';

class AutocompleteRepositoryImpl implements AutocompleteRepository {

  final AutocompleteDataSource autoDataSource;

  AutocompleteRepositoryImpl(this.autoDataSource);

  @override
  Future<List<LocationSuggestionEntity>> getLocationSuggestions(String query) async {
    return await autoDataSource.getSuggestions(query);
  }
}