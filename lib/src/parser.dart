import 'package:flutter/services.dart' show rootBundle;
import 'package:svg_path_parser/svg_path_parser.dart';

import 'constant.dart';
import 'models/region.dart';
import 'size_controller.dart';

class Parser {
  static final Parser _singleton = Parser._init();
  factory Parser.instance() => _singleton;
  Parser._init();

  final sizeController = SizeController.instance();

  Future<List<Region>> svgToRegionList(String svgAddress) async {
    final svgMain = await rootBundle.loadString(svgAddress);

    final List<Region> regionList = [];

    final regExp = RegExp(mapRegexp, multiLine: true, caseSensitive: false, dotAll: false);

    regExp.allMatches(svgMain).forEach((regionData) {
      final region = Region(
          id: regionData.group(1)!,
          name: regionData.group(2)!,
          className: regionData.group(3),
          path: parseSvgPath(regionData.group(4)!));
      //log(region.path.getBounds().toString());
      sizeController.addBounds(region.path.getBounds());
      regionList.add(region);
    });
    return regionList;
  }

  List<Region> svgToRegionListString(String svgAddress) {
    final svgMain = svgAddress;

    final List<Region> regionList = [];

    final regExp = RegExp(mapRegexp, multiLine: true, caseSensitive: false, dotAll: false);
    regExp.allMatches(svgMain).forEach((regionData) {
      final region = Region(
          id: regionData.group(1)!,
          name: regionData.group(2)!,
          className: regionData.group(3),
          path: parseSvgPath(regionData.group(4)!));

      sizeController.addBounds(region.path.getBounds());
      regionList.add(region);
    });
    return regionList;
  }
}
