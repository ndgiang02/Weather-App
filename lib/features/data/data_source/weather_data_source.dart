import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constant/constant.dart';
import '../models/weather_response.dart';


abstract class WeatherRemoteDataSource {
  Future<WeatherResponseModel> getWeather(double lat, double lon);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;
  WeatherRemoteDataSourceImpl(this.client);

  @override
  Future<WeatherResponseModel> getWeather(double lat, double lon) async {

    final Uri geocodingUri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: 'data/3.0/onecall',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': dotenv.env['APPID'],
      },
    );

    final response = await client.get(geocodingUri);
    if (response.statusCode == 200) {
      return WeatherResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

}
