import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:floom/src/fire_colors.dart';

class FloomFire extends StatefulWidget {
  @override
  _FloomFireState createState() => _FloomFireState();
}

class _FloomFireState extends State<FloomFire> {
  List<int> fire = [];
  List<TableRow> tableRows = [];
  List<List<Widget>> widgets = [];
  final fireWidth = 5;
  final fireHeight = 20;
  Table fireTabl;
  Timer _timer;
  bool _debug = false;

  @override
  void initState() {
    super.initState();
    _createFirestructure();
    _createFireSource();

    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer f) {
      _calculateFirePropagation();
    });
  }

  void updateFireIntensity(int currentPixel) {
    int belowPixel = currentPixel + fireWidth;
    if (belowPixel < fireHeight * fireWidth) {
      Random r = Random();
      int decay = r.nextInt(3).floor();
      int belowPixelIntensity = fire[belowPixel];
      int newIntensityFire =
          belowPixelIntensity - decay > 0 ? belowPixelIntensity - decay : 0;
      int wind = currentPixel - decay >= 0 ? currentPixel - decay : 0;
      setState(() {
        fire[wind] = newIntensityFire;
      });
    }
  }

  void _createFireWidgets() {
    widgets = [];
    for (var row = 0; row < fireHeight; row++) {
      widgets.add([]);
      for (var column = 0; column < fireWidth; column++) {
        int index = column + (fireWidth * row);
        widgets[row].add(fireBlock(fire[index]));
      }
    }
  }

  void _createFirestructure() {
    int totalFirePixels = fireHeight * fireWidth;
    for (var i = 0; i < totalFirePixels; i++) {
      fire.add(0);
    }
  }

  void _createFireSource() {
    for (var column = 0; column < fireWidth; column++) {
      int overPixel = fireHeight * fireWidth;
      int pixelIndex = (overPixel - fireWidth) + column;
      setState(() {
        fire[pixelIndex] = 36;
      });
    }
  }

  Widget fireBlock(int index) {
    return Container(
      child: _debug ? Text(index.toString()) : Container(),
      width: MediaQuery.of(context).size.width / fireWidth,
      height: (MediaQuery.of(context).size.height / 2) / fireHeight - 1,
      decoration: BoxDecoration(
        color: FIRE_COLORS[fire[index]],
      ),
    );
  }

  void _calculateFirePropagation() {
    for (var column = 0; column < fireWidth; column++) {
      for (var row = 0; row < fireHeight; row++) {
        int pixelindex = column + (fireWidth * row);
        updateFireIntensity(pixelindex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _createFireSource();
    _createFireWidgets();
    return Table(
      children: widgets.map((f) {
        return TableRow(children: f);
      }).toList(),
    );
  }
}
