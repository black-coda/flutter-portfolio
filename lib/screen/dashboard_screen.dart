import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:portfolio/constant/constant.dart';
import 'package:portfolio/widget/info_overlay_widget.dart';
// import 'dart:html' as html;
import "package:universal_html/html.dart" as html;

import '../widget/date_time_widget.dart';
import '../widget/shortcut_widget.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final OverlayPortalController _windowStartController =
      OverlayPortalController();
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
                  color: Colors.black.withOpacity(0.3),
                  // semi-transparent color
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
                      CenterTaskBarDisplay(
                          windowStartController: _windowStartController),
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

class CenterTaskBarDisplay extends StatefulWidget {
  const CenterTaskBarDisplay({super.key, required this.windowStartController});

  final OverlayPortalController windowStartController;
  @override
  State<CenterTaskBarDisplay> createState() => _CenterTaskBarDisplayState();
}

class _CenterTaskBarDisplayState extends State<CenterTaskBarDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  final GlobalKey _windowStartButtonGlobalKey = GlobalKey();
  double _windowStartHeight = 220.0;
  final finalWindowStartHeight = 518.0;

  GlobalKey callMeKey = GlobalKey();
  GlobalKey emailMeKey = GlobalKey();
  GlobalKey myWebsiteKey = GlobalKey();

  void _showHelpOverlay(
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            final RenderBox renderBox =
                _windowStartButtonGlobalKey.currentContext?.findRenderObject()
                    as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            log('Widget Position: ${position.dx}, ${position.dy}');
            widget.windowStartController.toggle();
            if (_windowStartHeight == finalWindowStartHeight) {
              setState(() {
                _windowStartHeight = 220.0;
              });
              isExpandedNotifier.value = false;
            }
          },
          child: OverlayPortal(
            controller: widget.windowStartController,
            overlayChildBuilder: (context) {
              return Positioned(
                bottom: 70,
                left: MediaQuery.sizeOf(context).width * 0.37,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 450.0,
                      height: _windowStartHeight,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <ShortcutWidget>[
                                        ShortcutWidget(
                                          title: "Projects",
                                          image: Constant.flutterLogo,
                                          color: const Color(0xffcee7fc),
                                          onPressed: () {},
                                          badgeCount: 4,
                                        ),
                                        ShortcutWidget(
                                            title: "Resume",
                                            image: Constant.resumeLogo,
                                            color: Colors.white70,
                                            onPressed: () {
                                              html.AnchorElement(
                                                  href: Constant
                                                      .resumeDownloadUrl)
                                                ..setAttribute('download',
                                                    'Okwharobo_Solomon_Resume.pdf')
                                                ..click();
                                            }),
                                        ShortcutWidget(
                                            title: "Github",
                                            image: Constant.githubLogo,
                                            color: Colors.white70,
                                            onPressed: () {
                                              html.window.open(
                                                  Constant.githubUrl,
                                                  "Monday Github URL");
                                            }),
                                        ShortcutWidget(
                                            title: "LinkedIn",
                                            image: Constant.linkedinLogo,
                                            color: Colors.white,
                                            onPressed: () {
                                              html.window.open(
                                                  Constant.linkedinUrl,
                                                  "Monday LinkedIn URL");
                                            }),
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: isExpandedNotifier,
                                      builder: (context, value, child) {
                                        log('Value: $value');
                                        return Visibility(
                                          visible: value,
                                          child: Container(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Column(
                                              children: [
                                                _buildDivider(),
                                                const InformationHeaderWidget(
                                                  leadingText: "Phone",
                                                  trailingText:
                                                      "+234 916 7638 610",
                                                ),
                                                _buildDivider(),
                                                const InformationHeaderWidget(
                                                  leadingText: "Email",
                                                  trailingText:
                                                      "mondaysolomon01@gmail.com",
                                                ),
                                                _buildDivider(),
                                                const InformationHeaderWidget(
                                                  leadingText: "Address",
                                                  trailingText:
                                                      "Lagos, Nigeria",
                                                ),
                                                _buildDivider(),
                                                const InformationHeaderWidget(
                                                  leadingText: "Website",
                                                  trailingText:
                                                      "https://monday-solomon.netlify.app",
                                                ),
                                                _buildDivider(),
                                                const InformationHeaderWidget(
                                                  leadingText: "Experience",
                                                  trailingText: "1+ years",
                                                ),
                                                const InformationHeaderWidget(
                                                  leadingText: "Skills",
                                                  trailingText:
                                                      "Flutter, Dart\nUI/UX\nPython, FastAPI, Django\nMachine Learning (Beginner)\nMathematics\nGit",
                                                ),
                                                _buildDivider(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 72,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0)),
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(
                                    sigmaX: 20.0, sigmaY: 20.0),
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          Constant.profileImageUrl,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      const Text.rich(
                                        TextSpan(
                                          text: 'Solomon Okwharobo',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '\nFlutter Developer',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      isExpandedNotifier.value
                                          ? OverflowBar(
                                              children: [
                                                MouseRegion(
                                                  key: callMeKey,
                                                  onHover: (onHover) {
                                                    _showHelpOverlay(
                                                      context,
                                                      "Call Me",
                                                      callMeKey,
                                                      80,
                                                    );
                                                  },
                                                  onExit: (onExist) {
                                                    InfoOverlayManager().hide();
                                                  },
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(Icons.call,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                MouseRegion(
                                                  key: emailMeKey,
                                                  onHover: (onHover) {
                                                    _showHelpOverlay(
                                                      context,
                                                      "Send me an email",
                                                      emailMeKey,
                                                      154,
                                                    );
                                                  },
                                                  onExit: (onExit) {
                                                    InfoOverlayManager().hide();
                                                  },
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.message,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                MouseRegion(
                                                  key: myWebsiteKey,
                                                  onHover: (onHover) {
                                                    _showHelpOverlay(
                                                      context,
                                                      "Visit my website",
                                                      myWebsiteKey,
                                                      154,
                                                    );
                                                  },
                                                  onExit: (onExit) {
                                                    InfoOverlayManager().hide();
                                                  },
                                                  child: IconButton(
                                                    onPressed: () {
                                                      //   TODO: Implement
                                                      if (kIsWeb) {
                                                        html.window.open(
                                                            Constant
                                                                .personalWebsiteUrl,
                                                            "Personal Website");
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.language,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _windowStartHeight =
                                                          220.0;
                                                    });
                                                    isExpandedNotifier.value =
                                                        false;
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _windowStartHeight =
                                                      finalWindowStartHeight;
                                                });
                                                isExpandedNotifier.value = true;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      const Color(0xff9bbcdc),
                                                  backgroundColor:
                                                      const Color(0xff0d2550)),
                                              child: const Text("See more"),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Image.asset(
              Constant.windowLogo,
              height: 30,
              width: 30,
              key: _windowStartButtonGlobalKey,
            ),
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () {},
          child: Image.asset(
            Constant.microsoftEdge,
            height: 30,
            width: 30,
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () {},
          child: Image.asset(
            Constant.outlookLogo,
            height: 30,
            width: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() => Divider(
        color: Colors.white.withOpacity(0.3),
        indent: 20,
        endIndent: 20,
      );
}

class InformationHeaderWidget extends StatelessWidget {
  const InformationHeaderWidget({
    super.key,
    required this.leadingText,
    required this.trailingText,
  });

  final String leadingText;
  final String trailingText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leadingText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              trailingText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
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
  if (kIsWeb)
    (
      "Fullscreen",
      Constant.fullScreenSvg,
      Colors.white54,
      () {
        html.document.documentElement!.requestFullscreen();
      }
    ),
];

final isExpandedNotifier = ValueNotifier<bool>(false);
