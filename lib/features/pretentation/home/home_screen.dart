import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weatherapp/core/utils/load_status.dart';

import '../../../../core/utils/textstyle.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/svg/more-horizontal.svg',
              width: 24.0,
              height: 24.0,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: () {
              log('More options pressed');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thời tiết', style: CustomTextStyles.header),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      controller: _controller,
                      onTap: () {
                        Navigator.pushNamed(context, '/search');
                      },
                      decoration: InputDecoration(
                        hintText: "Tìm tên thành phố",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 2.0),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      onChanged: (query) {
                        //context.read<AutoLocationCubit>().getAuto(query);
                      },
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state.status == LoadStatus.Loading) {
                          return  Image.asset(
                            'assets/gif/loading.gif',
                            height: 50,
                            width: 50,
                          );
                        } else if (state.status == LoadStatus.Error) {
                          return const Center(child: Text('Không có thong tin'));
                        } else if (state.status == LoadStatus.Done &&
                            state.weather != null) {
                          return Column(
                            children: [
                              //WeatherCard(weather: state.weather!),
                              ElevatedButton(
                                onPressed: () {
                                  //context.read<HomeCubit>().addWeatherToList();
                                },
                                child: const Text('Thêm vào danh sách yêu thích'),
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: Text('Không có dữ liệu.'));
                        }
                      },
                    ),
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
