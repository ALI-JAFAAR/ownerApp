import 'package:flutter/material.dart';

import '../../main.dart';

class ICard26 extends StatefulWidget {
  final Color color;

  final String text;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;

  final TextStyle textStyle;
  final TextStyle text2Style;

  final bool enable56;

  ICard26({this.color = Colors.white,
    this.text = "", this.text2 = "", this.text3 = "", this.text4 = "",
    this.text5 = "", this.text6 = "",
    this.textStyle, this.text2Style, this.enable56 = true,
  });

  @override
  _ICard26State createState() => _ICard26State();
}

class _ICard26State extends State<ICard26>{

  var _textStyle = TextStyle(fontSize: 16);
  var _text2Style = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {

    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.text2Style != null)
      _text2Style = widget.text2Style;

    return InkWell(
        child: Container(
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: new BorderRadius.circular(theme.radius),
            border: Border.all(color: Colors.black.withAlpha(100)),
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.grey.withAlpha(100),
//                  spreadRadius: 2,
//                  blurRadius: 2,
//                  offset: Offset(2, 2), // changes position of shadow
//                ),
//              ]
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 12, top: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.text3, style: _textStyle, overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 10,),
                          Text(widget.text4, style: _text2Style, overflow: TextOverflow.ellipsis,),
                        ],
                      )
                  ),

                  if (widget.enable56)
                  Container(
                      margin: EdgeInsets.only(right: 12, top: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.text5, style: _textStyle, overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 10,),
                          Text(widget.text6, style: _text2Style, overflow: TextOverflow.ellipsis,),
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