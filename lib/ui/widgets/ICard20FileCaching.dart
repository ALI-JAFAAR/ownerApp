import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//
// v 2.0 - 29/09/2020
//

class ICard20FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final String text;
  final String text2;
  final String text3;
  final String image;
  final Color colorRoute;
  final String id;
  final TextStyle title;
  final TextStyle body;
  final Function(String id, String hero) callback;
  final Function(String id) callbackNavigateIcon;

  ICard20FileCaching({this.color = Colors.white, this.colorProgressBar = Colors.black,
    this.text = "", this.text2 = "", this.image = "", this.colorRoute = Colors.black,
    this.id = "", this.title, this.body, this.callback, this.callbackNavigateIcon,
    this.text3 = "",
  });

  @override
  _ICard20FileCachingState createState() => _ICard20FileCachingState();
}

class _ICard20FileCachingState extends State<ICard20FileCaching>{

  var _titleStyle = TextStyle(fontSize: 16);
  var _bodyStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.title != null)
      _titleStyle = widget.title;
    if (widget.body != null)
      _bodyStyle = widget.body;
    return
    Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(widget.id, _id);
                  }, // needed
                  child: Hero(
                    tag: _id,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
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
                            )),
                      ),
                    ),
                  )
              )),

              InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(widget.id, _id);
                  }, // needed
                  child: Container(
                    margin: EdgeInsets.only(left: 10, bottom: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.text, style: _titleStyle, overflow: TextOverflow.ellipsis,),
                          Text(widget.text2, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                          Text(widget.text3, style: _bodyStyle, overflow: TextOverflow.ellipsis,),
                        ],
                      ))),



            ],
          ),

        ),

          Container(
            alignment: Alignment.bottomRight,
            child: UnconstrainedBox(
                child: Container(
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                    height: 40,
                    width: 40,
                    child: _route()
                )),
          ),


      ],
    );
  }

  _route(){
    return Stack(
      children: <Widget>[
        Image.asset("assets/route.png",
          fit: BoxFit.cover, color: widget.colorRoute,
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (widget.callbackNavigateIcon != null)
                    widget.callbackNavigateIcon(widget.id);
                }, // needed
              )),
        )
      ],
    );
  }
}