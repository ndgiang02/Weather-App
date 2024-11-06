import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'detail_weather_state.dart';

class DetailWeatherCubit extends Cubit<DetailWeatherState> {
  DetailWeatherCubit() : super(DetailWeatherInitial());
}
