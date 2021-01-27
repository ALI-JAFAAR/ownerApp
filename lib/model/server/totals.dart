import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import '../util.dart';

totalsLoad(String uid,
    Function(TotalsData totals) callback,
    Function(String) callbackError) async {

  var url = '${serverPath}totals';
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
      callback(TotalsData.fromJson(jsonResult));
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class TotalsData {
  String error;
  double totals;
  String orders;
  String restaurants;
  String foods;
  String rightSymbol;
  int symbolDigits;
  String code;
  String restaurantImage;
  String foodImage;
  String orderImage;

  TotalsData({this.error, this.totals, this.orders, this.restaurants, this.foods, this.rightSymbol,
    this.symbolDigits, this.code, this.restaurantImage, this.foodImage, this.orderImage
  });

  factory TotalsData.fromJson(Map<String, dynamic> json){
    return TotalsData(
      error: json['error'].toString(),
      totals: toDouble(json['totals'].toString()),
      orders: json['orders'].toString(),
      restaurants: json['restaurants'].toString(),
      foods: json['foods'].toString(),
      rightSymbol: json['rightSymbol'].toString(),
      symbolDigits: toInt(json['symbolDigits'].toString()),
      code: json['code'].toString(),
      restaurantImage: "$serverImages${json['restaurantImage'].toString()}",
      foodImage: "$serverImages${json['foodImage'].toString()}",
      orderImage: "$serverImages${json['orderImage'].toString()}",

    );
  }
}
