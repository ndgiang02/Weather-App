import '../../domain/entities/auto_location.dart';

class LocationSuggestionModel extends LocationSuggestionEntity {
  LocationSuggestionModel({
    required super.name,
    required super.country,
    required super.region,
    super.county,
    required super.label,
    required super.latitude,
    required super.longitude,
  });

  factory LocationSuggestionModel.fromJson(Map<String, dynamic> json) {
    return LocationSuggestionModel(
      name: json['properties']['name'] ?? 'Unknown',
      country: json['properties']['country'] ?? 'Unknown',
      region: json['properties']['region'] ?? 'Unknown',
      county: json['properties']['county'],
      label: json['properties']['label'] ?? 'Unknown',
      latitude: (json['geometry']['coordinates'][1] is int)
          ? (json['geometry']['coordinates'][1] as int).toDouble()
          : json['geometry']['coordinates'][1] as double,
      longitude: (json['geometry']['coordinates'][0] is int)
          ? (json['geometry']['coordinates'][0] as int).toDouble()
          : json['geometry']['coordinates'][0] as double,

    );
  }

  LocationSuggestionEntity toEntity() {
    return LocationSuggestionEntity(
      name: name,
      country: country,
      region: region,
      county: county,
      label: label,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'properties': {
        'name': name,
        'country': country,
        'region': region,
        'county': county,
        'label': label,
      },
      'geometry': {
        'coordinates': [longitude, latitude],
      },
    };
  }
}