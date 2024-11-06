import 'package:weatherapp/pretentation/home/home_weather_cubit.dart';
import 'package:weatherapp/pretentation/home/home_weather_state.dart';
import 'package:weatherapp/pretentation/suggestion/suggestion_cubit.dart';

import 'data/data_source/auto_data_source.dart';
import 'data/repositories/auto_repositories_impl.dart';
import 'domain/repositories/auto_repositories.dart';
import 'domain/usecases/get_auto.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void setupLocator() {

  // external
  locator.registerLazySingleton(() => http.Client());

  // data source
  locator.registerLazySingleton<AutocompleteDataSource>(
        () => AutocompleteDataSourceImpl(
      client: locator<http.Client>(),
    ),
  );

  // repository
  locator.registerLazySingleton<AutocompleteRepository>(
        () => AutocompleteRepositoryImpl(
      locator<AutocompleteDataSource>(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetAutoUseCase(locator<AutocompleteRepository>()));

  // cubit
  locator.registerFactory<HomeWeatherCubit>(
        () => HomeWeatherCubit(
      HomeInitial(),
      locator<GetAutoUseCase>(),
    ),
  );
}
