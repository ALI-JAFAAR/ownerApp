import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_owner/ui/widgets/ILabelIcon.dart';
import 'package:delivery_owner/ui/widgets/iline.dart';
import 'package:flutter/material.dart';

class ICard1FileCaching extends StatelessWidget {
  final Color color;
  final String title;
  final Color colorProgressBar;
  final TextStyle titleStyle;
  final String date;
  final TextStyle dateStyle;
  final String text;
  final TextStyle textStyle;
  final String userAvatar;
  final double rating;
  ICard1FileCaching({this.color, this.text, this.textStyle, this.title, this.titleStyle,  this.colorProgressBar = Colors.black,
    this.date, this.dateStyle, this.userAvatar, this.rating = 5});

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.grey;
    if (color != null)
      _color = color;
    var _text = "";
    if (text != null)
      _text = text;
    var _title = "";
    if (title != null)
      _title = title;
    var _date = "";
    if (date != null)
      _date = date;
    var _titleStyle = TextStyle(fontSize: 16);
    if (titleStyle != null)
      _titleStyle = titleStyle;
    var _textStyle = TextStyle(fontSize: 16);
    if (textStyle != null)
      _textStyle = textStyle;
    var _dateStyle = TextStyle(fontSize: 16);
    if (dateStyle != null)
      _dateStyle = dateStyle;

    var _avatar = Container();
    try {
      _avatar = Container(
        width: 30,
        height: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(backgroundColor: colorProgressBar,),
              imageUrl: userAvatar,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ),
      );
    } catch(_){

    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _avatar,
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_title, style: _titleStyle,),
                    Row(
                      children: <Widget>[
                        UnconstrainedBox(
                            child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset("assets/date.png",
                                    fit: BoxFit.contain
                                )
                            )),
                        SizedBox(width: 10,),
                        Text(_date, style: _dateStyle, textAlign: TextAlign.left,),
                      ],
                    )
                  ],
                ),
              ),

              ILabelIcon(text: rating.toStringAsFixed(1), color: Colors.white, colorBackgroud: _color,
                icon: Icon(Icons.star_border, color: Colors.white,),),

            ],
          ),
          Text(_text, style: _textStyle, textAlign: TextAlign.left,),
          ILine(),
        ],
      ),
    );
  }
}