import 'package:flutter/material.dart';
import 'package:delivery_owner/ui/widgets/ibutton2.dart';

import '../../main.dart';

// ignore: must_be_immutable
class ICard22 extends StatefulWidget {
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
  final String text8;

  final TextStyle textStyle;
  final TextStyle text2Style;
  final TextStyle text3Style;
  final TextStyle text4Style;
  final TextStyle text5Style;
  final TextStyle text6Style;
  final TextStyle text7Style;
  final TextStyle text8Style;

  final String button1Text;
  final TextStyle button1Style;
  final String button2Text;
  final TextStyle button2Style;
  final bool button1Enable;
  final bool button2Enable;

  final String button3Text;
  final TextStyle button3Style;
  final String button4Text;
  final TextStyle button4Style;
  final bool button34Enable;

  final Function(String id) callback;
  final Function(String id) callbackButton1;
  final Function(String id) callbackButton2;
  final Function(String id) callbackButton3;
  final Function(String id) callbackButton4;

  final Color button3Color;
  final Color button4Color;

  String curbsidePickup;

  ICard22({this.color = Colors.white, this.colorRoute = Colors.black,
    this.id = "", this.curbsidePickup = "",
    this.text = "", this.text2 = "", this.text3 = "", this.text4 = "",
    this.text5 = "", this.text6 = "", this.text7 = "", this.text8 = "",
    this.button1Text = "", this.button2Text = "",
    this.button3Text = "", this.button4Text = "",
    this.textStyle, this.text2Style, this.text3Style, this.text4Style,
    this.text5Style, this.text6Style, this.text7Style, this.text8Style,
    this.button1Enable = true,  this.button2Enable = true, this.button34Enable = false,
    this.button1Style, this.button2Style,
    this.button3Style, this.button4Style,
    this.callback, this.callbackButton1, this.callbackButton2, this.callbackButton3, this.callbackButton4,
    this.button3Color = Colors.grey, this.button4Color = Colors.grey,
  });

  @override
  _ICard22State createState() => _ICard22State();
}

class _ICard22State extends State<ICard22>{

  var _textStyle = TextStyle(fontSize: 16);
  var _text2Style = TextStyle(fontSize: 14);
  var _text3Style = TextStyle(fontSize: 14);
  var _text4Style = TextStyle(fontSize: 14);
  var _text5Style = TextStyle(fontSize: 14);
  var _text6Style = TextStyle(fontSize: 14);
  var _text7Style = TextStyle(fontSize: 14);
  var _text8Style = TextStyle(fontSize: 14);
  var _button1Style = TextStyle(fontSize: 14);
  var _button2Style = TextStyle(fontSize: 14);
  var _button3Style = TextStyle(fontSize: 14);
  var _button4Style = TextStyle(fontSize: 14);

  _onButton1(){
    widget.callbackButton1(widget.id);
  }

  _onButton2(){
    widget.callbackButton2(widget.id);
  }

  _onButton3(){
    widget.callbackButton3(widget.id);
  }

  _onButton4(){
    widget.callbackButton4(widget.id);
  }

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
    if (widget.button1Style != null)
      _button1Style = widget.button1Style;
    if (widget.button2Style != null)
      _button2Style = widget.button2Style;
    if (widget.button3Style != null)
      _button3Style = widget.button3Style;
    if (widget.button4Style != null)
      _button4Style = widget.button4Style;
    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id);
        },
        child: Container(
          margin: EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 5),
          decoration: BoxDecoration(
              color: widget.color,
            border: Border.all(color: Colors.black.withOpacity(0.1)),
              borderRadius: new BorderRadius.circular(15),
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
                      //Expanded(child: Text(widget.text4, style: _text4Style, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),),
                    ],)),

              Container(
                  margin: EdgeInsets.only(left: 12, top: 12, right: 12),
                  child: Text(widget.text4, style: _text4Style, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
              ),

              SizedBox(height: 10,),

              if (widget.curbsidePickup == "true")
                Container(
                    margin: EdgeInsets.only(left: 12, top: 8, right: 12),
                    child: Row(
                      children: [
                        Text(strings.get(235), style: _text6Style, overflow: TextOverflow.ellipsis,),  // "Curbside Pickup",
                      ],
                    )
                ),

              if (widget.curbsidePickup != "true")
              Container(
                  margin: EdgeInsets.only(left: 12, top: 8, right: 12),
                  child: Row(
                    children: [
                      Text(widget.text5, style: _text5Style, overflow: TextOverflow.ellipsis,),     // distance
                      SizedBox(width: 10,),
                      Text(widget.text6, style: _text6Style, overflow: TextOverflow.ellipsis,),
                    ],
                  )
              ),
              if (widget.curbsidePickup != "true")
              SizedBox(height: 5,),
              if (widget.curbsidePickup != "true")
              Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Icon(Icons.room, size: 15,),
                      SizedBox(width: 10,),
                      Expanded(child: Text(widget.text7, style: _text7Style, overflow: TextOverflow.ellipsis,)),
                      if (widget.button1Enable)
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: IButton2(
                            color: widget.colorRoute,
                            text: widget.button2Text,
                            textStyle: _button2Style,
                            pressButton: _onButton1
                          ),
                        ),
                    ],
                  )
              ),
              if (widget.curbsidePickup != "true")
                if (!widget.button1Enable)
                  SizedBox(height: 5,),
              if (widget.curbsidePickup != "true")
              Container(
                margin: EdgeInsets.only(left: 18, top: 0, right: 18),
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              if (widget.curbsidePickup != "true")
              Container(
                margin: EdgeInsets.only(left: 18, top: 5, right: 18),
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              if (widget.curbsidePickup != "true")
              Container(
                margin: EdgeInsets.only(left: 18, top: 5, right: 18),
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              if (widget.curbsidePickup != "true")
              if (!widget.button2Enable)
                SizedBox(height: 5,),
              if (widget.curbsidePickup != "true")
              Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Icon(Icons.navigation, size: 15,),
                      SizedBox(width: 10,),
                      Expanded(child: Text(widget.text8, style: _text8Style, overflow: TextOverflow.ellipsis,)),
                      if (widget.button2Enable)
                        Container(
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: IButton2(
                              color: widget.colorRoute,
                              text: widget.button1Text,
                              textStyle: _button1Style,
                              pressButton: _onButton2
                          ),
                        )
                    ],
                  )
              ),

              if (widget.curbsidePickup != "true")
                SizedBox(height: 10,),

              if (widget.curbsidePickup != "true")
                  if (widget.button34Enable)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: IButton2(
                          color: widget.button3Color,
                          text: widget.button3Text,
                          textStyle: _button3Style,
                          pressButton: _onButton3
                      ),
                    ),

                    SizedBox(width: 10,),

                    Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: IButton2(
                          color: widget.button4Color,
                          text: widget.button4Text,
                          textStyle: _button4Style,
                          pressButton: _onButton4
                      ),
                    )
                  ],),

              SizedBox(height: 10,),

          ],
          ),


        ));
  }

}