import 'package:flutter/material.dart';

class IList1 extends StatelessWidget {
  final String imageAsset;
  final String text;
  final TextStyle textStyle;
  final Color imageColor;
  IList1({this.imageAsset, this.text = "", this.textStyle, this.imageColor});

  @override
  Widget build(BuildContext context) {
    Widget _imageAsset = Container();
    if (imageAsset != null)
      _imageAsset = Image.asset(imageAsset,
        fit: BoxFit.contain, color: imageColor,);
    TextStyle _textStyle = TextStyle();
    if (textStyle != null)
      _textStyle = textStyle;

    return Row(children: <Widget>[
      UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: _imageAsset
          )),
      SizedBox(width: 10,),
      Expanded(child: Text(text, style: _textStyle, overflow: TextOverflow.ellipsis,)),
    ],
    );
  }
}