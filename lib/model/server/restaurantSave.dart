import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/server/category.dart';
import 'package:delivery_owner/model/server/restaurants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';

restaurantSave(String name, String image, String desc, String published,
    String phone, String mobilephone, String address, String lat, String lng,
    String fee, String percent,
    String openTimeMonday, String closeTimeMonday,
    String openTimeTuesday, String closeTimeTuesday,
    String openTimeWednesday, String closeTimeWednesday,
    String openTimeThursday, String closeTimeThursday,
    String openTimeFriday, String closeTimeFriday,
    String openTimeSaturday, String closeTimeSaturday,
    String openTimeSunday, String closeTimeSunday,
    String area,
    String edit, String editid,
    String uid, Function(List<ImageData>, List<RestaurantsData>, String id) callback, Function(String) callbackError) async {

  var url = '${serverPath}restaurantSave';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
    "name": name,
    "imageid": image,
    "desc" : desc,
    "published": published,
    "phone" : phone,
    "mobilephone" : mobilephone,
    "address" : address,
    "lat" : lat,
    "lng" : lng,
    "fee" : fee,
    "percent" : percent,
    "openTimeMonday" : openTimeMonday,
    "closeTimeMonday" : closeTimeMonday,
    "openTimeTuesday" : openTimeTuesday,
    "closeTimeTuesday" : closeTimeTuesday,
    "openTimeWednesday" : openTimeWednesday,
    "closeTimeWednesday" : closeTimeWednesday,
    "openTimeThursday" : openTimeThursday,
    "closeTimeThursday" : closeTimeThursday,
    "openTimeFriday" : openTimeFriday,
    "closeTimeFriday" : closeTimeFriday,
    "openTimeSaturday" : openTimeSaturday,
    "closeTimeSaturday" : closeTimeSaturday,
    "openTimeSunday" : openTimeSunday,
    "closeTimeSunday" : closeTimeSunday,
    "area" : area,
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
      if (jsonResult["error"] != "0")
        return callbackError(jsonResult["error"]);
      ResponseRestaurants ret = ResponseRestaurants.fromJson(jsonResult);
      callback(ret.images, ret.restaurants, ret.id);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

