import 'dart:ui';

/// A class representing a region in the SVG.
///
/// A region is a closed path (a path that has a start and end point that are
/// the same) in the SVG. It is used to define the shapes of the items in the
/// SVG.
///
/// The [id] property is used to identify the region. The [name] property is
/// used to set the name of the region. The [path] property is used to set the
/// path of the region. The [className] property is used to set the class name
/// of the region.
///
/// The [Region] class is used by the [InteractiveSVGWidget] class to define the
/// regions in the SVG that are interactive.
class Region {
  /// The id of the region.
  final String id;

  /// The name of the region.
  final String name;

  /// The path of the region.
  final Path path;

  /// The class name of the region.
  final String? className;

  /// Creates a [Region] object.
  const Region({
    required this.id,
    required this.name,
    required this.path,
    required this.className,
  });
  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;
  //   if(other.runtimeType != runtimeType) return false;
  //   return other is Region && other.id == id && other.name == name && other.path == path && other.className == className;
  // }
  @override
  bool operator ==(covariant Region other) {
    if (identical(this, other)) return true;
    return other.id == id && other.name == name && other.path == path && other.className == className;
  }
  
  @override
  int get hashCode => Object.hashAll([id, name, path, className]);
}
