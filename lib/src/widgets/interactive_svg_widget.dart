import 'dart:async';

import 'package:flutter/material.dart';

import '../models/gesture_detector_data.dart';
import '../models/interactive_svg_theme_data.dart';
import '../models/region.dart';
import '../parser.dart';
import '../size_controller.dart';
import 'region_painter.dart';

/// A interactive widget that it is render from SVG file or string.
///
/// This widget is based on the [CustomPaint] widget and uses the [RegionPainter]
/// to paint the regions of the SVG on the canvas.
///
/// The [InteractiveSVGWidget] widget is can bring to 'life' svg.
/// By that it means that the svg elements (for now only `<path>`) can be interacted with.
///
/// Note: In widget tree it will be shown as [Container] due to fact that it is painted by [CustomPaint].
///
/// The best effect is to use InteractiveSVGWidget in combination with [InteractiveViewer].
///
/// Example:
/// ```dart
/// InteractiveViewer(
///   maxScale: 8,
///   scaleEnabled: true,
///   panEnabled: true,
///   constrained: true,
///   child: InteractiveSVGWidget.asset(
///     gestureDetectorData: GestureDetectorData(),
///     themeData: InteractiveSvgThemeData(
///       dotColor: Colors.blue,
///       selectedColor: Colors.red.withOpacity(0.5),
///       strokeColor: Colors.blue,
///       strokeWidth: 2.0,
///       textStyle: const TextStyle(fontSize: 12, color: Colors.black),
///     ),
///     key: mapKey,
///     svgAssetPath: "assets/floor_map.svg",
///     onChanged: (region) {
///       setState(() {
///         selectedRegion = region;
///       });
///     },
///     toggleEnable: true,
///     isMultiSelectable: false,
///     unSelectableId: "bg",
///     centerDotEnable: true,
///     centerTextEnable: true,
///   ),
/// ),
/// ```
class InteractiveSVGWidget extends StatefulWidget {
  /// The set of settings used to configure the theme
  final InteractiveSvgThemeData themeData;

  /// Whether to paind the dot in the center of the region
  final bool centerDotEnable;

  /// Whether to center the text in the center of the region
  final bool centerTextEnable;

  /// The height of the widget
  final double height;

  /// The width of the widget
  final double width;

  /// Whether to allow multiple regions to be selected
  final bool isMultiSelectable;

  /// A function that will be called whether a region is selected/unselected
  final void Function(Region region) onTap;

  ///The reason why this is a function is because it simplifies the creation of GestureDetector functions when you want to use the Region inside them
  /// GestureDetectorData is a set of functions that can be used to customize the GestureDetector
  final GestureDetectorData Function(Region region)? gestureDetectorData;

  /// A Map where the key is the class name (in svg `<path class="">`) of the region and the value is the color of the region
  /// Example: `{"down": Colors.red, "up": Colors.blue}`
  final Map<String, Color>? regionColors;
  final String svgData;

  /// The id of the region that will not be selectable.
  final String? unSelectableId;

  /// Create an instance of [InteractiveSVGWidget] with the given [svgAssetPath].
  ///
  /// Example:
  /// ```dart
  /// svgAssetPath: "assets/floor_map.svg"
  /// ```
  const InteractiveSVGWidget.asset({
    required String svgAssetPath,
    required this.onTap,
    this.gestureDetectorData,
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.themeData = const InteractiveSvgThemeData(),
    this.unSelectableId,
    this.centerDotEnable = false,
    this.centerTextEnable = true,
    this.regionColors,
    this.isMultiSelectable = false,
  })  : _isString = false,
        svgData = svgAssetPath,
        super(key: key);

