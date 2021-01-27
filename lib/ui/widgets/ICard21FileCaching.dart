import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//
// v 2.0 - 30/09/2020
//

class ICard21FileCaching extends StatefulWidget {
  final Color color;
  final double width;
  final Color colorProgressBar;
  final double height;
  final String text;
  final String text2;
  final String text3;
  final String image;
  final String id;
  final TextStyle textStyle;
  final TextStyle textStyle2;
  final TextStyle textStyle3;
  final bool enableFavorites;
  final Function(String) getFavoriteState;
  final Function(String) revertFavoriteState;
  final Function(String id, String heroId) callback;
  ICard21FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.textStyle2, this.text2 = "", this.getFavoriteState, this.revertFavoriteState,
    this.id = "", this.textStyle, this.callback, this.colorProgressBar = Colors.black, this.enableFavorites = true,
    this.textStyle3, this.text3 = ""
  });

  @override
  _ICard21FileCachingState createState() => _ICard21FileCachingState();
}

class _ICard21FileCachingState extends State<ICard21FileCaching>{

  var _textStyle = TextStyle(fontSize: 16);
  var _textStyle2 = TextStyle(fontSize: 16);
  var _textStyle3 = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.textStyle2 != null)
      _textStyle2 = widget.textStyle2;
    if (widget.textStyle3 != null)
      _textStyle3 = widget.textStyle3;

    Widget _favorites = Container();
    if (widget.enableFavorites)
      _favorites = Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, right: 5),
        child: Stack(
          children: <Widget>[
            Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Icon((widget.getFavoriteState(widget.id)) ? Icons.star : Icons.star_border, color: Colors.white, size: 40,),
                    Icon((widget.getFavoriteState(widget.id)) ? Icons.star : Icons.star_border, color: widget.colorProgressBar, size: 38,)
                  ],
                )
            ),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      widget.revertFavoriteState(widget.id);
                    }, // needed
                  )),
            )
          ],
        ),
      );

    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback(widget.id, _id);
        }, // needed
        child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            width: widget.width-10,
            height: widget.height-20,
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: new BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(40),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(2, 2), // changes position of shadow
                  ),
                ]
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Hero(
                          tag: _id,
                          child: Container(
                            width: widget.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                child:Container(
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
                                ),
                              )
                          )),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 5, left: 5, bottom: 5),
                      child: Row(
                          children: [
                            Expanded(
                              child: Text(widget.text3, style: _textStyle3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                            ),
                            Text(widget.text2, style: _textStyle2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,),

                            ])),
                  ],
                ),

                _favorites

              ],
            )


        ));
  }
}