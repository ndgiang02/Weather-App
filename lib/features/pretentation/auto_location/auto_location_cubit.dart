import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/load_status.dart';
import '../../domain/entities/auto_location.dart';
import '../../domain/usecases/get_auto.dart';

part 'auto_location_state.dart';

class AutoLocationCubit extends Cubit<AutoLocationState> {

  final GetAutoUseCase getAutoUseCase;

  AutoLocationCubit({required this.getAutoUseCase}) : super(AutoLocationState());

  Future<void> getAutoLoacation(String query) async {
    emit(state.copyWith(status: LoadStatus.Loading));
    try {
      final List<LocationSuggestionEntity> suggestions = await getAutoUseCase.execute(query);
      emit(state.copyWith(status: LoadStatus.Done, suggestions: suggestions));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.Error));
    }
  }
}
