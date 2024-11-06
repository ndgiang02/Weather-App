import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/constant/constant.dart';
import '../../domain/entities/auto_location.dart';
import '../models/auto_location_model.dart';

abstract class AutocompleteDataSource {
  Future<List<LocationSuggestionEntity>> getSuggestions(String query);
}

class AutocompleteDataSourceImpl implements AutocompleteDataSource {
  final http.Client client;
  AutocompleteDataSourceImpl({required this.client});

  @override
  Future<List<LocationSuggestionEntity>> getSuggestions1(String query) async {
    final Uri geocodingUri = Uri(
      scheme: 'https',
      host: kApiMap,
      path: '/geocode/autocomplete',
      queryParameters: {
        'api_key': dotenv.env['MAPKEY'],
        'text': query,
        'sources': 'geonames',
        'size': 5,
      },
    );

    final http.Response response = await client.get(geocodingUri);

    // In mã trạng thái và phản hồi từ API
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}"); // In toàn bộ dữ liệu trả về

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Decoded JSON data: $data"); // Log dữ liệu đã phân tích

      // Kiểm tra nếu 'features' là một danh sách
      if (data.containsKey('features') && data['features'] is List) {
        final List<LocationSuggestionEntity> suggestions = (data['features'] as List)
            .map((feature) => LocationSuggestionModel.fromJson(feature))
            .toList();
        return suggestions;
      } else {
        // Nếu không phải danh sách, log chi tiết kiểu dữ liệu và giá trị
        print('Unexpected data format in "features": ${data['features']}');
        throw Exception('Unexpected data format: "features" is not a list or missing');
      }
    } else {
      // Xử lý lỗi nếu mã trạng thái không phải 200
      throw Exception("Error fetching location suggestions, status code: ${response.statusCode}");
    }
  }

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
      print("Decoded JSON data: $data");

      if (data.containsKey('features') && data['features'] is List) {
        final List<LocationSuggestionEntity> suggestions = (data['features'] as List)
            .map((feature) => LocationSuggestionModel.fromJson(feature))
            .toList();
        return suggestions;
      } else {
        print('Unexpected data format for "features": ${data['features']}');
        throw Exception('Unexpected data format: "features" is not a list or missing');
      }
    } else {
      print('Error fetching location suggestions, status code: ${response.statusCode}');
      throw Exception("Error fetching location suggestions, status code: ${response.statusCode}");
    }
  }

}
