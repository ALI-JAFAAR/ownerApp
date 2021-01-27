import 'package:flutter/material.dart';
import 'package:delivery_owner/config/theme.dart';
import 'package:delivery_owner/model/account.dart';
import 'package:delivery_owner/model/pref.dart';
import 'package:delivery_owner/ui/login/forgot.dart';
import 'package:delivery_owner/ui/login/login.dart';
import 'package:delivery_owner/ui/main/mainscreen.dart';
import 'package:delivery_owner/ui/start/splash.dart';
import 'config/lang.dart';
import 'model/server/getAppSettings.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();
//
// Language data
//
Lang strings = Lang();
//
// Account
//
Account account = Account();
Pref pref = Pref();
//
//
String demoMode = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  pref.init().then((instance) {
    theme.init();
    // language
    var id = pref.get(Pref.language);
    var lid = Lang.english;
    if (id.isNotEmpty)
      lid = int.parse(id);
    strings.setLang(lid);  // set default language - English
    runApp(AppFoodDelivery());
  });
}

class AppFoodDelivery  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var _theme = ThemeData(
      fontFamily: 'Raleway',
      primarySwatch: theme.primarySwatch,
    );

    if (theme.darkMode){
      _theme = ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        unselectedWidgetColor:Colors.white,
        primarySwatch: theme.primarySwatch,
      );
    }

    getAppSettings(
            (String appLang, String _demoMode){
              demoMode = _demoMode;
              var lid = toInt(appLang);
              if (lid == 0) lid = 1;
              var user = pref.get(Pref.userSelectLanguage);
              if (user != "true")
                strings.setLang(lid);  // set default language
            }, (String _){});

    return MaterialApp(
      title: strings.get(10),  // "Food Delivery Flutter App UI Kit",
      debugShowCheckedModeBanner: false,
      theme: _theme,
      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/forgot': (BuildContext context) => ForgotScreen(),
        '/main': (BuildContext context) => MainScreen(),
      },
    );
  }
}


dprint(String str){
  //
  // comment this line for release app
  //
  print(str);
}

int toInt(String str){
  int ret = 0;
  try {
    ret = int.parse(str);
  }catch(_){}
  return ret;
}

