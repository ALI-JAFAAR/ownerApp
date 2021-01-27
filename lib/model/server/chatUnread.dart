import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';

chatUnread(String uid, Function(int) callback, Function(String) callbackError) async {

    try {
      var url = "${serverPath}getChatUnread";
      var response = await http.get(url, headers: {
          'Authorization': 'Bearer $uid',
      }).timeout(const Duration(seconds: 30));

      dprint("api/getChatUnread");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          callback(toInt(jsonResult['unread'].toString()));
        }else
          callbackError("error=${jsonResult['error']}");
      } else
        callbackError("statusCode=${response.statusCode}");
    } catch (ex) {
      callbackError(ex.toString());
    }
  }

