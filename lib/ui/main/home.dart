import 'dart:async';

import 'package:delivery_owner/main.dart';
import 'package:delivery_owner/model/server/totals.dart';
import 'package:delivery_owner/ui/widgets/ICard26.dart';
import 'package:delivery_owner/ui/widgets/TextTikTok.dart';
import 'package:delivery_owner/ui/widgets/colorloader2.dart';
import 'package:delivery_owner/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) callback;
  final Function(String, String) callbackWithParam;
  HomeScreen({Key key, this.callback, this.callbackWithParam}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

TotalsData totals;

class _HomeScreenState extends State<HomeScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool _wait = false;

  @override
  void initState() {
    if (totals == null)
      _waits(true);
    totalsLoad(account.token,
            (TotalsData _totals){
          totals = _totals;
          _waits(false);
          setState(() {});
        }, (String _){_waits(false);});
    startTimer();
    super.initState();
  }

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+30),
          child: _body(),
        ),

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

      ],
    );
  }

  _body(){
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    var list = List<Widget>();

    list.add(
        ICard26(
          color: theme.colorBackgroundDialog,
          text: (totals != null) ? ((totals.rightSymbol == "true") ?  totals.totals.toStringAsFixed(totals.symbolDigits)+totals.code
              : totals.code + totals.totals.toStringAsFixed(totals.symbolDigits)) : "0",
          text2: strings.get(90), // "Total Earning",
          text3: (totals != null) ? totals.orders : "0",
          text4: strings.get(91), // "Orders",
          textStyle: theme.text18bold,
          text2Style: theme.text16,
          enable56: false,
        )
    );

    list.add(SizedBox(height: 10,));

    if (theme.multiple)
      list.add(
          ICard26(
            color: theme.colorBackgroundDialog,
            text: (totals != null) ? totals.restaurants : "0",
            text2: strings.get(92), // "Total Restaurants",
            text3: (totals != null) ? totals.foods : "0",
            text4: strings.get(93), // "Total Foods",
            textStyle: theme.text18bold,
            text2Style: theme.text16,
            enable56: false,
          )
      );
    else
      list.add(
          ICard26(
            color: theme.colorBackgroundDialog,
            text: "",
            text2: "",
            text3: (totals != null) ? totals.foods : "0",
            text4: strings.get(93), // "Total Foods",
            textStyle: theme.text18bold,
            text2Style: theme.text16,
            enable56: true,
          )
      );

    list.add(SizedBox(height: 30,));
    if (totals != null){
        list.add(_item(strings.get(24), "${strings.get(162)} ${(totals != null) ? totals.orders : 0}",  // Orders  // "Total Count:"
            strings.get(238), totals.orderImage, _offset+50, (){widget.callback("orders");}));  // "Orders Management",

        list.add(SizedBox(height: 20,));

        list.add(_item(strings.get(94), "${strings.get(162)} ${(totals != null) ? totals.foods : 0}",  // Foods  // "Total Count:"
            strings.get(239), totals.foodImage, _offset, (){widget.callback("foods");}));  // "Foods Management",

        list.add(SizedBox(height: 20,));

        if (theme.multiple){
          list.add(_item(strings.get(105), "${strings.get(162)} ${(totals != null) ? totals.restaurants : 0}",  // ""Restaurants","  // "Total Count:"
              strings.get(237), totals.restaurantImage, _offset+100, (){widget.callback("restaurants");}));  // "Restaurants Management",
        }else{
          list.add(_item(strings.get(105), "",  // Restaurants
              strings.get(237), totals.restaurantImage, _offset+100, (){widget.callbackWithParam("restaurants", "edit1");}));  // "Restaurants Management",
          list.add(SizedBox(height: 5,));
          list.add(buttonEdit(() {
            widget.callbackWithParam("restaurants", "edit1");
          }, windowWidth));

        }
    }
    list.add(SizedBox(height: 100,));
    return list;
  }

  _item(String _name1, String _name2, String _text3, String _image, double _off, Function() _callback){
    return Stack(
      children: [
        Container(
            child: oneItem(_name1, "", _name2, _image, windowWidth, "")),
        Positioned.fill(
            child: Container(
                alignment: Alignment.bottomCenter,
                width: windowWidth,
                child: Container(
                  color: Colors.black.withAlpha(130),
                  height: 20,
                  child: CustomPaint(
                    painter: TextTikTok(offset: _off, text: _text3),
                    size: Size.infinite,
                  ),
                ))),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _callback();
                }, // needed
              )),
        )
      ],
    );
  }

  double _offset = 30;

  Timer _timer;
  void startTimer() {
    _timer = new Timer.periodic(Duration(milliseconds: 50),
          (Timer timer) {
        _offset-=2;
        setState(() {
        });
      },);
  }
}


