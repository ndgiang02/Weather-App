import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/pretentation/home/home_weather_cubit.dart';
import 'package:weatherapp/pretentation/home/home_weather_screen.dart';

import 'injection.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<HomeWeatherCubit>(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'SFPro',
        ),
        debugShowCheckedModeBanner: false,
        home: HomeWeatherScreen(),
      ),
    );
  }

}