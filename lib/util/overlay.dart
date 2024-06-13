import 'package:flutter/material.dart';
import 'package:ting_maker/widget/common_style.dart';

class OverlayManager {
  static bool isOverlayVisible = false;
  static final OverlayEntry _overlayEntry = OverlayEntry(
    builder: (context) {
      return Container(
        color: pointColor.withAlpha(54),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white),
      );
    },
  );

  static void showOverlay(BuildContext context) {
    if (!isOverlayVisible) {
      Overlay.of(context).insert(_overlayEntry);
      isOverlayVisible = true;
    }
  }

  static void hideOverlay() {
    if (isOverlayVisible) {
      _overlayEntry.remove();
      isOverlayVisible = false;
    }
  }
}
