import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/constant/constant.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Constant.windowBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blurry overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: 68,
                  color:
                      Colors.black.withOpacity(0.3), // semi-transparent color
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.white, size: 24),
                          SizedBox(width: 10),
                          Text.rich(
                            TextSpan(
                              text: '28°C',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\nClear',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            Constant.windowLogo,
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 15),
                          Image.asset(
                            Constant.microsoftEdge,
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 15),
                          Image.asset(
                            Constant.outlookLogo,
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          TextButton(
                            onPressed: null,
                            child: Text(
                              "ENG",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          SizedBox(width: 15),
                          DateTimeWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.1,
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: EdgeInsets.zero,
            child: GridView.builder(
              itemCount: shortcutProperty.length,
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 150,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return ShortcutWidget(
                  onPressed: shortcutProperty[index].$4,
                  title: shortcutProperty[index].$1,
                  image: shortcutProperty[index].$2,
                  color: shortcutProperty[index].$3,
                  isFullScreen: index == 4,
                  badgeCount: index == 0 ? 4 : null,
                  isLabelVisible: index == 2 || index == 3,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

final shortcutProperty = [
  ("Projects", Constant.flutterLogo, const Color(0xffcee7fc), () {}),
  (
    "Resume",
    Constant.resumeLogo,
    Colors.white70,
    () {
      html.AnchorElement(href: Constant.resumeDownloadUrl)
        ..setAttribute('download', 'Okwharobo_Solomon_Resume.pdf')
        ..click();
    }
  ),
  (
    "Github",
    Constant.githubLogo,
    Colors.white70,
    () {
      html.window.open(Constant.githubUrl, "Monday Github URL");
    }
  ),
  (
    "LinkedIn",
    Constant.linkedinLogo,
    Colors.white,
    () {
      html.window.open(Constant.linkedinUrl, "Monday LinkedIn URL");
    }
  ),
  ("Fullscreen", Constant.fullScreenSvg, Colors.white54, () {}),
];

class ShortcutWidget extends StatelessWidget {
  const ShortcutWidget({
    super.key,
    this.onPressed,
    this.isFullScreen = false,
    required this.title,
    required this.image,
    required this.color,
    this.badgeCount,
    this.isLabelVisible = false,
  });

  final VoidCallback? onPressed;
  final String title;
  final String image;
  final Color color;
  final bool isFullScreen;
  final int? badgeCount;
  final bool isLabelVisible;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge.count(
            count: badgeCount != null ? badgeCount! : 0,
            isLabelVisible: badgeCount != null ? true : false,
            child: Badge(
              offset: const Offset(-40, 40),
              isLabelVisible: isLabelVisible,
              backgroundColor: Colors.transparent,
              label: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(
                  Constant.export,
                  height: 15,
                  width: 15,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: isFullScreen
                    ? SvgPicture.asset(image)
                    : Image.asset(
                        image,
                        height: 30,
                        width: 30,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// For formatting the date/time

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  late String _currentTime;
  late String _currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _formatTime(DateTime.now());
    _currentDate = _formatDate(DateTime.now());

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = _formatTime(DateTime.now());
      });
    });
  }

  // Format time
  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // date format
  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentTime,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          Text(
            _currentDate,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
