import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'category.dart';
import 'extras.dart';

extrasSave(String name, String extrasGroup, String price, String desc, String image,
    String edit, String editid,
    String uid, Function(List<ImageData>, List<ExtrasData>, String id) callback, Function(String) callbackError) async {

  var url = '${serverPath}extrasSave';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
    "name": name,
    "extrasgroup" : extrasGroup,
    "imageid": image,
    "price": price,
    "desc" : desc,
    "edit": edit,
    "editId" : editid
  });
  dprint('body: $body');
  try {
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      var ret = ResponseExtras.fromJson(jsonResult);
      callback(ret.images, ret.extras, ret.id);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
