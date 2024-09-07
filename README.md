<!-- markdownlint-disable MD033 MD041 -->

A Flutter package that enables interaction with different regions of an SVG, allowing for a more engaging and dynamic user experience. It provides a way to define gesture detectors for specific regions of the SVG, making it possible to respond to user input and create interactive visualizations.

> **IMPORTANT**
> For now this package only uses \<path> in svg file see [regex](#regex) and svg file in *example/assets* on [github](https://github.com/HD16K/interactable_svg/tree/main/example/assets)

## Getting Started

In the `pubspec.yaml` of your **Flutter** project, add the following dependency:

```yaml
dependencies:
  ...
  interactive_svg_widget: ^1.0.0
```

In your library file add the following import:

```dart
import 'package:interactive_svg_widget/interactive_svg_widget.dart';
```

## Usage

By rendering SVG from asset folder:

```dart
        InteractiveViewer( //<- It is very useful to use InteractiveViewer with this package
              maxScale: 8,
              scaleEnabled: true,
              panEnabled: true,
              constrained: true,
              child: InteractiveSVGWidget.asset(
                gestureDetectorData: (region) => GestureDetectorData(
                  onLongPress: () {
                    showAboutDialog(context: context, children: [
                      Text('Region you pressed on: ${region.name}'),
                    ]);
                  },
                ),
                themeData: InteractiveSvgThemeData(
                  dotColor: Colors.purple,
                  selectedColor: Colors.teal.withOpacity(0.5),
                  strokeColor: Colors.yellow,
                  strokeWidth: 3.0,
                  dotRadius: 6,
                  textStyle: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
                key: mapKey,
                svgAssetPath: "assets/floor_map.svg",
                onTap: (region) {
                  setState(() {
                    selectedRegion = region;
                  });
                },
                regionColors: const {"st0": Colors.amber},
                width: double.infinity,
                height: double.infinity,
                isMultiSelectable: false,
                unSelectableId: "bg",
                centerDotEnable: true,
                centerTextEnable: true,
              ),
            ),
```

https://github.com/user-attachments/assets/f13ef28f-859d-4e91-b250-681d676f14c0

or by using string:

```dart
          InteractiveSVGWidget.string(
            svg: "<svg> ... </svg>",
            ...
          ),
```

---

To select a region without clicking on the box or clear the selection see the below code.

```dart
final GlobalKey<InteractiveSVGWidgetState> mapKey = GlobalKey();
InteractiveSVGWidget(key: mapKey,...)

mapKey.currentState?.toggleButton(region);
mapKey.currentState?.clearSelect();
```

---

## Regex

Also your SVG must follow the following pattern. For better understanding see the [example SVG](https://github.com/HD16K/interactable_svg/tree/main/example/assets).

```regex
'.* id="(.*)" name="(.*)".* class="(.*)".* d="(.*)"'
```

for example:
  \<path id="<mark>118</mark>" name="<mark>room 9</mark>" class="<mark>st0</mark>" d="<mark>M55 508h101.26v330H55Z</mark>" />;

## Contributing

Feel free to open an issue or submit a pull request. Also you can add request for a new feature in the [discussions](https://github.com/HD16K/interactable_svg/discussions/categories/ideas)

## Authors

* Updated package: [HD16K](https://github.com/HD16K)
* Original package: [Hussein Copol](https://github.com/HusseinCopol)
