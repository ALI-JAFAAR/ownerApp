import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'category.dart';

categoryDelete(String id, Function(List<ImageData>, List<CategoriesData>) callback, Function(String) callbackError) async {

  var url = '${serverPath}categoryDelete';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer ${account.token}",
  };
  var body = json.encoder.convert({
    "id": id,
  });
  try {
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] != "0")
        return callbackError(jsonResult["error"]);
      ResponseCategory ret = ResponseCategory.fromJson(jsonResult);
      callback(ret.images, ret.cat);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

