# interactive SVG widget

## Getting Started

In the `pubspec.yaml` of your **Flutter** project, add the following dependency:

```yaml
dependencies:
  ...
  interactive_svg_widget: ^0.1.2
```

In your library file add the following import:

```dart
import 'package:interactive_svg_widget/interactive_svg_widget.dart';

```

## Usage

Basic usage (rendering SVG from asset folder):

```dart
        InteractiveViewer(
          scaleEnabled: true,
          panEnabled: true,
          constrained: true,
          child:InteractiveSVGWidget.asset(
            svgAssetPath: "assets/floor_map.svg",
            onChanged: (region) {
              setState(() {
                selectedRegion = region;

              });
            },

            width: double.infinity,
            height: double.infinity,
            toggleEnable: true,
            isMultiSelectable: false,
            dotColor: Colors.black,
            selectedColor: Colors.red.withOpacity(0.5),
            strokeColor: Colors.blue,
            unSelectableId: "bg",
            centerDotEnable:true ,
            centerTextEnable:true ,
            strokeWidth: 2.0,
            textStyle: const TextStyle(fontSize: 12,color: Colors.black),


          ),
        )
```

String usage (rendering SVG from a String):

```dart
          InteractiveSVGWidget.string(
            svg: "<svg> </svg>",
          
            .
            .
          ),
        
```

To select a region without clicking on the SVG see the below code. For better understanding check the example.

```dart
final GlobalKey<InteractiveSVGWidgetState> key = GlobalKey();
InteractiveSVGWidget(
      key: mapKey,...)

key.currentState?.toggleButton(region);
key.currentState?.holdButton(region);
```

---

## Regex

Also your SVG must follow the following pattern.For better understanding see the example SVG.

```regex
'.* id="(.*)" name="(.*)".* class="(.*)".* d="(.*)"'
```

for example:
  \<path id="<mark>118</mark>" name="<mark>room 9</mark>" class="<mark>st0</mark>" d="<mark>M55 508h101.26v330H55Z</mark>" />;

---

## Properties

| props             |             types              |                                 description                                  |
| :---------------- | :----------------------------: | :--------------------------------------------------------------------------: |
| key               |             `Key?`             |                                                                              |
| svg/svgAssetPath  |            `String`            |                Address of an SVG like  "assets/floor_map.svg"                |
| width             |           `double?`            |                 SVG width. Default value is double.infinity                  |
| height            |           `double?`            |                 SVG height. Default value is double.infinity                 |
| strokeColor       |            `Color?`            |                         Color of the region borders                          |
| selectedColor     |            `Color?`            |                         Color of the selected region                         |
| strokeWidth       |           `double?`            |                         Width of the region borders                          |
| toggleEnable      |            `bool?`             |                  Region selecting act as like toggle button                  |
| isMultiSelectable |             `bool`             |                       select multiple regions at once                        |
| onChanged         | `void Function(Region region)` |                   Returns new region value when it changed                   |
| unSelectableId    |           `String?`            |                  Makes that region wi that id non selective                  |
| centerDotEnable   |             `bool`             |                   place a dot in the center of the region                    |
| centerTextEnable  |             `bool`             |             place name of the region at the center of the region             |
| textStyle         |          `TextStyle?`          |                         Style of name of the region                          |
| dotColor          |            `Color?`            |                 Color of the dot in the center of the region                 |
| regionColors      |     `Map<String, Color>?`      | Set Color for region by using as key class property (in svg) of path element |

## Authors

* Original package: [Hussein Copol](https://github.com/HusseinCopol)
* Updated package: [HD16K](https://github.com/HD16K)
