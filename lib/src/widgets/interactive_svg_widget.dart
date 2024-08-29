import 'package:flutter/material.dart';

import '../models/region.dart';
import '../parser.dart';
import '../size_controller.dart';
import 'region_painter.dart';

class InteractiveSVGWidget extends StatefulWidget {
  final Key? key;
  final bool centerDotEnable;
  final bool centerTextEnable;
  final TextStyle? centerTextStyle;
  final Color? dotColor;
  final double? height;
  final bool isMultiSelectable;
  final void Function(Region region) onChanged;

  /// The key is name of class in the svg
  final Map<String, Color>? regionColors;

  final Color? selectedColor;
  final Color? strokeColor;
  final double? strokeWidth;
  final String svgData;
  final bool? toggleEnable;
  final String? unSelectableId;
  final double? width;

  const InteractiveSVGWidget.asset({
    this.key,
    required String svgAssetPath,
    required this.onChanged,
    this.width,
    this.height,
    this.strokeColor,
    this.strokeWidth,
    this.selectedColor,
    this.dotColor,
    this.unSelectableId,
    this.centerDotEnable = false,
    this.centerTextEnable = true,
    this.centerTextStyle,
    this.toggleEnable,
    this.isMultiSelectable = false,
    this.regionColors,
  })  : _isString = false,
        svgData = svgAssetPath,
        super(key: key);

  const InteractiveSVGWidget.string({
    this.key,
    required String svg,
    required this.onChanged,
    this.width,
    this.height,
    this.strokeColor,
    this.strokeWidth,
    this.selectedColor,
    this.dotColor,
    this.unSelectableId,
    this.centerDotEnable = false,
    this.centerTextEnable = true,
    this.centerTextStyle,
    this.toggleEnable,
    this.isMultiSelectable = false,
    this.regionColors,
  })  : _isString = true,
        svgData = svg,
        super(key: key);

  final bool _isString;

  @override
  InteractiveSVGWidgetState createState() => InteractiveSVGWidgetState();
}

class InteractiveSVGWidgetState extends State<InteractiveSVGWidget> {
  Size? mapSize;
  List<Region> selectedRegion = [];

  final List<Region> _regionList = [];
  final _sizeController = SizeController.instance();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _loadRegionList();
    });
  }

  void clearSelect() {
    setState(() {
      selectedRegion.clear();
    });
  }

  void toggleButton(Region region) {
    if (region.id != widget.unSelectableId) {
      setState(() {
        if (selectedRegion.contains(region)) {
          selectedRegion.remove(region);
        } else {
          if (widget.isMultiSelectable) {
            selectedRegion.add(region);
          } else {
            selectedRegion.clear();
            selectedRegion.add(region);
          }
        }
        widget.onChanged(region);
      });
    }
  }

  void holdButton(Region region) {
    if (region.id != widget.unSelectableId) {
      setState(() {
        if (widget.isMultiSelectable) {
          selectedRegion.add(region);
          widget.onChanged.call(region);
        } else {
          selectedRegion.clear();
          selectedRegion.add(region);

          widget.onChanged(region);
        }
      });
    }
  }

  _loadRegionList() async {
    late final List<Region> list;
    if (widget._isString) {
      list = await Parser.instance.svgToRegionListString(widget.svgData);
    } else {
      list = await Parser.instance.svgToRegionList(widget.svgData);
    }

    _regionList.clear();
    setState(() {
      _regionList.addAll(list);
      mapSize = _sizeController.mapSize;
    });
  }

  Widget _buildStackItem(Region region) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () => (widget.toggleEnable ?? false) ? toggleButton(region) : holdButton(region),
      child: CustomPaint(
        isComplex: true,
        foregroundPainter: RegionPainter(
          region: region,
          selectedRegions: selectedRegion,
          dotColor: widget.dotColor,
          selectedColor: widget.selectedColor,
          strokeColor: widget.strokeColor,
          centerDotEnable: widget.centerDotEnable,
          centerTextEnable: widget.centerTextEnable,
          textStyle: widget.centerTextStyle,
          strokeWidth: widget.strokeWidth,
          boxColor: widget.regionColors?[region.className],
          unSelectableId: widget.unSelectableId,
        ),
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? double.infinity,
          constraints: BoxConstraints(maxWidth: mapSize?.width ?? 0, maxHeight: mapSize?.height ?? 0),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final region in _regionList) _buildStackItem(region),
      ],
    );
  }
}
