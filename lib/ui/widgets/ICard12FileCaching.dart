import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ICard12FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final double width;
  final double height;
  final String text;
  final String image;
  final String id;
  final TextStyle textStyle;
  final Function(String id, String hero) callback;

  ICard12FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.colorProgressBar = Colors.black,
    this.id = "", this.textStyle, this.callback,
  });

  @override
  _ICard12FileCachingState createState() => _ICard12FileCachingState();
}

class _ICard12FileCachingState extends State<ICard12FileCaching>{

  var _textStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id, _id);
        }, // needed
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          width: widget.width-10,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: new BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(100),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: <Widget>[
              Hero(
                  tag: _id,
                  child: Container(
                      width: widget.width-10,
                      height: widget.height*0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: Container(
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                UnconstrainedBox(child:
                                Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(backgroundColor: widget.colorProgressBar, ),
                                )),
                            imageUrl: widget.image,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            errorWidget: (context,url,error) => new Icon(Icons.error),
                          ),
                        ),                  )
                  )),

              InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(widget.id, _id);
                  }, // needed
                  child: Container(
                    width: widget.width,
                    height: widget.height*0.2,
                    margin: EdgeInsets.only(left: 5, right: 5, top: widget.height*0.8+5),
                    child: Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                  )),

            ],
          ),
        ));
  }
}