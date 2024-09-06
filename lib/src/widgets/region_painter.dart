import 'package:flutter/material.dart';

import '../models/interactive_svg_theme_data.dart';
import '../models/region.dart';
import '../size_controller.dart';

class RegionPainter extends CustomPainter {
  final InteractiveSvgThemeData themeData;
  final Region region;
  final bool centerDotEnable;
  final bool centerTextEnable;
  final String? unSelectableId;
  double _scale = 1.0;
  final sizeController = SizeController.instance();

  RegionPainter({
    required this.region,
    required this.themeData,
    this.centerDotEnable = false,
    this.centerTextEnable = false,
    this.unSelectableId,
  }) {
    pen = Paint()
      ..color = themeData.strokeColor
      ..strokeWidth = themeData.strokeWidth
      ..style = PaintingStyle.stroke;
    dotPen = Paint()
      ..color = themeData.dotColor
      ..style = PaintingStyle.fill;
  }

  late final Paint pen;
  late final Paint dotPen;
  @override
  void paint(Canvas canvas, Size size) {
    if (region.id == unSelectableId) {
      return;
    }

    final bounds = region.path.getBounds();
    _scale = sizeController.calculateScale(size);

    canvas.scale(_scale);

    if (centerDotEnable) {
      canvas.drawCircle(bounds.center, themeData.dotRadius, dotPen);
    }

    _TextSVGPainter(
      bounds: bounds,
      centerTextEnable: centerTextEnable,
      textStyle: themeData.textStyle,
      text: region.name,
    ).paint(canvas, size);

    canvas.drawPath(region.path, pen);
  }

  @override
  bool shouldRepaint(RegionPainter oldDelegate) => false;
}

class _TextSVGPainter extends CustomPainter {
  final bool centerTextEnable;
  final TextStyle textStyle;
  final String text;
  final Rect bounds;

  _TextSVGPainter({
    required this.bounds,
    required this.centerTextEnable,
    required this.textStyle,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final TextSpan span = TextSpan(style: textStyle, text: text);
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    if (centerTextEnable) {
      tp.paint(canvas, bounds.center.translate(-(tp.width / 2), 0));
    } else {
      tp.paint(canvas, bounds.center);
    }
  }

  @override
  bool shouldRepaint(covariant _TextSVGPainter oldDelegate) => oldDelegate.text != text;
}

class ColorRegionPainter extends CustomPainter {
  final bool isSelected;
  final Color? boxColor;
  final Region region;
  final String? unSelectableId;
  final InteractiveSvgThemeData themeData;
  late final Paint boxPen;
  late final Paint selectedPen;
  final sizeController = SizeController.instance();
  double _scale = 1.0;

  ColorRegionPainter({
    required this.unSelectableId,
    required this.region,
    required this.isSelected,
    required this.boxColor,
    required this.themeData,
  }) {
    selectedPen = Paint()
      ..color = themeData.selectedColor
      ..style = PaintingStyle.fill;
    boxPen = Paint()
      ..color = boxColor ?? Colors.blue.shade500
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (region.id == unSelectableId) {
      return;
    }
    _scale = sizeController.calculateScale(size);
    canvas.scale(_scale);
    if (boxColor != null && !isSelected) {
      canvas.drawPath(region.path, boxPen);
    }
    if (isSelected) {
      canvas.drawPath(region.path, selectedPen);
    }
  }

  @override
  bool shouldRepaint(covariant ColorRegionPainter oldDelegate) => isSelected != oldDelegate.isSelected;
  @override
  bool? hitTest(Offset position) {
    final double inverseScale = sizeController.inverseOfScale(_scale);
    return region.path.contains(position.scale(inverseScale, inverseScale));
  }
}
