import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auto_location.dart';
import '../../domain/usecases/get_auto.dart';

part 'suggestion_state.dart';

class SuggestionCubit extends Cubit<SuggestionState> {
  final GetAutoUseCase getAutoUseCase;

  SuggestionCubit(super.initialState, this.getAutoUseCase);

  Future<void> getAuto(String cityName) async {
    emit(SuggestionLoading());
    try {
      log("Calling execute with cityName: $cityName");
      final data = await getAutoUseCase.execute(cityName);
      log("Data received in getAuto: $data");
      emit(SuggestionLoaded(data));
    } catch (e, stacktrace) {
      log("Error in getAuto: $e");
      log("Stacktrace: $stacktrace");
      emit(SuggestionError("Failed to load data: ${e.toString()}"));
    }
  }
}


