import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'foods.dart';

extrasGroupSave(String name, String restaurant,
    String edit, String editid,
    String uid, Function(List<ExtrasGroupData>, String id) callback, Function(String) callbackError) async {

  var url = '${serverPath}extrasGroupSave';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
    "name": name,
    "restaurant" : restaurant,
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
      var ret = ResponseExtrasGroup.fromJson(jsonResult);
      callback(ret.extrasGroupData, ret.id);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class ResponseExtrasGroup {
  String error;
  String id;
  List<ExtrasGroupData> extrasGroupData;

  ResponseExtrasGroup({this.error, this.id, this.extrasGroupData});

  factory ResponseExtrasGroup.fromJson(Map<String, dynamic> json){

    var t = json['extrasGroup'].map((f) => ExtrasGroupData.fromJson(f)).toList();
    var _extrasGroupData = t.cast<ExtrasGroupData>().toList();

    return ResponseExtrasGroup(
      error: json['error'].toString(),
      id: json['id'].toString(),
      extrasGroupData: _extrasGroupData,
    );
  }
}
