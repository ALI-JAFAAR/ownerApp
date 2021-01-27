import 'package:flutter/material.dart';

class IButton extends StatelessWidget {
  @required final Function() pressButton;
  final Color color;
  final Color colorText;
  final String text;
  final TextStyle textStyle;
  IButton({this.pressButton, this.text, this.color = Colors.grey, this.colorText = Colors.white, this.textStyle});

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(fontSize: 16);
    if (textStyle != null)
      _textStyle = textStyle;
    return RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: <Widget>[

              Expanded(
                child: Text(text, textAlign: TextAlign.center,
                    style: _textStyle
                ),
              ),
              Icon(Icons.navigate_next, color: colorText,)
            ],
          )
      ),
      onPressed: () {
        if (pressButton != null)
          pressButton();
      },
    )
    ;
  }
}