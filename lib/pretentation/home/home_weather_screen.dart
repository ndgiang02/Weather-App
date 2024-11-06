// lib/features/weather/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/pretentation/home/home_weather_cubit.dart';
import 'package:weatherapp/pretentation/home/home_weather_state.dart';

class HomeWeatherScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeWeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<HomeWeatherCubit, HomeWeatherState>(
              builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        contentPadding: const EdgeInsets.all(4.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        context.read<HomeWeatherCubit>().getAuto(query);
                      },
                    ),
                    if (_controller.text.isNotEmpty)
                      if (state is HomeLoaded)
                        SizedBox(
                          height: 300,
                          child: ListView.separated(
                            itemCount: state.suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = state.suggestions[index];
                              return ListTile(
                                title: Text(suggestion.region),
                                onTap: () {
                                  _controller.text = suggestion.name;
                                  /* context.read<HomeWeatherCubit>().fetchWeather(suggestion.name);*/
                                  FocusScope.of(context)
                                      .unfocus();
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(),
                          ),
                        ),
                    if (state is HomeLoading)
                      Image.asset(
                        'assets/gif/loading.gif',
                        height: 50,
                        width: 50,
                      ),
                    if (state is HomeError)
                      Text(state.message,
                          style: const TextStyle(color: Colors.red)),
                    if (_controller.text.isEmpty) const SizedBox.shrink(),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
