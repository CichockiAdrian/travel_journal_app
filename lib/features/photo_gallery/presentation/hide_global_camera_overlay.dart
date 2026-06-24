import 'package:flutter/material.dart';

import 'global_camera_visibility_controller.dart';

class HideGlobalCameraOverlay extends StatefulWidget {
  const HideGlobalCameraOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<HideGlobalCameraOverlay> createState() =>
      _HideGlobalCameraOverlayState();
}

class _HideGlobalCameraOverlayState extends State<HideGlobalCameraOverlay> {
  @override
  void initState() {
    super.initState();
    GlobalCameraVisibilityController.hide();
  }

  @override
  void dispose() {
    GlobalCameraVisibilityController.show();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
