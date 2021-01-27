import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:delivery_owner/main.dart';
import 'package:delivery_owner/ui/widgets/iinkwell.dart';

class Header extends StatefulWidget {
  final String title;
  final Function onMenuClick;
  final bool nomenu;
  final bool white;
  final bool transparent;
  final Function(String) callback;
  Header({Key key, this.title, this.onMenuClick, this.nomenu = false, this.white = false,
    this.transparent = false, this.callback}) : super(key: key);
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  var _iconMenu = "assets/menu.png";
  var _iconBack = "assets/back.png";
  var _iconNotify = "assets/notifyicon.png";

  _onBackClick(){
    Navigator.pop(context);
  }

  _onMenuClick(){
    print("User click menu button");
    if (widget.onMenuClick != null)
      widget.onMenuClick();
  }

  _onNotifyClick(){
    print("User click Notify button");
    widget.callback("notification");
  }

  _onChatClick(){
    print("User click Chat button");
    widget.callback("chat");
  }

  _onAvatarClick(){
    print("User click avatar button");
    widget.callback("account");
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  Color _color = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _color = theme.colorDefaultText;
    if (widget.white)
      _color = Colors.white;
    String _title = "";
    if (widget.title != null)
      _title = widget.title;

    Widget _menu = IInkWell(child: _iconMenuWidget(), onPress: _onMenuClick,);
    if (widget.nomenu)
      _menu = IInkWell(child: _iconBackWidget(), onPress: _onBackClick,);

    var _style = theme.text16bold;
    if (widget.white != null && widget.white)
      _style = theme.text16boldWhite;

    var _box = BoxDecoration(
      color: theme.colorBackground,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(3, 3),
        ),
      ],
    );
    if (widget.transparent)
      _box = BoxDecoration();

    return Container(
        height: 40,
        decoration: _box,
        child: Row(
          children: <Widget>[
            _menu,
            Expanded(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(_title,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: _style,
                  )),
            ),

              IInkWell(child: _chat(), onPress: _onChatClick,),

              IInkWell(child: _notify(), onPress: _onNotifyClick,),

              IInkWell(child: _avatar(), onPress: _onAvatarClick,),

          ],
        )
    );
  }

  _avatar(){
    if (account.userAvatar == null)
      return Container();
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      child: Container(
        width: 25,
        height: 25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(backgroundColor: theme.colorPrimary,),
              imageUrl: account.userAvatar,
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
        ),
      ),
    );
  }

  _iconMenuWidget(){
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset(_iconMenu,
                  fit: BoxFit.contain, color: _color,
              )
          )),
    );
  }

  _iconBackWidget(){
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset(_iconBack,
                  fit: BoxFit.contain, color: _color,
              )
          )),
    );
  }

  _notify(){
    return UnconstrainedBox(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 25,
          width: 30,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        height: 25,
                        width: 30,
                        child: Image.asset(_iconNotify,
                          fit: BoxFit.contain, color: _color,
                        )
                    )),
              ),

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(account.notifyCount.toString(), style: theme.text10white),
                  ),
                ),
              )

            ],
          ),
        )
    );
  }

  _chat(){
    return UnconstrainedBox(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          height: 25,
          width: 30,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 25,
                        width: 30,
                        child: Image.asset("assets/chat.png",
                          fit: BoxFit.contain, color: _color,
                        )
                    )),
              ),

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(account.chatCount.toString(), style: theme.text10white),
                  ),
                ),
              )

            ],
          ),
        )
    );
  }

}
