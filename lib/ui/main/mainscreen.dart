import 'package:delivery_owner/model/notifications.dart';
import 'package:delivery_owner/ui/main/chat.dart';
import 'package:delivery_owner/ui/main/restaurants.dart';
import 'package:delivery_owner/ui/main/home.dart';
import 'package:delivery_owner/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:delivery_owner/main.dart';
import 'package:delivery_owner/ui/main/account.dart';
import 'package:delivery_owner/ui/main/header.dart';
import 'package:delivery_owner/ui/main/notification.dart';
import 'package:delivery_owner/ui/main/orders.dart';
import 'package:delivery_owner/ui/menu/language.dart';
import 'package:delivery_owner/ui/menu/menu.dart';
import 'foods.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  _openMenu(){
    print("Open menu");
    setState(() {
      _scaffoldKey.currentState.openDrawer();
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _currentPage = "home";
  var _oldCurrentPage = "";
  var _routeParam = "";

  @override
  void initState() {
    account.addCallback(this.hashCode.toString(), _redraw);
    Future.delayed(Duration(milliseconds: 100), () async {
      await firebaseGetToken();
    });
    super.initState();
  }

  _redraw(bool){
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var _headerText = strings.get(21); //
    switch(_currentPage){
      case "home":
        _headerText = strings.get(236); // "Home",
      break;
      case "language":
        _headerText = strings.get(28); // "Languages",
        break;
      case "account":
        _headerText = strings.get(27); // "Account",
        break;
      case "notification":
        _headerText = strings.get(25); // "Notifications",
        break;
      case "orders":
        _headerText = strings.get(24); // "Orders",
        break;
      case "restaurants":
        _headerText = strings.get(105); // "My Restaurants",
        break;
      case "foods":
        _headerText = strings.get(94); // "Foods",
        break;
      case "chat":
        _headerText = strings.get(246); // "Chat",
        break;
      default:
        break;
    }

    return WillPopScope(
        onWillPop: () async {
      if (_currentPage == "notification"){
        _onBack();
        return false;
      }
      return true;
    },
    child: Directionality(
        textDirection: strings.direction,
        child: Scaffold(
      key: _scaffoldKey,
      drawer: Menu(context: context, callback: routes, callbackWithParam: routesWithParam),
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[
          if (_currentPage == "chat")
            ChatScreen(callback: routes),
          if (_currentPage == "foods")
            FoodsScreen(callback: routes),
          if (_currentPage == "restaurants")
            RestaurantsScreen(callback: routes, param1: _routeParam),
          if (_currentPage == "notification")
            NotificationScreen(callback: routes),
          if (_currentPage.isEmpty)
            OrdersScreen(callback: routes),
          if (_currentPage == "home")
            HomeScreen(callback: routes, callbackWithParam: routesWithParam),
          if (_currentPage == "language")
            LanguageScreen(callback: routes),
          if (_currentPage == "account")
            AccountScreen(callback: routes),
          if (_currentPage == "orders")
            OrdersScreen(callback: routes),
          // button back
          if (_currentPage == "notification")
            buttonBack(_onBack),

          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Header(title: _headerText, onMenuClick: _openMenu, callback: routes)
          ),

        ],
      ),
    )));
  }

  _onBack(){
    if (_currentPage == "notification") {
      _currentPage = _oldCurrentPage;
      _oldCurrentPage = "";
      setState(() {});
    }
  }

  routesWithParam(String route, String routeParam){
    _oldCurrentPage = _currentPage;
    _currentPage = route;
    _routeParam = routeParam;
    setState(() {
    });
  }

  routes(String route){
    _routeParam = "";
    if (route != "redraw") {
      _oldCurrentPage = _currentPage;
      _currentPage = route;
    }
    setState(() {
    });
  }

}

