import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'category.dart';

categorySave(String name, String desc, String image, String published,
    String parent,
    String edit, String editid,
    String uid, Function(List<ImageData>, List<CategoriesData>, String id) callback, Function(String) callbackError) async {

  var url = '${serverPath}categorySave';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
    "name": name,
    "desc" : desc,
    "imageid":image,
    "visible": published,
    "edit": edit,
    "editId" : editid,
    "parent" : parent
  });
  dprint('body: $body');
  try {
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] != "0")
        return callbackError(jsonResult["error"]);
      ResponseCategory ret = ResponseCategory.fromJson(jsonResult);
      callback(ret.images, ret.cat, ret.id);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

