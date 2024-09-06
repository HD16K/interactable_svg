import 'package:flutter/material.dart';
import 'package:interactive_svg_widget/interactive_svg_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intractable SVG Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final GlobalKey<InteractiveSVGWidgetState> mapKey = GlobalKey();

class _MyHomePageState extends State<MyHomePage> {
  Region? selectedRegion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Interactable SVG Example"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.50,
            decoration: BoxDecoration(border: Border.all(color: Colors.black), color: Colors.grey.withOpacity(0.2)),
            child: InteractiveViewer(
              maxScale: 8,
              scaleEnabled: true,
              panEnabled: true,
              constrained: true,
              child: InteractiveSVGWidget.asset(
                gestureDetectorData: (region) => GestureDetectorData(
                  onLongPress: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => Dialog(child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Region you pressed on: ${region.name}'),
                      ),)
                    );
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
          ),
          Text('selected room: ${selectedRegion?.name}'),
        ],
      ),
    );
  }
}
