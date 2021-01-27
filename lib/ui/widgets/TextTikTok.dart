import 'dart:ui';

import 'package:flutter/material.dart';

class TextTikTok extends CustomPainter {
  final double offset;
  final String text;
  TextTikTok({this.offset, this.text});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    var rect = Offset.zero & size;
    canvas.clipRect(rect);
    List<LineMetrics> width = _printText(text, size.width, canvas, Offset(offset, 0), 0);
    if (width != null && width.length != 0){
      var t = offset+width[0].width;
      while(t < 0){
        t = t+width[0].width + (size.width/4);
        _printText(text, size.width, canvas, Offset(t, 0), width[0].width);
      }
      t = t+width[0].width + (size.width/4);
      _printText(text, size.width, canvas, Offset(t, 0), width[0].width);
      //dprint("t=$t textlength=${width[0].width} offset=$offset text2=${t-width[0].width} text3=${t+(size.width/4)}");
    }
    canvas.restore();
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  _printText(String _text, double t, var canvas, Offset x, double width){
    if (width != 0)
      if (x.dx < -(width*3))
        return;
    TextSpan span4 = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 14), text: _text);
    final textPainter4 = TextPainter(text: span4, textDirection: TextDirection.ltr, textAlign: TextAlign.left, maxLines: 1);
    textPainter4.layout(minWidth: double.maxFinite, maxWidth: double.maxFinite);
    textPainter4.paint(canvas, x);
    return textPainter4.computeLineMetrics();
  }
}
