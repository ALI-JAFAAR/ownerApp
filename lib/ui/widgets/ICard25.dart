import 'dart:math';

import 'package:flutter/material.dart';

class ICard25 extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  final List<double> data;
  final List<double> data2;
  final String title;
  final List<String> bottomTexts;
  final List<String> bottomTexts2;
  final String actionText;
  final String actionText2;
  final TextStyle titleStyle;
  final TextStyle bottomTextStyle;
  final TextStyle action;
  final Color colorLine;
  final Color shadowColor;

  final Color colorTimeIcon;
  final Color colorAction;
  ICard25({this.color = Colors.white, this.width = 100, this.height = 100,
    this.title = "", this.bottomTexts, this.colorAction = Colors.green,
    this.titleStyle, this.bottomTextStyle, this.actionText = "", this.action, this.actionText2 = "",
    this.colorTimeIcon = Colors.black, this.data, this.colorLine = Colors.white, this.shadowColor = Colors.white,
    this.bottomTexts2, this.data2,
  });

  @override
  _ICard25State createState() => _ICard25State();
}

class _ICard25State extends State<ICard25>{

  var _titleStyle = TextStyle(fontSize: 16);
  var  _bottomTextStyle = TextStyle(fontSize: 14);
  var _actionStyle = TextStyle(fontSize: 14);
  var _actionType = 1;

  _getVerticalText(){
    var _items = List<Widget>();

    if (_actionType == 1) {
      if (widget.data.isNotEmpty) {
        var temp = List<double>();
        for (var t in widget.data)
          temp.add(t);
        temp.sort((a, b) => a.compareTo(b));
        _items.add(Text(temp[temp.length - 1].toStringAsFixed(0)));
        if (temp.length > 3)
          _items.add(Text(temp[temp.length ~/ 2].toStringAsFixed(0)));
        _items.add(Text(temp[0].toStringAsFixed(0)));
      }
    }else{
      if (widget.data2.isNotEmpty) {
        var temp = List<double>();
        for (var t in widget.data2)
          temp.add(t);
        temp.sort((a, b) => a.compareTo(b));
        _items.add(Text(temp[temp.length - 1].toStringAsFixed(0)));
        if (temp.length > 3)
          _items.add(Text(temp[temp.length ~/ 2].toStringAsFixed(0)));
        _items.add(Text(temp[0].toStringAsFixed(0)));
      }
    }

    return _items;
  }

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.titleStyle != null)
      _titleStyle = widget.titleStyle;
    if (widget.bottomTextStyle != null)
      _bottomTextStyle = widget.bottomTextStyle;
    if (widget.action != null)
      _actionStyle = widget.action;

    List<Point> _x = [];

    Widget _bottemTexts = Container();

    var _bottomTextByType = widget.bottomTexts;
    if (_actionType == 2){
      _bottomTextByType = widget.bottomTexts2;
    }
    if (_bottomTextByType != null) {
      var _listBottomTexts = List<Widget>();
      for (var word in _bottomTextByType)
        _listBottomTexts.add(Text(word, style: _bottomTextStyle));
      _bottemTexts = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _listBottomTexts,);
    }

    var _dateByType = widget.data;
    if (_actionType == 2){
      _dateByType = widget.data2;
    }
    bool _startNull = true;
    if (_dateByType != null){
      var max = 0.0;
      for (var dataitem in _dateByType)
        if (dataitem > max)
          max = dataitem;
      var min = max;
      for (var dataitem in _dateByType) {
        if (dataitem == 0 && _startNull)
          continue;
        if (dataitem < min)
          min = dataitem;
        _startNull = false;
      }
      var oneStep = (widget.width-110)/(_dateByType.length-1);
      var _startXForPoint = 0.0;
      var onePercent = (widget.height*0.5-20)/100;
      _startNull = true;
      for (var dataitem in _dateByType) {
        var onep = ((max - min) / 100);
        var d = (dataitem-min) / onep;
        var margin = 10 + onePercent * d;
        if (dataitem != 0) {
          _x.add(Point(_startXForPoint, (widget.height * 0.5 - margin) - 2));
          _startNull = false;
        }else {
          if (!_startNull)
            _x.add(Point(_startXForPoint, (widget.height * 0.5 - margin)-2));
        }
        _startXForPoint += oneStep;
      }
    }

    var _actionTextByType = widget.actionText;
    if (_actionType == 2){
      _actionTextByType = widget.actionText2;
    }

    return Container(

      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      width: widget.width,
      height: widget.height-20,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: new BorderRadius.circular(15),
      ),
      child: Stack(
        children: <Widget>[
          Hero(
              tag: _id,
              child: Container(
                width: widget.width-10,
                height: widget.height*0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: Container(

                  ),
                ),
              )
          ),

          Container(
            margin: EdgeInsets.only(left: 5, top: widget.height*0.2, bottom: widget.height*0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _getVerticalText(),
            ),

          ),

          Container(
              padding: EdgeInsets.only(left: 20),
              width: widget.width,
              height: widget.height,
              margin: EdgeInsets.only(left: 20, right: 20, top: widget.height*0.05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(widget.title, style: _titleStyle, overflow: TextOverflow.ellipsis,),
                  ),
                  SizedBox(height: 5,),
                  InkWell(
                      onTap: () {
                        if (_actionType == 1)
                          _actionType = 2;
                        else
                          _actionType = 1;
                        setState(() {});
                      }, // needed
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                            color: widget.colorAction,
                            child: Text(_actionTextByType, textAlign: TextAlign.center, style: _actionStyle,)),
                      ))
                ],
              )),

          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(bottom: 10),
                child: _bottemTexts,
              )
          ),


          Container(
            padding: EdgeInsets.only(left: 50),
            margin: EdgeInsets.only(top: widget.height*0.2),
            width: widget.width,
            height: widget.height*0.5,
            child: CustomPaint(
              painter: Painter(_x, widget.colorLine, widget.shadowColor, widget.data),
              size: Size.infinite,
            ),
          ),

        ],
      ),

    );
  }

}

