import 'package:flutter/material.dart';

class IButton3 extends StatelessWidget {
  @required final Function() pressButton;
  final Color color;
  final String text;
  final double height;
  final TextStyle textStyle;
  final bool onlyBorder;
  IButton3({this.pressButton, this.text = "", this.color = Colors.grey, this.textStyle, this.height = 45, this.onlyBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
          borderRadius: new BorderRadius.circular(5),
        ),
        child: Stack(
      children: <Widget>[
        Container(
          height: height,
          width: double.maxFinite,
          child: Center(child: Text(text, style: textStyle, textAlign: TextAlign.center,)
          ),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0) ),
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (pressButton != null)
                    pressButton();
                }, // needed
              )),
        )
      ],
    ));
  }
}