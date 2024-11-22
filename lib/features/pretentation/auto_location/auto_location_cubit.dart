import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/load_status.dart';
import '../../domain/entities/auto_location.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_auto.dart';
import '../../domain/usecases/get_weather.dart';

part 'auto_location_state.dart';

class AutoLocationCubit extends Cubit<AutoLocationState> {

  final GetAutoUseCase getAutoUseCase;

  final GetWeatherUseCase getWeatherUseCase;


  AutoLocationCubit(this.getWeatherUseCase, {required this.getAutoUseCase})
      : super(const AutoLocationState());

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
      emit(state.copyWith(status: LoadStatus.Done, weather: weather, cityName: cityName));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.Error, errMsg: e.toString()));
    }
  }
}
