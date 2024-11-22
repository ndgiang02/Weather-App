import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/textstyle.dart';
import '../../../core/utils/load_status.dart';
import '../weather_detail/details_screen.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.status == LoadStatus.Done && state.weather != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                weather: state.weather!,
                cityName: state.cityName ?? 'Unknown City',
              ),
            ),
          );
        } else if (state.status == LoadStatus.Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể lấy dữ liệu thời tiết.')),
          );
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.isSearching && state.suggestions.isNotEmpty) {
                    return Expanded(child: _buildSuggestionsList(context, state));
                  } else if (!state.isSearching && state.weatherList.isEmpty) {
                    return _buildAddLocationButton(context);
                  } else {
                    return Expanded(child: _buildWeatherList(context, state));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isSearching) {
            return TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) => context.read<HomeCubit>().getAutoLocation(value),
              decoration: const InputDecoration(
                hintText: "Tìm tên thành phố",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
            );
          } else {
            return const Text('Thời tiết', style: CustomTextStyles.header);
          }
        },
      ),
      actions: [
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return IconButton(
              icon: SvgPicture.asset(
                state.isSearching ? 'assets/svg/close.svg' : 'assets/svg/search.svg',
                width: 24.0,
                height: 24.0,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              onPressed: () {
                context.read<HomeCubit>().toggleSearch();
                if (!state.isSearching) _controller.clear();
              },
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/svg/more-horizontal.svg',
            width: 24.0,
            height: 24.0,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => log('More options pressed'),
        ),
      ],
    );
  }

  Widget _buildWeatherList(BuildContext context, HomeState state) {
    return ListView.builder(
      itemCount: state.weatherList.length,
      itemBuilder: (context, index) {
        final weather = state.weatherList[index];
        return _buildWeatherCard(weather);
      },
    );
  }

  Widget _buildWeatherCard(weather) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
            image: AssetImage("assets/images/${weather.current.weather.icon}.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.current.weather.description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${convert(weather.current.temp)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddLocationButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.read<HomeCubit>().toggleSearch(),
        child: const Text(
          '+ Add Location',
          style: CustomTextStyles.header,
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context, HomeState state) {
    return ListView.builder(
      itemCount: state.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return ListTile(
          title: Text(suggestion.region),
          onTap: () {
            context.read<HomeCubit>().fetchWeather(
              suggestion.latitude,
              suggestion.longitude,
              suggestion.region,
            );
            _controller.clear();
            FocusScope.of(context).unfocus();
            context.read<HomeCubit>().disableSearch();
          },
        );
      },
    );
  }

  void _showWeatherDetails(BuildContext context, HomeState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.95,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/${state.weather?.current.weather.icon}.jpeg",
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(bottomSheetContext).pop();
                        },
                        child: const Text(
                          'Hủy',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<HomeCubit>().addWeatherItem(state.weather!);
                          Navigator.of(bottomSheetContext).pop();
                        },
                        child: const Text(
                          'Thêm',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 16.0),
                           Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 48),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/icons/${state.weather?.current.weather.icon}.png'),
                                    fit: BoxFit.none,
                                  ),
                                ),
                                Text(
                                  state.cityName!,
                                  style: CustomTextStyles.header,
                                ),
                                Text(
                                  convert(state.weather!.current.temp),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 80,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  'H: ${(state.weather!.current.feelsLike - 273.15).round()}\u00B0 L: ${(state.weather!.current.temp - 273.15).round()}\u00B0',
                                  style: CustomTextStyles.normal,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color:
                              Colors.white.withOpacity(0.2), // Nền mờ
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Dự báo theo giờ',
                                        style: CustomTextStyles.note,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  height: 1.0,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 24,
                                    itemBuilder: (context, index) {
                                      final forecast =
                                      state.weather!.hourly[index];
                                      final screenWidth =
                                          MediaQuery.of(context)
                                              .size
                                              .width;
                                      final itemWidth =
                                          (screenWidth - (4 * 8)) / 5;
                                      return Container(
                                        width: itemWidth,
                                        margin:
                                        const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000).hour}:${DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000).minute.toString().padLeft(2, '0')}',
                                                style: CustomTextStyles
                                                    .temper),
                                            Image(
                                              image: AssetImage(
                                                  'assets/icons/${forecast.weather.icon}.png'),
                                              width: 30,
                                              height: 30,
                                            ),
                                            Text(convert(forecast.temp),
                                                style: CustomTextStyles
                                                    .temper),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color:
                              Colors.white.withOpacity(0.2), // Nền mờ
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text('Dự báo 8 ngày',
                                          style: CustomTextStyles.note),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  height: 1.0,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount:
                                    state.weather!.daily.length,
                                    itemBuilder: (context, index) {
                                      final dailyForecast =
                                      state.weather!.daily[index];
                                      final dayOfWeek =
                                      DateFormat('EEE').format(
                                        DateTime
                                            .fromMillisecondsSinceEpoch(
                                            dailyForecast.dt * 1000),
                                      );
                                      return Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              child: Text(dayOfWeek,
                                                  style: CustomTextStyles
                                                      .temper),
                                            ),
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/icons/${dailyForecast.weather.icon}.png'),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 90,
                                              child: Text(
                                                '${convert(dailyForecast.temp.min)} / ${convert(dailyForecast.temp.max)}',
                                                style: CustomTextStyles
                                                    .temper,
                                                textAlign:
                                                TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String convert(double kelvin) {
    return '${(kelvin - 273.15).round()}°C';
  }
}


