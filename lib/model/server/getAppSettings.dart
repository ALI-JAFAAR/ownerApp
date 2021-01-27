import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';

getAppSettings(Function(String, String) callback, Function(String) callbackError) async {
    try {
      var url = "${serverPath}getAppSettings";
      var response = await http.get(url).timeout(const Duration(seconds: 30));

      dprint("api/getAppSettings");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          callback(jsonResult['appLanguage'],
              (jsonResult['demoMode'] == null) ? "false" : jsonResult['demoMode']);
        }else
          callbackError("error=${jsonResult['error']}");
      } else
        callbackError("statusCode=${response.statusCode}");
    } catch (ex) {
      callbackError(ex.toString());
    }
}
