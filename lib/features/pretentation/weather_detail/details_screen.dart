import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../core/utils/textstyle.dart';
import '../../domain/entities/weather.dart';

class DetailScreen extends StatelessWidget {
  final WeatherResponseEntity weather;
  final String cityName;

  const DetailScreen({required this.weather, required this.cityName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/${weather.current.weather.icon}.jpeg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay mờ
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: false,
                delegate: _CustomSliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 300,
                  childBuilder: (context, shrinkOffset, overlapsContent) {
                    final opacity = 1 - (shrinkOffset / 250).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: _buildWeatherDetails(),
                        ),
                    );
                  },
                ),
              ),

              SliverPersistentHeader(
                pinned: false,
                delegate: _CustomSliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 200,
                  childBuilder: (context, shrinkOffset, overlapsContent) {
                    final opacity = 1 - (shrinkOffset / 300).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: _buildHourlyForecast(),
                      ),
                    );
                  },
                ),
              ),

              SliverPersistentHeader(
                pinned: false,
                delegate: _CustomSliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 500,
                  childBuilder: (context, shrinkOffset, overlapsContent) {
                    final opacity = 1 - (shrinkOffset / 250).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: _buildDailyForecast(),
                      ),
                    );
                  },
                ),
              ),

              SliverPersistentHeader(
                pinned: false,
                delegate: _CustomSliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 180,
                  childBuilder: (context, shrinkOffset, overlapsContent) {
                    final opacity = 1 - (shrinkOffset / 150).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                        child: _buildWind(),
                      ),
                    );
                  },
                ),
              ),

              SliverPersistentHeader(
                pinned: false,
                delegate: _CustomSliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 180,
                  childBuilder: (context, shrinkOffset, overlapsContent) {
                    final opacity = 1 - (shrinkOffset / 150).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                        child: _buildFeelsLike(),
                      ),
                    );
                  },
                ),
              ),

              SliverPersistentHeader(
                pinned: false,
                delegate: _CustomSliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 180,
                  childBuilder: (context, shrinkOffset, overlapsContent) {
                    final opacity = 1 - (shrinkOffset / 150).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                        child: _buildUvPressure(),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      // Add to favorites action
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Image.asset(
                  'assets/icons/${weather.current.weather.icon}.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  cityName,
                  style: CustomTextStyles.header,
                ),
                Text(
                  convert(weather.current.temp),
                  style: CustomTextStyles.temp,
                ),
                Text(
                  'H: ${convert(weather.current.feelsLike)} '
                      'L: ${convert(weather.current.temp)} ',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8.0),
                      Text(weather.current.weather.description, style: CustomTextStyles.temper),
                    ],
                  ),
                ),
                const Divider(color: Colors.white70),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      final forecast = weather.hourly[index];
                      return Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000).hour}:00',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Image.asset(
                              'assets/icons/${forecast.weather.icon}.png',
                              width: 30,
                              height: 30,
                            ),
                            Text(
                              '${(forecast.temp - 273.15).round()}°C',
                              style: const TextStyle(color: Colors.white70),
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
        ),
      ),
    );
  }

  Widget _buildDailyForecast() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      SizedBox(width: 8.0),
                      Text('8-Days', style: CustomTextStyles.note),
                    ],
                  ),
                ),
                const Divider(color: Colors.white70),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: weather.daily.length,
                  itemBuilder: (context, index) {
                    final dailyForecast = weather.daily[index];
                    final dayOfWeek = DateFormat('EEE').format(
                      DateTime.fromMillisecondsSinceEpoch(dailyForecast.dt * 1000),
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dayOfWeek, style: const TextStyle(color: Colors.white70)),
                          Image.asset(
                            'assets/icons/${dailyForecast.weather.icon}.png',
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            '${(dailyForecast.temp.min - 273.15).round()}°C / ${(dailyForecast.temp.max - 273.15).round()}°C',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWind() {
    return Row(
      children: [
        Flexible(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter:
                    ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 51),
                    child: Container(
                      height: 180,
                      padding:
                      const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                            EdgeInsets
                                .all(
                                8.0),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons
                                      .wind,
                                  size: 18,
                                  color: Colors
                                      .white54,
                                ),
                                Text(
                                  'WIND',
                                  style: TextStyle(
                                      color: Colors
                                          .white54,
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child:
                              Padding(
                                padding:
                                const EdgeInsets
                                    .all(
                                    8.0),
                                child:
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration:
                                  const BoxDecoration(
                                    image:
                                    DecorationImage(
                                      image: AssetImage(
                                          'assets/images/compass1.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment:
                                        Alignment.center,
                                        child:
                                        CustomPaint(
                                          painter: WindDirectionPainter(weather.current.windDeg
                                              .toDouble()),
                                          size: const Size(
                                              150,
                                              150),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left:
                                            1,
                                            top:
                                            1.5),
                                        child:
                                        Align(
                                          alignment:
                                          Alignment.center,
                                          child:
                                          Stack(
                                            children: [
                                              BackdropFilter(filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10)),
                                              Container(
                                                width: 45,
                                                height: 45,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black54,
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        weather.current.windSpeed.toStringAsFixed(0),
                                                        style: CustomTextStyles.temper,
                                                      ),
                                                      Text(
                                                        'km/h',
                                                        style: TextStyle(color: Colors.white.withOpacity(0.90), fontSize: 10, fontWeight: FontWeight.w900),
                                                      ),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: Container(
              width: double.maxFinite,
              height: 180,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter:
                    ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 51),
                    child: Container(
                      height: 180,
                      padding:
                      const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                            EdgeInsets
                                .all(
                                8.0),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons
                                      .eye_fill,
                                  size: 18,
                                  color: Colors
                                      .white54,
                                ),
                                Text(
                                  ' VISIBILITY',
                                  style: TextStyle(
                                      color: Colors
                                          .white54,
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SleekCircularSlider(
                                    min: 0,
                                    max: 50,
                                    initialValue:  weather.current.visibility.toDouble() / 1000,
                                    appearance: CircularSliderAppearance(
                                        infoProperties: InfoProperties(
                                          mainLabelStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                          modifier: (percentage) {
                                            final roundedValue = percentage.toStringAsFixed(1);
                                            return '$roundedValue km';
                                          },
                                        ),
                                        animationEnabled: true,
                                        angleRange: 360,
                                        startAngle: 90,
                                        size: 140,
                                        customWidths: CustomSliderWidths(progressBarWidth: 5, handlerSize: 2),
                                        customColors: CustomSliderColors(hideShadow: true, trackColor: Colors.white54, progressBarColors: [Colors.red, Colors.blueGrey])),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeelsLike()  {
    return Row(
      children: [
        Flexible(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: Container(
              width: double.maxFinite,
              height: 180,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter:
                    ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 51),
                    child: Container(
                      height: 180,
                      padding:
                      const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                            EdgeInsets
                                .all(
                                8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .thermostat,
                                  size: 18,
                                  color: Colors
                                      .white54,
                                ),
                                Text(
                                  'FEELS LIKE',
                                  style: TextStyle(
                                      color: Colors
                                          .white54,
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SleekCircularSlider(
                                    min: 0,
                                    max: 100,
                                    initialValue: double.parse((weather.current.feelsLike.toDouble() - 273.15).toStringAsFixed(2)),
                                    appearance: CircularSliderAppearance(
                                        infoProperties: InfoProperties(
                                          mainLabelStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                          modifier: (percentage) {
                                            final roundedValue = percentage.ceil().toInt().toString();
                                            return '$roundedValue °';
                                          },
                                        ),
                                        animationEnabled: true,
                                        angleRange: 360,
                                        startAngle: 90,
                                        size: 140,
                                        customWidths: CustomSliderWidths(progressBarWidth: 5, handlerSize: 2),
                                        customColors: CustomSliderColors(hideShadow: true, trackColor: Colors.white54, progressBarColors: [Colors.red, Colors.blueGrey])),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: Container(
              width: double.maxFinite,
              height: 180,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter:
                    ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 51),
                    child: Container(
                      height: 180,
                      padding:
                      const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                            EdgeInsets
                                .all(
                                8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: 18,
                                  color: Colors
                                      .white54,
                                ),
                                Text(
                                  ' HUMIDITY',
                                  style: TextStyle(
                                      color: Colors
                                          .white54,
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SleekCircularSlider(
                                    min: 0,
                                    max: 100,
                                    initialValue: weather.current.humidity.toDouble(),
                                    appearance: CircularSliderAppearance(
                                        infoProperties: InfoProperties(
                                          mainLabelStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                          modifier: (percentage) {
                                            final roundedValue = percentage.ceil().toInt().toString();
                                            return '$roundedValue %';
                                          },
                                        ),
                                        animationEnabled: true,
                                        size: 140,
                                        customWidths: CustomSliderWidths(progressBarWidth: 8, handlerSize: 3),
                                        customColors: CustomSliderColors(hideShadow: true, trackColor: Colors.white54, progressBarColors: [Colors.blueGrey, Colors.black54])),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUvPressure()  {
    return Row(
      children: [
        Flexible(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: Container(
              width: double.maxFinite,
              height: 180,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter:
                    ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 51),
                    child: Container(
                      height: 180,
                      padding:
                      const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                            EdgeInsets
                                .all(
                                8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .sunny,
                                  size: 18,
                                  color: Colors
                                      .white54,
                                ),
                                Text(
                                  'UV INDEX',
                                  style: TextStyle(
                                      color: Colors
                                          .white54,
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SleekCircularSlider(
                                    min: 0,
                                    max: 100,
                                    initialValue: weather.current.uvi.toDouble(),
                                    appearance: CircularSliderAppearance(
                                        infoProperties: InfoProperties(
                                          mainLabelStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                          modifier: (percentage) {
                                            final roundedValue = percentage.ceil().toInt().toString();
                                            return roundedValue;
                                          },
                                        ),
                                        animationEnabled: true,
                                        size: 140,
                                        customWidths: CustomSliderWidths(progressBarWidth: 8, handlerSize: 3),
                                        customColors: CustomSliderColors(hideShadow: true, trackColor: Colors.white54,  progressBarColors: [
                                          Colors.purple,
                                          Colors.redAccent,
                                          Colors.orange,
                                          Colors.yellow,
                                          Colors.green,
                                        ],)),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: Container(
              width: double.maxFinite,
              height: 180,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter:
                    ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 51),
                    child: Container(
                      height: 180,
                      padding:
                      const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                            EdgeInsets
                                .all(
                                8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: 18,
                                  color: Colors
                                      .white54,
                                ),
                                Text(
                                  ' PRESSURE',
                                  style: TextStyle(
                                      color: Colors
                                          .white54,
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SleekCircularSlider(
                                    min: 0,
                                    max: 2000,
                                    initialValue: weather.current.pressure.toDouble(),
                                    appearance: CircularSliderAppearance(
                                        infoProperties: InfoProperties(
                                          mainLabelStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                          modifier: (percentage) {
                                            var formatter = NumberFormat('#,##,000');
                                            var fort = formatter.format(percentage);
                                            final roundedValue = fort.toString();
                                            return roundedValue;
                                          },
                                        ),
                                        animationEnabled: true,
                                        size: 140,
                                        customWidths: CustomSliderWidths(progressBarWidth: 5, handlerSize: 2),
                                        customColors: CustomSliderColors(hideShadow: true, trackColor: Colors.white54, progressBarColors: [Colors.red, Colors.blueGrey])),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String convert(double kelvin) {
  return '${(kelvin - 273.15).round()}°';
}


class _CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget Function(BuildContext, double, bool) childBuilder;

  _CustomSliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.childBuilder,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return childBuilder(context, shrinkOffset, overlapsContent);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class WindDirectionPainter extends CustomPainter {
  final double windDirection;

  WindDirectionPainter(this.windDirection);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double arrowLength = size.height * 0.95;
    double arrowWidth = size.width * 0.07;
    double arrowHeadWidth = arrowWidth * 1;
    double arrowHeadLength = size.width * 0.15;

    Path path = Path();
    path.moveTo(-arrowLength / 2, 0);
    path.lineTo(arrowLength / 2 - arrowHeadLength, 0);
    path.lineTo(arrowLength / 2 - arrowHeadLength, -arrowHeadWidth / 2);
    path.lineTo(arrowLength / 2, 0);
    path.lineTo(arrowLength / 2 - arrowHeadLength, arrowHeadWidth / 2);
    path.lineTo(arrowLength / 2 - arrowHeadLength, 0);
    path.lineTo(-arrowLength / 2, 0);
    path.close();

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2 - 0.1);
    canvas.rotate(windDirection * (pi / 180));
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}