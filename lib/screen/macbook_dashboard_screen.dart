import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:portfolio/constant/constant.dart';
import 'package:portfolio/utility_method.dart';
import 'package:portfolio/widget/date_time_widget.dart';
import 'package:portfolio/widget/desktop_icon_widget.dart';

class MacBookDashboardScreen extends StatelessWidget {
  const MacBookDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Constant.macosBg),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // desktop icons
          const DesktopIcon(),

          // weather details widget
          const Positioned(
            right: 24.0,
            top: 44.0,
            child: MacOSWeatherDetailsWidget(),
          ),

          // top overlay
          Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 24.0),
                  width: double.infinity,
                  height: 32,
                  color: Colors.black.withOpacity(0.3),
                  // semi-transparent color
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.apple,
                            color: Colors.white,
                          ),
                          SizedBox(width: 12),
                          VisibleTextFinder(),
                          SizedBox(width: 12),
                          Text("About Me",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(width: 12),
                          Text("Contact",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(width: 12),
                          Text("Projects",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 24,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implement language
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                foregroundColor: const Color(0xff757575),
                              ),
                              child: const Text(
                                "EN",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const MacOSDateTimeWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MacOSWeatherDetailsWidget extends StatefulWidget {
  const MacOSWeatherDetailsWidget({
    super.key,
  });

  @override
  State<MacOSWeatherDetailsWidget> createState() =>
      _MacOSWeatherDetailsWidgetState();
}

class _MacOSWeatherDetailsWidgetState extends State<MacOSWeatherDetailsWidget> {
  @override
  void initState() {
    super.initState();
    UtilityService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 180.0,
          width: 200.0,
          child: ValueListenableBuilder<WeatherData>(
            valueListenable: currentTemperatureNotifier,
            builder: (context, weatherData, _) => weatherData.isFetching
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            weatherData.city,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${weatherData.temperature.ceil()}°C",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      weatherData.iconUrl != ""
                          ? Image.network(
                              weatherData.iconUrl,
                              height: 30,
                              width: 30,
                            )
                          : const SizedBox(),
                      const SizedBox(height: 8),
                      Text(
                          "${weatherData.weatherCondition}\nH: ${weatherData.latAndLong.$1.approximate(1)}° L : ${weatherData.latAndLong.$2.approximate(1)}°",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          )),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class MacOSDateTimeWidget extends StatefulWidget {
  const MacOSDateTimeWidget({super.key});

  @override
  State<MacOSDateTimeWidget> createState() => _MacOSDateTimeWidgetState();
}

class _MacOSDateTimeWidgetState extends State<MacOSDateTimeWidget> {
  late DateTimeNotifier _dateTimeNotifier;

  @override
  void initState() {
    super.initState();
    _dateTimeNotifier = DateTimeNotifier();
  }

  @override
  void dispose() {
    _dateTimeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<(String, String)>(
      valueListenable: _dateTimeNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return Text(
          "${value.$2} ${value.$1}",
          style: const TextStyle(fontSize: 14, color: Colors.white),
        );
      },
    );
  }
}

class VisibleTextFinder extends StatelessWidget {
  const VisibleTextFinder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFinderVisibleNotifier,
      builder: (BuildContext context, bool isActive, _) {
        return Visibility(
          visible: isActive,
          child: const Text(
            "Finder",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        );
      },
    );
  }
}

ValueNotifier<bool> isFinderVisibleNotifier = ValueNotifier<bool>(true);

extension DoubleApproximation on num {
  double approximate(int decimalPlaces) {
    double mod = math.pow(10.0, decimalPlaces).toDouble();
    return (this * mod).round() / mod;
  }
}
