import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/features/domain/usecases/get_auto.dart';
import 'package:weatherapp/features/domain/usecases/get_weather_current.dart';

import '../../../../core/utils/load_status.dart';
import '../../domain/entities/auto_location.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_weather.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetWeatherUseCase getWeatherUseCase;
  final GetAutoUseCase getAutoUseCase;
  final GetWeatherByCurrentLocation getWeatherByCurrentLocation;

  HomeCubit(this.getAutoUseCase, this.getWeatherByCurrentLocation,
      {required this.getWeatherUseCase})
      : super(const HomeState());

  void toggleSearch() {
    emit(state.copyWith(isSearching: !state.isSearching));
  }

  void enableSearch() {
    emit(state.copyWith(isSearching: true));
  }

  void disableSearch() {
    emit(state.copyWith(isSearching: false));
  }

  void addWeatherItem(WeatherResponseEntity newWeather) {
    final updatedList = List<WeatherResponseEntity>.from(state.weatherList)
      ..add(newWeather);
    emit(state.copyWith(weatherList: updatedList));
  }

  Future<void> getAutoLocation(String query) async {
    emit(state.copyWith(status: LoadStatus.Loading));
    try {
      final List<LocationSuggestionEntity> suggestions =
          await getAutoUseCase.execute(query);
      emit(state.copyWith(status: LoadStatus.Done, suggestions: suggestions));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.Error));
    }
  }

  Future<void> fetchWeather(double lat, double lon, String cityName) async {
    emit(state.copyWith(status: LoadStatus.Loading));
    try {
      final weather = await getWeatherUseCase.execute(lat, lon);
      emit(state.copyWith(
          status: LoadStatus.Done, weather: weather, cityName: cityName));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.Error, errMsg: e.toString()));
    }
  }

  void getWeather() async {
    emit(state.copyWith(status: LoadStatus.Loading));
    try {
      final weather = await getWeatherByCurrentLocation.execute();
      emit(state.copyWith(status: LoadStatus.Done, weather: weather));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.Error, errMsg: e.toString()));
    }
  }
}
