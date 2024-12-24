import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/constant/constant.dart';

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
      child: Container(
        padding: EdgeInsets.zero,
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
                  decoration: const BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.zero),
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
      ),
    );
  }
}
