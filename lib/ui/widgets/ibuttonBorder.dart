import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IButtonBorder extends StatelessWidget {
  @required final Function() pressButton;
  final Function(int) pressButtonWithId;
  final int id;
  final Color color;
  final String text;
  final TextStyle textStyle;
  final Color colorBackgroud;
  final Widget icon;
  final bool border;
  IButtonBorder({this.pressButton, this.text, this.color, this.textStyle, this.colorBackgroud, this.icon, this.pressButtonWithId, this.id, this.border});

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.grey;
    if (color != null)
      _color = color;
    var _textStyle = TextStyle(fontSize: 16, color: _color);
    if (textStyle != null)
      _textStyle = textStyle;
    Widget _row = Container(width: 0,);
    if (icon != null)
      _row = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            height: 25,
            width: 25,
            child: icon,
          ),
          Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Flexible(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle
              ))),

        ],
      );
    else
      _row = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Text(text,
                  overflow: TextOverflow.fade,
                  style: _textStyle
              )),
        ],
      );
    Color _colorBackgroud = Colors.transparent;
    if (colorBackgroud != null)
      _colorBackgroud = colorBackgroud;


    var _colorBorder = _color;
    if (border != null && !border)
      _colorBorder = Colors.transparent;

    return Container(
        child: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: _colorBackgroud,
            border: Border.all(color: _colorBorder),
            borderRadius: new BorderRadius.circular(10),
          ),

          child: _row,

        ),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                splashColor: _color.withAlpha(140),
                onTap: (){
                  if (pressButton != null)
                    pressButton();
                  if (pressButtonWithId != null && id != null)
                    pressButtonWithId(id);
                }, // needed
              )),
        )
      ],
    ));
  }
}