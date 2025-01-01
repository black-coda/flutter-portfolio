import 'package:flutter/material.dart';
import 'package:portfolio/utility_method.dart';
import 'package:portfolio/widget/shortcut_widget.dart';

class DesktopIcon extends StatelessWidget {
  const DesktopIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: EdgeInsets.zero,
        child: GridView.builder(
          itemCount: UtilityService.shortcutProperty.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 120,
            // crossAxisSpacing: 10,
            crossAxisSpacing: 0.0,
          ),
          itemBuilder: (context, index) {
            return ShortcutWidget(
              onPressed: UtilityService.shortcutProperty[index].$4,
              title: UtilityService.shortcutProperty[index].$1,
              image: UtilityService.shortcutProperty[index].$2,
              color: UtilityService.shortcutProperty[index].$3,
              isFullScreen: index == 4,
              badgeCount: index == 0 ? 4 : null,
              isLabelVisible: index == 2 || index == 3,
            );
          },
        ),
      ),
    );
  }
}
