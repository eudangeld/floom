import 'dart:async';
import 'dart:math';

import 'package:floom/src/custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:floom/src/fire_colors.dart';
import 'package:flutter/scheduler.dart';

class FloomFire extends StatefulWidget {
  @override
  _FloomFireState createState() => _FloomFireState();
}

class _FloomFireState extends State<FloomFire> {
  List<int> fire = [];
  List<TableRow> tableRows = [];
  List<Widget> widgets = [];
  final fireWidth = 100;
  final fireHeight = 100;
  Table fireTabl;
  Timer _timer;
  bool _debug = false;
  Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _createFirestructure();

    _ticker = Ticker((elapsed) => _calculateFirePropagation());
    _ticker.start();

    // _timer = Timer.periodic(Duration(seconds: 60 ~/ 1000), (Timer f) {
    //   _calculateFirePropagation();
    // });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
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
    int total = fireHeight * fireWidth;
    for (var row = 0; row < fireHeight; row++) {
      for (var column = 0; column < fireWidth; column++) {
        int index = column + (fireWidth * row);
        widgets.add(fireBlock(fire[index]));
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
    // print(fire[index]);

    return Container(
      child: _debug
          ? Stack(
              children: <Widget>[
                Positioned(
                  bottom: 1,
                  child: Text(
                    index.toString(),
                    style: TextStyle(color: Colors.yellow),
                  ),
                )
              ],
            )
          : Container(),
      width: MediaQuery.of(context).size.width / fireWidth,
      height: (MediaQuery.of(context).size.height / 2) / fireHeight - 1,
      // color: FIRE_COLORS[fire[8]],
      decoration: BoxDecoration(
          color: FIRE_COLORS[index],
          border: Border.all(color: FIRE_COLORS[index])),
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
    _calculateFirePropagation();
    // _createFireWidgets();

    return Container(
      height: fireHeight.toDouble(),
      child: CustomPaint(
        size: Size(fireWidth.toDouble(), fireHeight.toDouble()),
        painter: FloomPainter(fire, fireWidth, fireHeight),
      ),
    );

    // return GridView.count(
    //   crossAxisCount: fireWidth,
    //   // childAspectRatio: 1.0,
    //   children: widgets.map((f) {
    //     return GridTile(child: f);
    //   }).toList(),
    // );
  }
}
