import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:portfolio/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import "package:universal_html/html.dart" as html;
import 'package:http/http.dart' as http;

import 'widget/info_overlay_widget.dart';

class UtilityService {
  const UtilityService._();

  static Future<void> launchCallMe() async {
    final Uri params = Uri(
      scheme: 'tel',
      path: "+234 916 7638 610",
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch $params';
    }
  }

  static Future<void> launchMail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: "mondaysolomon01@gmail.com",
      query: {
        'subject': "Portfolio Inquiry - OKWHAROBO SOLOMON MONDAY",
        'body': '''
Dear [Recipient Name],

My name is [Your Name] and I am a [Your Profession]. I am writing to express my interest in your work and discuss potential opportunities.

You can view my online portfolio at: [Link to your portfolio]

Sincerely,

[Your Name]
            ''',
      }
          .entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'),
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch $params';
    }
  }

  static Widget buildDivider() => Divider(
        color: Colors.white.withOpacity(0.3),
        indent: 20,
        endIndent: 20,
      );

  static void downloadResume() {
    html.AnchorElement(href: Constant.resumeDownloadUrl)
      ..setAttribute('download', 'Okwharobo_Solomon_Resume.pdf')
      ..click();
  }

  static void getLocation() {
    html.window.navigator.geolocation.getCurrentPosition().then((position) {
      final latitude = position.coords!.latitude;
      final longitude = position.coords!.longitude;

      http
          .get(Uri.parse(
              "http://api.weatherapi.com/v1/current.json?key=${Constant.apiKey}&q=$latitude,$longitude"))
          .then((response) {
        final data = jsonDecode(response.body);
        double tempInCelsius = data['current']['temp_c'];
        log('Temperature: $tempInCelsius');
        currentTemperatureNotifier.value =
            WeatherData.fromJson(jsonDecode(response.body));
        log('Response: ${response.body}');
      });
      log('Latitude: $latitude, Longitude: $longitude');
    });
  }

  static void visitPersonalWebsite() {
    html.window.open(Constant.personalWebsiteUrl, "Personal Website");
  }

  static void visitGithubProfile() {
    html.window.open(Constant.githubUrl, "Monday Github URL");
  }

  static void visitLinkedinProfile() {
    html.window.open(Constant.linkedinUrl, "Monday LinkedIn URL");
  }

  static void launchFullScreen() {
    html.document.documentElement!.requestFullscreen();
  }

  static List<MethodProperty> shortcutProperty = [
    ("Projects", Constant.flutterLogo, const Color(0xffcee7fc), () {}),
    (
      "Resume",
      Constant.resumeLogo,
      Colors.white70,
      UtilityService.downloadResume
    ),
    (
      "Github",
      Constant.githubLogo,
      Colors.white70,
      UtilityService.visitGithubProfile
    ),
    (
      "LinkedIn",
      Constant.linkedinLogo,
      Colors.white,
      UtilityService.visitLinkedinProfile,
    ),
    (
      "Fullscreen",
      Constant.fullScreenSvg,
      Colors.white54,
      UtilityService.launchFullScreen
    )
  ];

  static void showHelpOverlay(
    BuildContext context,
    String message,
    GlobalKey key,
    double width,
  ) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      InfoOverlayManager().showInfoOverlay(
        context,
        message,
        position,
        overlayWidth: width, // Optional: Customize width of the overlay
      );
    }
  }

  // Format time
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatMacOSDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  // date format
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}

typedef MethodProperty = (String, String, Color, VoidCallback);

final currentTemperatureNotifier =
    ValueNotifier<WeatherData>(WeatherData.initialData());

class WeatherData {
  final num temperature;
  final String city;
  final String iconUrl;
  final (num, num) latAndLong;
  final String weatherCondition;
  final bool isFetching;

 

  WeatherData.fromJson(Map<String, dynamic> json)
      : temperature = json['current']['temp_c'] ,
        city = json['location']['name'],
        iconUrl = json['current']['condition']['icon'],
        weatherCondition = json['current']['condition']['text'],
        isFetching = false,
        latAndLong = (json['location']['lat'], json['location']['lon']);

  WeatherData.initialData()
      : temperature = 0.0,
        city = "Fetching city ...",
        iconUrl = "",
        weatherCondition = "",
        isFetching = true,
        latAndLong = (0.0, 0.0);

}
