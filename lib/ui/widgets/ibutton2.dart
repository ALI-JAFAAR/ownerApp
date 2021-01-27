import 'package:flutter/material.dart';

class IButton2 extends StatelessWidget {
  @required final Function() pressButton;
  final Color color;
  final String text;
  final TextStyle textStyle;
  final double padding;
  IButton2({this.pressButton, this.text = "", this.color = Colors.grey, this.textStyle, this.padding = 20});

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(fontSize: 16);
    if (textStyle != null)
      _textStyle = textStyle;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: padding, right: padding, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: new BorderRadius.circular(5),
          ),
          child: Text(text, style: _textStyle,),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0) ),
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (pressButton != null)
                    pressButton();
                }, // needed
              )),
        )
      ],
    );
  }
}