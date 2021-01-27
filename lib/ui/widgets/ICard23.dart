import 'package:flutter/material.dart';

class ICard23 extends StatefulWidget {
  final Color color;

  final String text;
  final String text2;
  final String text3;
  final String text4;

  final TextStyle textStyle;
  final TextStyle text2Style;
  final TextStyle text3Style;
  final TextStyle text4Style;
  final TextStyle text5Style;

  ICard23({this.color = Colors.white,
    this.text = "", this.text2 = "", this.text3 = "", this.text4 = "",
    this.textStyle, this.text2Style, this.text3Style, this.text4Style,
    this.text5Style,
  });

  @override
  _ICard23State createState() => _ICard23State();
}

class _ICard23State extends State<ICard23>{

  var _textStyle = TextStyle(fontSize: 16);
  var _text2Style = TextStyle(fontSize: 14);
  var _text3Style = TextStyle(fontSize: 14);
  var _text4Style = TextStyle(fontSize: 14);

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

    return InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
//          decoration: BoxDecoration(
//              color: widget.color,
//              borderRadius: new BorderRadius.circular(15),
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.grey.withAlpha(100),
//                  spreadRadius: 2,
//                  blurRadius: 2,
//                  offset: Offset(2, 2), // changes position of shadow
//                ),
//              ]
//          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 12, top: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 10,),
                          Text(widget.text2, style: _text2Style, overflow: TextOverflow.ellipsis,),
                        ],
                      )
                  ),

                  Container(
                      margin: EdgeInsets.only(right: 12, top: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(widget.text3, style: _text3Style, overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 10,),
                          Text(widget.text4, style: _text4Style, overflow: TextOverflow.ellipsis,),
                        ],
                      )
                  ),

                ],),

              SizedBox(height: 10,),


            ],
          )),


        );
  }

}