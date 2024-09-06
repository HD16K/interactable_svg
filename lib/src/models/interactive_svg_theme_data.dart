import 'package:flutter/material.dart';

/// A class used to define the visual properties of the [InteractiveSVGWidget].
class InteractiveSvgThemeData {
  /// The color of the dot in the center of the region.
  ///
  /// Defaults to [Colors.red].
  final Color dotColor;

  /// The radius of the dot in the center of the region.
  ///
  /// Defaults to `3.0`.
  final double dotRadius;

  /// The color of the region when it is selected.
  ///
  /// Defaults to [Colors.blue].
  final Color selectedColor;

  /// The color of the region when it is not selected.
  ///
  /// Defaults to [Colors.black45].
  final Color strokeColor;

  /// The width of the region when it is not selected.
  ///
  /// Defaults to `1.0`.
  final double strokeWidth;

  /// The style of the text in the center of the region.
  ///
  /// Defaults to a [TextStyle.new] with color: [Colors.black].
  final TextStyle textStyle;

  const InteractiveSvgThemeData({
    this.dotColor = Colors.red,
    this.textStyle = const TextStyle(color: Colors.black),
    this.selectedColor = Colors.blue,
    this.strokeColor = Colors.black45,
    this.strokeWidth = 1.0,
    this.dotRadius = 3.0,
  });

  InteractiveSvgThemeData copyWith({
    Color? dotColor,
    TextStyle? textStyle,
    Color? selectedColor,
    Color? strokeColor,
    double? strokeWidth,
    double? selectedStrokeWidth,
    double? dotRadius,
  }) =>
      InteractiveSvgThemeData(
        dotColor: dotColor ?? this.dotColor,
        textStyle: textStyle ?? this.textStyle,
        selectedColor: selectedColor ?? this.selectedColor,
        strokeColor: strokeColor ?? this.strokeColor,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        dotRadius: dotRadius ?? this.dotRadius,
      );

  @override
  bool operator ==(covariant InteractiveSvgThemeData other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other.dotColor == dotColor &&
        other.textStyle == textStyle &&
        other.selectedColor == selectedColor &&
        other.strokeColor == strokeColor &&
        other.strokeWidth == strokeWidth &&
        other.dotRadius == dotRadius;
  }

  @override
  int get hashCode => Object.hashAll([dotColor, textStyle, selectedColor, strokeColor, strokeWidth, dotRadius]);

  @override
  String toString() {
    return 'InteractiveSvgThemeData('
        'dotColor: $dotColor, '
        'textStyle: $textStyle, '
        'selectedColor: $selectedColor, '
        'strokeColor: $strokeColor, '
        'strokeWidth: $strokeWidth, '
        'dotRadius: $dotRadius'
        ')';
  }
}
