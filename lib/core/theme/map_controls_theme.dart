import 'dart:ui';

import 'package:flutter/material.dart';

class MapControlsTheme extends ThemeExtension<MapControlsTheme> {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color dividerColor;
  final double shadowOpacity;
  final double height;
  final double borderRadius;

  const MapControlsTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.dividerColor,
    required this.shadowOpacity,
    this.height = 46,
    this.borderRadius = 18,
  });

  @override
  MapControlsTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? dividerColor,
    double? shadowOpacity,
    double? height,
    double? borderRadius,
  }) {
    return MapControlsTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      dividerColor: dividerColor ?? this.dividerColor,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  MapControlsTheme lerp(ThemeExtension<MapControlsTheme>? other, double t) {
    if (other is! MapControlsTheme) return this;

    return MapControlsTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      shadowOpacity: lerpDouble(shadowOpacity, other.shadowOpacity, t)!,
      height: lerpDouble(height, other.height, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
    );
  }
}
