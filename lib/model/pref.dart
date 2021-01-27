import 'package:shared_preferences/shared_preferences.dart';

class Pref{

  SharedPreferences _prefs;

  static String userEmail = "userEmail";
  static String userPassword = "userPassword";
  static String userAvatar = "userAvatar";

  static String language = "language";
  static String userSelectLanguage = "userSelectLanguage";

  init() async {
    await _init2();
  }

  _init2() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set(String key, String value)  async {
    if (_prefs == null)
      await _init2();
    _prefs.setString(key, value);
  }

  String get(String key)  {
    String text = "";
    try{
      text = _prefs.getString(key);
      if (text == null)
        text = "";
    }catch(ex){}
    return text;
  }

  clearUser(){
    set(Pref.userEmail, "");
    set(Pref.userPassword, "");
    set(Pref.userAvatar, "");
  }
}