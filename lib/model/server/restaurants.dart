import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'category.dart';

restaurantsLoad(String uid, Function(List<ImageData>, List<RestaurantsData>) callback, Function(String) callbackError) async {

  var url = '${serverPath}restaurantsList';
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
      ResponseRestaurants ret = ResponseRestaurants.fromJson(jsonResult);
      callback(ret.images, ret.restaurants);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class ResponseRestaurants {
  String error;
  String id;
  List<ImageData> images;
  List<RestaurantsData> restaurants;
  ResponseRestaurants({this.error, this.images, this.restaurants, this.id});
  factory ResponseRestaurants.fromJson(Map<String, dynamic> json){

    var t = json['restaurants'].map((f) => RestaurantsData.fromJson(f)).toList();
    var _restaurants = t.cast<RestaurantsData>().toList();

    t = json['images'].map((f) => ImageData.fromJson(f)).toList();
    var _images = t.cast<ImageData>().toList();

    return ResponseRestaurants(
      error: json['error'].toString(),
      id: json['id'].toString(),
      images: _images,
      restaurants: _restaurants
    );
  }
}

class RestaurantsData {
  String id;
  String updatedAt;
  String name;
  String address;
  String published;
  double lat;
  double lng;
  int imageid;
  String phone;
  String desc;
  String mobilephone;
  String fee;

  String openTimeMonday;
  String closeTimeMonday;
  String openTimeTuesday;
  String closeTimeTuesday;
  String openTimeWednesday;
  String closeTimeWednesday;
  String openTimeThursday;
  String closeTimeThursday;
  String openTimeFriday;
  String closeTimeFriday;
  String openTimeSaturday;
  String closeTimeSaturday;
  String openTimeSunday;
  String closeTimeSunday;
  //
  int area;
  double distance;
  String percent;

  RestaurantsData({this.id, this.name, this.address, this.published, this.lat, this.lng, this.imageid, this.phone, this.mobilephone,
    this.desc, this.updatedAt, this.fee, this.percent,
    this.openTimeMonday, this.closeTimeMonday,
    this.openTimeTuesday, this.closeTimeTuesday,
    this.openTimeWednesday, this.closeTimeWednesday,
    this.openTimeThursday, this.closeTimeThursday,
    this.openTimeFriday, this.closeTimeFriday,
    this.openTimeSaturday, this.closeTimeSaturday,
    this.openTimeSunday, this.closeTimeSunday, this.area, this.distance = 1
  });
  factory RestaurantsData.fromJson(Map<String, dynamic> json) {

    var _lat = 0.0;
    var _lng = 0.0;
    try{
      _lat = double.parse(json['lat']);
      _lng = double.parse(json['lng']);
    }catch(ex){
      dprint (ex.toString());
    }

    return RestaurantsData(
      id : json['id'].toString(),
      fee : json['fee'].toString(),
      percent : json['percent'].toString(),
      updatedAt : json['updated_at'].toString(),
      name: json['name'].toString(),
      desc: json['desc'].toString(),
      address: json['address'].toString(),
      published : json['published'].toString(),
      lat: _lat,
      lng: _lng,
      imageid: toInt(json['imageid'].toString()),
      phone: json['phone'].toString(),
      mobilephone: json['mobilephone'].toString(),
      openTimeMonday: json['openTimeMonday'].toString(),
      closeTimeMonday: json['closeTimeMonday'].toString(),
      openTimeTuesday: json['openTimeTuesday'].toString(),
      closeTimeTuesday: json['closeTimeTuesday'].toString(),
      openTimeWednesday: json['openTimeWednesday'].toString(),
      closeTimeWednesday: json['closeTimeWednesday'].toString(),
      openTimeThursday: json['openTimeThursday'].toString(),
      closeTimeThursday: json['closeTimeThursday'].toString(),
      openTimeFriday: json['openTimeFriday'].toString(),
      closeTimeFriday: json['closeTimeFriday'].toString(),
      openTimeSaturday: json['openTimeSaturday'].toString(),
      closeTimeSaturday: json['closeTimeSaturday'].toString(),
      openTimeSunday: json['openTimeSunday'].toString(),
      closeTimeSunday: json['closeTimeSunday'].toString(),
      area: toInt(json['area'].toString()),
    );
  }

  int compareTo(RestaurantsData b){
    if (distance > b.distance)
      return 1;
    if (distance < b.distance)
      return -1;
    return 0;
  }



}