  /// Create an instance of [InteractiveSVGWidget] with the given [svg].
  ///
  /// Example:
  /// ```dart
  /// svg: '''<svg ...>
  /// <path id="110" name="room 1" class="st0" d="M863.74 602h101.26v236H863.74Z" /> ;
  /// ...
  /// </svg>'''
  /// ```
  const InteractiveSVGWidget.string({
    required String svg,
    required this.onTap,
    this.gestureDetectorData,
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.themeData = const InteractiveSvgThemeData(),
    this.regionColors,
    this.unSelectableId,
    this.centerDotEnable = false,
    this.centerTextEnable = true,
    this.isMultiSelectable = false,
  })  : _isString = true,
        svgData = svg,
        super(key: key);

  final bool _isString;

  @override
  InteractiveSVGWidgetState createState() => InteractiveSVGWidgetState();
}

class InteractiveSVGWidgetState extends State<InteractiveSVGWidget> {
  late final Size _mapSize;
  final List<Region> _selectedRegions = [];
  final List<Region> _regionList = [];

  final _sizeController = SizeController.instance();
  List<Region> get selectedRegions => _selectedRegions;
  Size get mapSize => _mapSize;
  @override
  void initState() {
    super.initState();
    _loadRegionList();
  }

  void clearSelect() {
    setState(_selectedRegions.clear);
  }

  Future<void> _loadRegionList() async {
    late final List<Region> list;
    if (widget._isString) {
      list = Parser.instance().svgToRegionListString(widget.svgData);
    } else {
      list = await Parser.instance().svgToRegionList(widget.svgData);
    }
    setState(() {
      _regionList
        ..clear()
        ..addAll(list);
      _mapSize = _sizeController.mapSize;
    });
  }

  void toggleButton(Region region) {
    if (region.id != widget.unSelectableId) {
      setState(() {
        if (_selectedRegions.contains(region)) {
          _selectedRegions.remove(region);
        } else {
          if (widget.isMultiSelectable) {
            _selectedRegions.add(region);
          } else {
            _selectedRegions
              ..clear()
              ..add(region);
          }
        }
        widget.onTap(region);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final region in _regionList)
          _RegionWidget(
            themeData: widget.themeData,
            centerDotEnable: widget.centerDotEnable,
            centerTextEnable: widget.centerTextEnable,
            height: widget.height,
            width: widget.width,
            gestureDetectorData: widget.gestureDetectorData ?? (region) => const GestureDetectorData.empty(),
            region: region,
            mapSize: _mapSize,
            regionColor: widget.regionColors?[region.className],
            unSelectableId: widget.unSelectableId,
            onSelected: toggleButton,
            isSelected: _selectedRegions.contains(region),
          ),
      ],
    );
  }
}

class _RegionWidget extends StatelessWidget {
  final InteractiveSvgThemeData themeData;
  final bool centerDotEnable;
  final bool centerTextEnable;
  final double height;
  final double width;
  final GestureDetectorData Function(Region region) gestureDetectorData;
  final Color? regionColor;
  final String? unSelectableId;
  final void Function(Region region) onSelected;
  final bool isSelected;
  final Region region;
  final Size mapSize;
  const _RegionWidget({
    required this.themeData,
    required this.centerDotEnable,
    required this.centerTextEnable,
    required this.height,
    required this.width,
    required this.gestureDetectorData,
    required this.region,
    required this.mapSize,
    required this.onSelected,
    required this.isSelected,
    Key? key,
    this.regionColor,
    this.unSelectableId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return gestureDetectorData(region).build(
      onTap: () => onSelected(region),
      child: CustomPaint(
        isComplex: true,
        willChange: true,
        painter: ColorRegionPainter(
          unSelectableId: unSelectableId,
          region: region,
          isSelected: isSelected,
          boxColor: regionColor,
          themeData: themeData,
        ),
        child: CustomPaint(
          isComplex: false,
          willChange: false,
          foregroundPainter: RegionPainter(
            region: region,
            themeData: themeData,
            centerDotEnable: centerDotEnable,
            centerTextEnable: centerTextEnable,
            unSelectableId: unSelectableId,
          ),
          child: Container(
            width: width,
            height: height,
            constraints: BoxConstraints(maxWidth: mapSize.width, maxHeight: mapSize.height),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
