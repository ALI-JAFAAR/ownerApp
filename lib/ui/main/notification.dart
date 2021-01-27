import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/server/notify.dart';
import 'package:delivery_owner/model/server/notifyDelete.dart';
import 'package:delivery_owner/ui/widgets/ICard29FileCaching.dart';
import 'package:delivery_owner/ui/widgets/colorloader2.dart';
import 'package:delivery_owner/ui/widgets/easyDialog2.dart';
import 'package:delivery_owner/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';
import 'package:delivery_owner/main.dart';
import 'package:delivery_owner/ui/main/header.dart';

class NotificationScreen extends StatefulWidget {
  final Function(String) callback;
  NotificationScreen({Key key, this.callback}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _dismissItem(String id){
    print("Dismiss item: $id");

    notifyDelete(account.token, id, (){
      Notifications _delete;
      for (var item in _this)
        if (item.id == id)
          _delete = item;

      if (_delete != null) {
        _this.remove(_delete);
        setState(() {
        });
      }
    }, _error);

  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool _wait = true;
  List<Notifications> _this;

  @override
  void initState() {
    account.notifyCount = 0;
    account.redraw();
    getNotify(account.token, _success, _error);
    account.addCallback(this.hashCode.toString(), callback);
    account.addNotifyCallback(callbackReload);
    super.initState();
  }

  callbackReload(){
    getNotify(account.token, _success, _error);
  }

  _error(String error){
    _waits(false);
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _success(List<Notifications> _data) {
    _waits(false);
    _this = _data;
    setState(() {
    });
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    account.redraw();
    account.addNotifyCallback(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
      if (_show != 0) {
        setState(() {
          _show = 0;
        });
        return false;
      }
      widget.callback("home");
      return false;
    },
    child: Scaffold(
        backgroundColor: theme.colorBackground,
        body:
        Directionality(
            textDirection: strings.direction,
            child:
            Stack(
              children: <Widget>[

                Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child: Header(title: strings.get(25), nomenu: true,) // "Notifications",
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+42),
                  child: _body(),
                ),

                if (_wait)(
                    Container(
                      color: Color(0x80000000),
                      width: windowWidth,
                      height: windowHeight,
                      child: Center(
                        child: ColorLoader2(
                          color1: theme.colorPrimary,
                          color2: theme.colorCompanion,
                          color3: theme.colorPrimary,
                        ),
                      ),
                    ))else(Container()),

                IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
                    body: _dialogBody, backgroundColor: theme.colorBackground),


              ],
            )
        )));
  }

  _body(){
    var size = 0;
    if (_this == null)
      return Container();
    for (var _ in _this)
      size++;
    if (size == 0)
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      height: windowHeight/3,
                      width: windowWidth/2,
                      child: Container(
                        child: Image.asset("assets/nonotify.png",
                          fit: BoxFit.contain,
                        ),
                      )
                  )),
              SizedBox(height: 20,),
              Text(strings.get(39),    // "Not Have Notifications",
                  overflow: TextOverflow.clip,
                  style: theme.text16bold
              ),
              SizedBox(height: 50,),
            ],
          )

      );
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    var list = List<Widget>();

    list.add(Container(
      color: theme.colorBackgroundDialog,
      child: ListTile(
        leading: UnconstrainedBox(
            child: Container(
                height: 35,
                width: 35,
                child: Image.asset("assets/notifyicon.png",
                  fit: BoxFit.contain,
                ))),
        title: Text(strings.get(25), style: theme.text20bold,),  // "Notifications",
        subtitle: Text(strings.get(40), style: theme.text14,),  // "This is very important information",
      ),
    ));

    list.add(SizedBox(height: 20,));

    for (var _data in _this) {
      list.add(
          ICard29FileCaching(
              key: UniqueKey(),
              id: _data.id,
              color: theme.colorGrey.withOpacity(0.1),
              title: _data.title,
              titleStyle: theme.text14bold,
              userAvatar: "$serverImages${_data.image}",
              colorProgressBar: theme.colorPrimary,
              text: _data.text,
              textStyle: theme.text14,
              balloonColor: theme.colorPrimary,
              date: _data.date,
              dateStyle: theme.text12grey,
              callback: _dismissItem
          )
      );
    }
    return list;
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(66),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

}

