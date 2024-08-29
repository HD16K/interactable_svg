import 'package:flutter/material.dart';

import '../models/region.dart';
import '../size_controller.dart';

class RegionPainter extends CustomPainter {
  final Region region;
  final List<Region> selectedRegions;
  final Color? strokeColor;
  final Color? selectedColor;
  final Color? dotColor;
  final double? strokeWidth;
  final bool centerDotEnable;
  final bool centerTextEnable;
  final TextStyle? textStyle;
  final String? unSelectableId;
  final Color? boxColor;
  final sizeController = SizeController.instance();

  double _scale = 1.0;

  RegionPainter({
    required this.region,
    required this.selectedRegions,
    this.selectedColor,
    this.strokeColor,
    this.dotColor,
    this.centerDotEnable = false,
    this.centerTextEnable = false,
    this.textStyle,
    this.strokeWidth,
    this.unSelectableId,
    this.boxColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = strokeColor ?? Colors.black45
      ..strokeWidth = strokeWidth ?? 1.0
      ..style = PaintingStyle.stroke;
    final boxPen = Paint()
      ..color = boxColor ?? Colors.blue.shade500
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final selectedPen = Paint()
      ..color = selectedColor ?? Colors.blue
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    final redDot = Paint()
      ..color = dotColor ?? Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final bounds = region.path.getBounds();

    _scale = sizeController.calculateScale(size);
    canvas.scale(_scale);
    if (boxColor != null) {
      canvas.drawPath(region.path, boxPen);
    }
    if (selectedRegions.contains(region)) {
      canvas.drawPath(region.path, selectedPen);
    }
    if (centerDotEnable && region.id != unSelectableId) {
      canvas.drawCircle(bounds.center, 3.0, redDot);
    }
    if (region.id != unSelectableId) {
      TextSpan span = TextSpan(style: textStyle ?? const TextStyle(color: Colors.black), text: region.name);
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      if (centerTextEnable) {
        tp.paint(canvas, bounds.center.translate(-(tp.width / 2), 0));
      } else {
        tp.paint(canvas, bounds.center);
      }
    }
    canvas.drawPath(region.path, pen);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    double inverseScale = sizeController.inverseOfScale(_scale);
    return region.path.contains(position.scale(inverseScale, inverseScale));
  }
}
