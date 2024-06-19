import 'package:flutter/material.dart';

class OverlayManager {
  static bool isOverlayVisible = false;
  static final OverlayEntry _overlayEntry = OverlayEntry(
    builder: (context) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        alignment: Alignment.center,
        child: Image.asset('assets/image/loading.gif'),
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
