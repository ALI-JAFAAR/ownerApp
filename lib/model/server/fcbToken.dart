import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

addNotificationToken(String uid, String fcbToken) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"fcbToken": "$fcbToken"}';

    dprint('body: $body');
    var url = "${serverPath}fcbToken";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("fcbToken");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');
  } catch (_) {

  }
}
