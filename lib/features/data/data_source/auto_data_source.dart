import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/constant/constant.dart';
import '../../domain/entities/auto_location.dart';
import '../models/auto_location.dart';

abstract class AutocompleteDataSource {
  Future<List<LocationSuggestionEntity>> getSuggestions(String query);
}

class AutocompleteDataSourceImpl implements AutocompleteDataSource {

  final http.Client client;
  AutocompleteDataSourceImpl({required this.client});



  @override
  Future<List<LocationSuggestionEntity>> getSuggestions(String query) async {
    final Uri geocodingUri = Uri(
      scheme: 'https',
      host: kApiMap,
      path: '/geocode/autocomplete',
      queryParameters: {
        'api_key': dotenv.env['MAPKEY'],
        'text': query,
        'sources': 'geonames',
        'size': '5',
        'lang': 'vi',
        'boundary.country':'VN',
      },
    );

    final http.Response response = await client.get(geocodingUri);


    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('features') && data['features'] is List) {
        final List<LocationSuggestionEntity> suggestions = (data['features'] as List)
            .map((feature) => LocationSuggestionModel.fromJson(feature))
            .toList();
        return suggestions;
      } else {
       // print('Unexpected data format for "features": ${data['features']}');
        throw Exception('Unexpected data format: "features" is not a list or missing');
      }
    } else {
     // print('Error fetching location suggestions, status code: ${response.statusCode}');
      throw Exception("Error fetching location suggestions, status code: ${response.statusCode}");
    }
  }

}
