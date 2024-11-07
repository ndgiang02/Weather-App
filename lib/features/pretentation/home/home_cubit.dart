import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/load_status.dart';
import '../../domain/usecases/get_weather.dart';
import 'home_state.dart';



class HomeCubit extends Cubit<HomeState> {

  final GetWeatherUseCase getWeatherUseCase;

  HomeCubit({required this.getWeatherUseCase}) : super(const HomeState());

  Future<void> fetchWeather(double lat, double lon) async {
    emit(state.copyWith(status: LoadStatus.Loading));
    try {
      final weather = await getWeatherUseCase.execute(lat, lon);
      emit(state.copyWith(status: LoadStatus.Done, weather: weather));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.Error));
    }
  }
}
