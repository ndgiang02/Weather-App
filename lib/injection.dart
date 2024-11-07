import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/data/data_source/auto_data_source.dart';
import 'features/data/data_source/weather_data_source.dart';
import 'features/data/repositories/auto_repositories_impl.dart';
import 'features/data/repositories/weather_repositories_impl.dart';
import 'features/domain/repositories/auto_repositories.dart';
import 'features/domain/repositories/weather_repositories.dart';
import 'features/domain/usecases/get_auto.dart';
import 'features/domain/usecases/get_weather.dart';
import 'features/pretentation/auto_location/auto_location_cubit.dart';
import 'features/pretentation/home/home_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {

  // external
  locator.registerLazySingleton(() => http.Client());

  locator.registerLazySingleton<WeatherRemoteDataSource>(
          () => WeatherRemoteDataSourceImpl(locator<http.Client>()));

  locator.registerLazySingleton<AutocompleteDataSource>(
        () => AutocompleteDataSourceImpl(client: locator<http.Client>(),
    ),
  );

  // Đăng ký các repositories
  locator.registerLazySingleton<WeatherRepository>(() =>
      WeatherRepositoryImpl(locator<WeatherRemoteDataSource>()));

  locator.registerLazySingleton<AutocompleteRepository>(() =>
      AutocompleteRepositoryImpl(locator<AutocompleteDataSource>()));

  // Đăng ký các use cases
  locator.registerLazySingleton<GetWeatherUseCase>(() => GetWeatherUseCase(locator()));

  locator.registerLazySingleton<GetAutoUseCase>(() => GetAutoUseCase(locator()));

  // Đăng ký các Cubit
  locator.registerFactory<HomeCubit>(() => HomeCubit(getWeatherUseCase: locator()));

  locator.registerFactory<AutoLocationCubit>(() => AutoLocationCubit(getAutoUseCase: locator()));


/*  // data source
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
  locator.registerFactory<AutoLocationCubit>(
        () => AutoLocationCubit(
      AutoLocationInitial(),
      locator<GetAutoUseCase>(),
    ),
  );*/
}
