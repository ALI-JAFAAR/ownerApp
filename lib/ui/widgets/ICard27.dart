import 'package:flutter/material.dart';

class ICard27 extends StatefulWidget {
  final Color color;
  final Color colorRoute;
  final String id;

  final String text;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;
  final String text7;

  final TextStyle textStyle;
  final TextStyle text2Style;
  final TextStyle text3Style;
  final TextStyle text4Style;
  final TextStyle text5Style;
  final TextStyle text6Style;
  final TextStyle text7Style;

  final Function(String id) callback;

  final bool balloon;
  final Color balloonColor;
  final String balloonText;
  final TextStyle balloonStyle;

  ICard27({this.color = Colors.white, this.colorRoute = Colors.black,
    this.id = "",
    this.text = "", this.text2 = "", this.text3 = "", this.text4 = "",
    this.text5 = "", this.text6 = "", this.text7 = "",
    this.textStyle, this.text2Style, this.text3Style, this.text4Style,
    this.text5Style, this.text6Style, this.text7Style,
    this.callback,
    this.balloon = false, this.balloonColor = Colors.black, this.balloonText = "", this.balloonStyle
  });

  @override
  _ICard27State createState() => _ICard27State();
}

class _ICard27State extends State<ICard27>{

  var _textStyle = TextStyle(fontSize: 16);
  var _text2Style = TextStyle(fontSize: 14);
  var _text3Style = TextStyle(fontSize: 14);
  var _text4Style = TextStyle(fontSize: 14);
  var _text5Style = TextStyle(fontSize: 14);
  var _text6Style = TextStyle(fontSize: 14);
  var _text7Style = TextStyle(fontSize: 14);
  var _balloonStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {

    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.text2Style != null)
      _text2Style = widget.text2Style;
    if (widget.text3Style != null)
      _text3Style = widget.text3Style;
    if (widget.text4Style != null)
      _text4Style = widget.text4Style;
    if (widget.text5Style != null)
      _text5Style = widget.text5Style;
    if (widget.text6Style != null)
      _text6Style = widget.text6Style;
    if (widget.text7Style != null)
      _text7Style = widget.text7Style;
    if (widget.text6Style != null)
      _text7Style = widget.text7Style;
    if (widget.balloonStyle != null)
      _balloonStyle = widget.balloonStyle;


    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id);
        },
        child: Stack(
          children:[
            Container(
              margin: EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 5),
              decoration: BoxDecoration(
                color: widget.color,
                border: Border.all(color: Colors.black.withOpacity(0.1)),
                borderRadius: new BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

              Container(
                  margin: EdgeInsets.only(left: 12, top: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis,),
                      Text(widget.text3, style: _text3Style, overflow: TextOverflow.ellipsis,),
                    ],)),

                Container(
                margin: EdgeInsets.only(left: 12, top: 12, right: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.text2, style: _text2Style, overflow: TextOverflow.ellipsis,),
                      Expanded(child: Text(widget.text4, style: _text4Style, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),),
                    ],)),

                  SizedBox(height: 10,),

                  Container(
                      margin: EdgeInsets.only(left: 12, top: 8),
                      child: Row(
                        children: [
                          Text(widget.text5, style: _text5Style, overflow: TextOverflow.ellipsis,),     // distance
                          SizedBox(width: 10,),
                          Text(widget.text6, style: _text6Style, overflow: TextOverflow.ellipsis,),
                        ],
                      )
                  ),
                  SizedBox(height: 5,),
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Icon(Icons.room, size: 15,),
                          SizedBox(width: 10,),
                          Expanded(child: Text(widget.text7, style: _text7Style, overflow: TextOverflow.ellipsis,)),
                        ],
                      )
                  ),

                  SizedBox(height: 10,),

                ],
              ),
            ),

            if (widget.balloon)
            Positioned.fill(
                child: Container(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.balloonColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                  child: Text(widget.balloonText, style: _balloonStyle,),
                ),
              )),

          ],
        ));
  }

}