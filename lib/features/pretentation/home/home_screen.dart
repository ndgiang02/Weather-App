import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              convert(weather.current.temp),
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
          title: Text(suggestion.region, style: CustomTextStyles.temper,),
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

}


