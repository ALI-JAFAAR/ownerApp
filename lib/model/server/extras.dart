import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/server/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';

extrasLoad(String uid, Function(List<ImageData>, List<ExtrasData>) callback, Function(String) callbackError) async {

  var url = '${serverPath}extrasList';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
  });
  try {
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      var ret = ResponseExtras.fromJson(jsonResult);
      callback(ret.images, ret.extras);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class ResponseExtras {
  String error;
  String id;
  List<ExtrasData> extras;
  List<ImageData> images;
  ResponseExtras({this.error, this.extras, this.id, this.images});
  factory ResponseExtras.fromJson(Map<String, dynamic> json){

    var t = json['extras'].map((f) => ExtrasData.fromJson(f)).toList();
    var _extras = t.cast<ExtrasData>().toList();

    t = json['images'].map((f) => ImageData.fromJson(f)).toList();
    var _images = t.cast<ImageData>().toList();

    return ResponseExtras(
      error: json['error'].toString(),
      id: json['id'].toString(),
      extras: _extras,
      images: _images,
    );
  }
}

class ExtrasData {
  int id;
  String updatedAt;
  String name;
  String desc;
  int imageid;
  String price;
  int extrasGroup;
  ExtrasData({this.id, this.name, this.extrasGroup, this.imageid, this.updatedAt, this.desc, this.price});
  factory ExtrasData.fromJson(Map<String, dynamic> json) {
    return ExtrasData(
      id : toInt(json['id'].toString()),
      updatedAt: json['updated_at'].toString(),
      name: json['name'].toString(),
      desc : json['desc'].toString(),
      imageid: toInt(json['imageid'].toString()),
      price: json['price'].toString(),
      extrasGroup : toInt(json['extrasgroup'].toString()),
    );
  }
}
