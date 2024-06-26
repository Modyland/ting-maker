import 'package:flutter/material.dart';
import 'package:ting_maker/widget/common_style.dart';

class OverlayManager {
  static bool isOverlayVisible = false;
  static final OverlayEntry _overlayEntry = OverlayEntry(
    builder: (context) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black54,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: pointColor,
            strokeCap: StrokeCap.round,
          ));
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
