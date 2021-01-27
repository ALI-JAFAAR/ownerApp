import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../main.dart';

login(String email, String password,
    Function(String name, String password, String avatar, String email, String token, String phone, int unreadNotify, String userId) callback,
    Function(String) callbackError) async {

  try {

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
    };

    var body = json.encoder.convert(
        {
          'email': '$email',
          'password': '$password',
          'owner' : 'true'
        }
    );
    var url = "${serverPath}login";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("login: $url, $body");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      if (ret.error == "0") {
        if (ret.data != null) {
          var path = "";
          if (ret.data.photo != null)
            path = "$serverImages${ret.data.photo}";
          callback(ret.data.name, password, path, email, ret.accessToken, ret.data.phone, ret.notify, ret.data.id);
        }else
          callbackError("error:ret.data=null");
      }else
        callbackError(ret.error);
    }else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  Data data;
  String accessToken;
  int notify;
  //String errorMsg;
  Response({this.error, this.data, this.accessToken, this.notify});
  factory Response.fromJson(Map<String, dynamic> json){
    var a;
    if (json['user'] != null)
      a = Data.fromJson(json['user']);
    return Response(
      error: json['error'].toString(),
      accessToken: json['access_token'].toString(),
      notify: toInt(json['notify'].toString()),
      data: a,
    );
  }
}

class Data {
  String id;
  String name;
  String phone;
  String photo;
  Data({ this.name, this.photo, this.phone});
  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      name: json['name'].toString(),
      photo: json['avatar'].toString(),
      phone: json['phone'].toString(),
    );
  }
}

