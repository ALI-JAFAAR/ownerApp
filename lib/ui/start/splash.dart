import 'dart:async';
import 'package:flutter/material.dart';
import 'package:delivery_owner/main.dart';
import 'package:delivery_owner/ui/widgets/ibackground4.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  ////////////////////////////////////////////////////////////////
  //
  //
  //
  _startNextScreen(){
    //Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    account.isAuth((bool auth) {
      if (!auth)
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      else
        Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
    });
  }

  //
  //
  ////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    pref.init();
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, _startNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );

  }

  initScreen(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: <Widget>[

            Container(
              color: theme.colorBackground,
            ),

            IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "SplashLogo",
                    child: Container(
                      width: windowWidth*0.3,
                      child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  CircularProgressIndicator(
                    backgroundColor: theme.colorCompanion,
                    strokeWidth: 1,
                  )
                ],
              ),
            ),


          ],
        )

    );
  }

}