class Painter extends CustomPainter {

  List<Point> _x;
  Color colorLine;
  Color shadowColor;
  List<double> data;
  Painter(this._x, this.colorLine, this.shadowColor, this.data);

  @override
  void paint(Canvas canvas, Size size) {

    var paintLineShadow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = shadowColor
      ..isAntiAlias = true
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

    var paintLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = colorLine
      ..isAntiAlias = true;

    var paintDotsWhite = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = Colors.white
      ..isAntiAlias = true;

    var paintDotsBack = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = colorLine
      ..isAntiAlias = true;

    var point0X = 0.0;
    var point0Y = 0.0;
    var point1X = 0.0;
    var point1Y = 0.0;
    var startX = 0.0;
    var startY = 0.0;

    final path = Path();
    bool first = true;
    for (var point in _x){
      if (first){
        point0X = point.x;
        point0Y = point.y;
        path.moveTo(point0X-10, point0Y);
        path.lineTo(point0X, point0Y);
        point1X = point.x;
        point1Y = point.y;
        startX = point1X;
        startY = point1Y;
        first = false;
        continue;
      }else{
        point0X = point1X;
        point0Y = point1Y;
      }
      point1X = point.x;
      point1Y = point.y;
      var x = startX+(point1X-point0X)/2;
      var cx = startX+(point1X-point0X)*0.30;
      var y  = startY+(point1Y-point0Y)/2;
      path.quadraticBezierTo(cx, point0Y, x, y);
      cx = startX+(point1X-point0X)*0.60;
      path.quadraticBezierTo(cx, point1Y, point1X, point1Y);
      startX = point1X;
      startY = point1Y;
    }
    path.lineTo(point1X+10, point1Y);

    canvas.save();
    canvas.translate(0, 5);
    canvas.drawPath(path, paintLineShadow);
    canvas.restore();

    canvas.drawPath(path, paintLine);

    for (var point in _x)
      canvas.drawLine(Offset(point.x, point.y), Offset(point.x,point.y), paintDotsBack);

    for (var point in _x) {
      canvas.drawLine(Offset(point.x, point.y), Offset(point.x, point.y), paintDotsWhite);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}



