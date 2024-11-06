import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/domain/usecases/get_auto.dart';

import 'home_weather_state.dart';

class HomeWeatherCubit extends Cubit<HomeWeatherState> {

  final GetAutoUseCase getAutoUseCase;

  HomeWeatherCubit(super.initialState, this.getAutoUseCase);

  Future<void> getAuto(String cityName) async {
    emit(HomeLoading());
    try {
      final data = await getAutoUseCase.execute(cityName);
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError("Failed to load data: ${e.toString()}"));
    }
  }

}
