<!-- markdownlint-disable MD041 -->
## 1.0.0

**Package:**

* Added new classes InteractiveSVGThemeData for setting theme of interactiveSVGWidget and GestureDetectorData which is a copy of GestureDetectorData properties that you can set
* Added documentation
* Fixed svg map file

**InteractiveSvgWidget**:

* Region Painter has been separated into smaller custom painters and the way of building this whole widget has been changed making the widget much more optimized
* Renamed onChanged ➡️ onTap
* Deleted holdButton

**Other:**

* Updated README, CHANGELOG
* Updated example

## 0.1.2

**Package:**

* Changed environment constraints
* Moved files to be directly under lib
* Updated README
* Changed lints to my own custom
* Changed way of accesing SizeController
* Renamed selectedRegion -> selectedRegions
* Removed Future return from svgToRegionListString() function

**InteractiveSVGWidget:**

* Removed network constructor
* Added more default values

## 0.1.1

* Changed package name

## 0.1.0

* Fixed property centerTextEnable, now it actually center text
* Renamed centerTextStyle ➡️ textStyle
* Added new property boxColor that allow to color each region separately using as keys class name (in svg) of path element
* Updated dependencies and config files in example
* Updated README, CHANGELOG and LICENSE

## 0.0.7

* Updated the example

## 0.0.6

* Updated http dependency to 1.1.0 to fix flutter web bug

## 0.0.5

* Added  InteractableSvg.string

## 0.0.4

* Added  InteractableSvg.network

## 0.0.3

* Added access to toggleButton and holdButton in InteractableSvgState

## 0.0.2

* Added  multiple select

## 0.0.1

* Initial release
