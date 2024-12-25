import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class InfoOverlayManager {
  // Singleton instance
  static final InfoOverlayManager _instance = InfoOverlayManager._internal();

  factory InfoOverlayManager() {
    return _instance;
  }

  InfoOverlayManager._internal();

  OverlayEntry? _overlayEntry;

  void showInfoOverlay(BuildContext context, String message, Offset position,
      {double overlayWidth = 200}) {
    // Remove existing overlay if present
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: position.dy - 60, // Offset below the button
          left: position.dx - (overlayWidth / 2),
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: Container(
                  width: overlayWidth,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white70)),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // Insert the overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void hide() {
    _removeOverlay();
  }
}
