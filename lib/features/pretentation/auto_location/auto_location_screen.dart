import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/load_status.dart';
import '../../../core/utils/textstyle.dart';
import 'auto_location_cubit.dart';

class AutoLocationScreen extends StatefulWidget {
  const AutoLocationScreen({
    super.key,
  });

  @override
  AutoLocationScreenState createState() => AutoLocationScreenState();
}

class AutoLocationScreenState extends State<AutoLocationScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String x = DateFormat.H().format(time);
    return x;
  }

  String getDay(final day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    String x = DateFormat.E().format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AutoLocationCubit, AutoLocationState>(
        listener: (context, state) {
          if (state.status == LoadStatus.Done && state.weather != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.95,
                  minChildSize: 0.95,
                  maxChildSize: 0.95,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/${state.weather?.current.weather.icon}.jpeg"),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
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
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  final newWeather = state.weather!;
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/', // Đảm bảo rằng bạn đã định nghĩa route này trong ứng dụng của mình
                                    (route) =>
                                        false, // Xóa bỏ tất cả các route trước đó
                                    arguments:
                                        newWeather,
                                  );
                                },
                                child: const Text(
                                  'Thêm',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                          padding:
                                              const EdgeInsets.only(top: 48),
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
                                      color: Colors.white
                                          .withOpacity(0.2), // Nền mờ
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
                                      color: Colors.white
                                          .withOpacity(0.2), // Nền mờ
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
                                                        dailyForecast.dt *
                                                            1000),
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
                                                          style:
                                                              CustomTextStyles
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
          } else if (state.status == LoadStatus.Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không thể lấy dữ liệu thời tiết.')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
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
                        onChanged: (value) {
                          context
                              .read<AutoLocationCubit>()
                              .getAutoLocation(value);
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _controller.clear();
                        Navigator.pop(context);
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (state.status == LoadStatus.Loading)
                  Center(
                    child: Image.asset(
                      'assets/gif/loading-load.gif',
                      height: 30,
                      width: 30,
                    ),
                  )
                else if (state.status == LoadStatus.Error)
                  const Center(child: Text('Đã xảy ra lỗi, vui lòng thử lại!'))
                else if (state.status == LoadStatus.Done &&
                    state.suggestions.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = state.suggestions[index];
                        return ListTile(
                          title: Text(suggestion.region),
                          onTap: () async {
                            await context
                                .read<AutoLocationCubit>()
                                .fetchWeather(
                                  suggestion.latitude,
                                  suggestion.longitude,
                                  suggestion.region,
                                );
                            _controller.clear();
                            state.suggestions.clear();
                            FocusScope.of(context).unfocus();
                            dispose();
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  )
                else
                  const Center(child: Text('Không có kết quả.')),
              ],
            ),
          );
        },
      ),
    );
  }

  String convert(double kelvin) {
    return '${(kelvin - 273.15).round()}°C';
  }
}
