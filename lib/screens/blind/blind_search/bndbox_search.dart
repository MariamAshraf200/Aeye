import 'dart:async';
// import 'package:speech_to_text/speech_to_text.dart' as stt ;
import 'package:divergent/screens/blind/live_labelling/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;

class BndBoxSearch extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;
  final String search;

  BndBoxSearch(this.results, this.previewH, this.previewW, this.screenH,
      this.screenW, this.model, this.search);

  @override
  _BndBoxSearch createState() => new _BndBoxSearch();
}

class _BndBoxSearch extends State<BndBoxSearch> {
  final FlutterTts flutterTts = FlutterTts();
  var _timer;

  @override
  void initState() {
    _timer = new Timer.periodic(
        Duration(milliseconds: 2000), (Timer timer) => _speak());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  late String speak;
  late String prevString;

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBoxes() {
      return widget.results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;

        if (widget.screenH / widget.screenW >
            widget.previewH / widget.previewW) {
          scaleW = widget.screenH / widget.previewH * widget.previewW;
          scaleH = widget.screenH;
          var difW = (scaleW - widget.screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = widget.screenW / widget.previewW * widget.previewH;
          scaleW = widget.screenW;
          var difH = (scaleH - widget.screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        const focal_length = 4.33;
        var dist = (((focal_length * w) / x).abs().floor() / 30.48).floor();
        var textTalk = "";

        // ignore: non_constant_identifier_names
        if (re['detectedClass'].toString().toLowerCase() ==
            widget.search.toLowerCase()) {
          textTalk =
              "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}% with ${dist}feet";
          speak = "i found a ${re["detectedClass"]} with $dist feet";
        }

        // text_talk ="";
        // speak =""; //the detected class

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3.0,
              ),
            ),
            child: ((re["confidenceInClass"] > 0.50))
                ? Container(
                    child: Text(
                      textTalk,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(),
          ),
        );
      }).toList();
    }

    List<Widget> _renderStrings() {
      double offset = -10;
      return widget.results.map((re) {
        offset = offset + 14;
        print(re["label"]);
        return Positioned(
          left: 10,
          top: offset,
          width: widget.screenW,
          height: widget.screenH,
          child: Text(
            "${re["label"]} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: widget.model == mobilenet ? _renderStrings() : _renderBoxes(),
    );
  }

  Future _speak() async {
    // ignore: unnecessary_statements
    /*  speak != null && speak != prevString
        ? await flutterTts.speak(speak)
        : Future.delayed(
            const Duration(seconds: 2), () => flutterTts.speak(prevString));
            */
    await flutterTts.speak(speak);
    speak = null!;
    // speak != null && speak != prevString ? await flutterTts.speak(speak) : Future.delayed(const Duration(seconds :2),()=>flutterTts.speak(prevString));
    //prevString = speak;
  }
  // await Future.delayed(const Duration(seconds: 2),speak(speak)
}
