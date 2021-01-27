import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/server/chatGet.dart';
import 'package:delivery_owner/model/server/chatSend.dart';
import 'package:delivery_owner/model/server/chatUsers.dart';
import 'package:delivery_owner/ui/widgets/ICard28FileCaching.dart';
import 'package:delivery_owner/ui/widgets/ICard31FileCaching.dart';
import 'package:delivery_owner/ui/widgets/InputFieldArea3.dart';
import 'package:delivery_owner/ui/widgets/colorloader2.dart';
import 'package:delivery_owner/ui/widgets/easyDialog2.dart';
import 'package:delivery_owner/ui/widgets/ibackground4.dart';
import 'package:delivery_owner/ui/widgets/ibutton3.dart';
import 'package:delivery_owner/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class ChatScreen extends StatefulWidget {
  final Function(String) callback;
  ChatScreen({Key key, this.callback}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  onSendText(){
    if (editController.text.isEmpty)
      return;
    print("Send text ${editController.text}");
    chatSend(_userSelected, account.token, editController.text, _success, _error);
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  final editController = TextEditingController();
  bool _wait = false;
  List<ChatMessages> _this;
  List<ChatUsers> _users;

  @override
  void initState() {
    chatUsers(account.token, _successUsers, _error);
    account.addCallback(this.hashCode.toString(), callback);
    account.addChatCallback(callbackReload);
    super.initState();
  }


  _error(String error){
    _waits(false);
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _successUsers(List<ChatUsers> users) {
    _users = users;
    _users.sort((a, b) => a.compareTo(b));
    setState(() {
    });
  }

  callback(bool reg){
    setState(() {
    });
  }

  _onBack() {
    if (_state == "root")
      return widget.callback("home");
    if (_state == "view") {
      _state = "root";
      chatUsers(account.token, _successUsers, _error);
    }
    setState(() {
    });
  }

  @override
  void dispose() {
    account.addChatCallback(null);
    account.removeCallback(this.hashCode.toString());
    account.redraw();
    super.dispose();
  }

  String _state = "root";

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var colorsGradient = [Color(0xff56acdd), Color(0xff48a2d6)];

    return WillPopScope(
        onWillPop: () async {
      if (_show != 0) {
        setState(() {
          _show = 0;
        });
        return false;
      }
      _onBack();
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

          IBackground4(width: windowWidth, colorsGradient: colorsGradient),

        if (_state == "root")
          Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+20),
              child: ListView(
                children: _bodyUsers(),
              )),

        if (_state == "view")
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              width: windowWidth,
              height: 50,
              color: theme.colorBackgroundDialog,
              child: InputFieldArea3(hint: "Message", callback: onSendText,
              controller : editController, type : TextInputType.text, colorDefaultText: theme.colorDefaultText),
            ),
          ),

        if (_state == "view")
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+20),
              child: _body(),
            ),

        if (_state == "view")
          buttonBackUp(_onBack, MediaQuery.of(context).padding.top+45),
        if (_state == "root")
          buttonBack(_onBack),

          if (_wait)
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
              ),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
                body: _dialogBody, backgroundColor: theme.colorBackground),

          ],
        )
    )));
  }

  ScrollController _scrollController = new ScrollController();

  _body(){
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      alignment: Alignment.bottomCenter,
      child: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        children: _body2(),
      ),
    );
  }

  _body2(){
    var list = List<Widget>();
    var last = "";

    if (_this == null)
      return list;

    for (var _data in _this) {
      var now = _data.date.substring(0, 11);
      if (now != last) {
        list.add(SizedBox(height: 10,));
        list.add(Text(
            now, style: theme.text14boldWhite, textAlign: TextAlign.center),);
        list.add(SizedBox(height: 10,));
        last = now;
      }
      list.add(
          ICard31FileCaching(
              key: UniqueKey(),
              id: _data.id,
              colorLeft: theme.colorBackgroundDialog,
              colorRight: Color(0xFFcbecff),
              text: _data.text,
              textStyle: theme.text14bold,
              balloonColor: theme.colorPrimary,
              date: _data.date.substring(11,16),
              dateStyle: theme.text12bold,
              positionLeft: (_data.author != "manager"),
              delivered: (_data.delivered == "true"),
              read: (_data.read == "true")
          )
      );
    }
    list.add(SizedBox(height: 10,));
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

  String _searchValue = "";

  _searchBar(){
    return formSearch((String value){
      _searchValue = value.toUpperCase();
      setState(() {});
    });
  }

  _bodyUsers(){
    var list = List<Widget>();
    list.add(SizedBox(height: 10,));
    list.add(Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: _searchBar()) // Search
    );
    list.add(SizedBox(height: 10,));

    if (_users != null)
      for (var _data in _users) {
        if (_data.name.toUpperCase().contains(_searchValue)){
          list.add(ICard28FileCaching(
              id: _data.id,
              color: theme.colorGrey2,
              title: _data.name,
              titleStyle: theme.text14bold,
              userAvatar: "$serverImages${_data.image}",
              text: "",
              textStyle: theme.text14,
              balloonColor: Colors.green,
              balloonText: _data.count,
              balloonStyle: theme.text14boldWhite,
              balloonColor2: Colors.red,
              balloonText2: _data.unread.toString(),
              balloonStyle2: theme.text14boldWhite,
              enable: true,
              callback: _userSelect
          ));
        }
      }

    return list;
  }

  callbackReload(){
    if (_state == "view")
      chatGet(_userSelected, account.token, _success, _error);
    if (_state == "root")
      chatUsers(account.token, _successUsers, _error);
  }

  String _userSelected = "";

  _userSelect(String id){
    _userSelected = id;
    _this = null;
    _state = "view";
    chatGet(_userSelected, account.token, _success, _error);
    setState(() {

    });
  }

  _success(List<ChatMessages> _data, int unread) {
    editController.text = "";
    _waits(false);
    _this = _data;
    account.chatCount = unread;
    account.redraw();
    setState(() {});
    if (_state == "view")
      Future.delayed(const Duration(milliseconds: 700), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
        // _scrollController.animateTo(
        //     _scrollController.position.maxScrollExtent,
        //     curve: Curves.easeOut,
        //     duration: const Duration(milliseconds: 300));
        // setState(() {
        // });
      });
  }
}

