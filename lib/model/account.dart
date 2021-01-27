import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/main.dart';
import 'package:delivery_owner/model/pref.dart';
import 'package:delivery_owner/model/server/chatUnread.dart';
import 'package:delivery_owner/model/server/fcbToken.dart';
import 'package:delivery_owner/model/server/login.dart';

class Account{

  String _fcbToken;
  String userName = "";
  String userId = "";
  String email = "";
  String phone = "";
  String userAvatar = "";
  String token = "";

  int notifyCount = 0;
  String currentOrder = "";
  String openOrderOnMap = "";
  String backRoute = "";
  String backRouteMap = "";

  bool _initUser = true;

  okUserEnter(String name, String password, String avatar, String _email, String _token, String _phone, int unreadNotify, String _userId){
    _initUser = true;
    userName = name;
    userAvatar = avatar;
    if (userAvatar == null)
      userAvatar = serverImgNoUserPath;
    if (userAvatar.isEmpty)
      userAvatar = serverImgNoUserPath;
    email = _email;
    if (_phone != null)
      phone = _phone;
    token = _token;
    userId = _userId;
    notifyCount = unreadNotify;
    pref.set(Pref.userEmail, _email);
    pref.set(Pref.userPassword, password);
    pref.set(Pref.userAvatar, avatar);
    dprint("User Auth! Save email=$email pass=$password");
    _callAll(true);
    if (_fcbToken != null)
      addNotificationToken(account.token, _fcbToken);
    chatGetUnread();
  }

  _callAll(bool value){
    for (var callback in callbacks.values) {
      try {
        callback(value);
      } catch(ex){}
    }
  }

  var callbacks = Map<String, Function(bool)>();

  addCallback(String name, Function(bool) callback){
    callbacks.addAll({name: callback});
  }

  removeCallback(String name){
    callbacks.remove(name);
  }

  redraw(){
    _callAll(_initUser);
  }

  logOut(){
    _initUser = false;
    pref.clearUser();
    userName = "";
    userAvatar = "";
    email = "";
    token = "";
    _callAll(false);
  }

  isAuth(Function(bool) callback){
    var email = pref.get(Pref.userEmail);
    var pass = pref.get(Pref.userPassword);
    dprint("Login: email=$email pass=$pass");
    if (email.isNotEmpty && pass.isNotEmpty) {
      login(email, pass, (String name, String password, String avatar, String email, String token, String phone, int unreadNotify, String userId){
        callback(true);
        okUserEnter(name, password, avatar, email, token, phone, unreadNotify, userId);
      }, (String err) {
        callback(false);
      });
    }else
      callback(false);
  }

  //
  // Orders screen
  //
  Function() callbackOrdersReload;
  addOrdersCallback(Function() callback){
    callbackOrdersReload = callback;
  }

  //
  // notifications
  //

  setFcbToken(String token){
    _fcbToken = token;
    if (_initUser)
      addNotificationToken(account.token, _fcbToken);
  }

  addNotify(){
    notifyCount++;
    _callAll(_initUser);
    if (callbackNotifyReload != null)
      callbackNotifyReload();
    if (callbackOrdersReload != null)
      callbackOrdersReload();
  }

  notifyRefresh(){
    _callAll(_initUser);
    if (callbackNotifyReload != null)
      callbackNotifyReload();
    if (callbackOrdersReload != null)
      callbackOrdersReload();
  }

  Function() callbackNotifyReload;
  addNotifyCallback(Function() callback){
    callbackNotifyReload = callback;
  }

  //
  // chat
  //

  int chatCount = 0;
  Function() callbackChatReload;
  addChatCallback(Function() callback){
    callbackChatReload = callback;
  }

  addChat(){
    chatGetUnread();
    _callAll(_initUser);
    if (callbackChatReload != null)
      callbackChatReload();
  }

  chatRefresh(){
    if (callbackChatReload != null)
      callbackChatReload();
  }

  chatGetUnread(){
    chatUnread(token, (int count){
      chatCount = count;
      _callAll(true);
      }, (String _){});
  }

  //
  //
  //
  setUserAvatar(String _avatar){
    userAvatar = _avatar;
    _callAll(true);
  }
}
