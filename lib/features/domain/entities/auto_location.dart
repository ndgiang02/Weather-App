// lib/features/weather/domain/entities/location_suggestion_entity.dart

class LocationSuggestionEntity {
  final String name;
  final String country;
  final String region;
  final String? county;
  final String label;
  final double latitude;
  final double longitude;

  LocationSuggestionEntity({
    required this.name,
    required this.country,
    required this.region,
    this.county,
    required this.label,
    required this.latitude,
    required this.longitude,
  });
}
