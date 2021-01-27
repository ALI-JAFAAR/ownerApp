import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/server/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';

foodsLoad(String uid,
    Function(List<ImageData>, List<FoodsData>, List<RestaurantData>, List<ExtrasGroupData>, List<NutritionGroupData>, int numberOfDigits) callback,
    Function(String) callbackError) async {

  var url = '${serverPath}foodsList';
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
      if (jsonResult["error"] != "0")
        return callbackError(jsonResult["error"]);
      ResponseFoods ret = ResponseFoods.fromJson(jsonResult);
      callback(ret.images, ret.foods, ret.restaurants, ret.extrasGroupData, ret.nutritionGroupData, ret.numberOfDigits);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class ResponseFoods {
  String error;
  String id;
  List<ImageData> images;
  List<FoodsData> foods;
  List<RestaurantData> restaurants;
  List<ExtrasGroupData> extrasGroupData;
  List<NutritionGroupData> nutritionGroupData;
  int numberOfDigits;

  ResponseFoods({this.error, this.images, this.foods, this.id,
    this.restaurants, this.extrasGroupData, this.nutritionGroupData, this.numberOfDigits});

  factory ResponseFoods.fromJson(Map<String, dynamic> json){

    var t = json['foods'].map((f) => FoodsData.fromJson(f)).toList();
    var _foods = t.cast<FoodsData>().toList();

    t = json['images'].map((f) => ImageData.fromJson(f)).toList();
    var _images = t.cast<ImageData>().toList();

    t = json['restaurants'].map((f) => RestaurantData.fromJson(f)).toList();
    var _restaurants = t.cast<RestaurantData>().toList();

    t = json['extrasGroup'].map((f) => ExtrasGroupData.fromJson(f)).toList();
    var _extrasGroupData = t.cast<ExtrasGroupData>().toList();

    t = json['nutritionGroup'].map((f) => NutritionGroupData.fromJson(f)).toList();
    var _nutritionGroupData = t.cast<NutritionGroupData>().toList();

    return ResponseFoods(
      error: json['error'].toString(),
      id: json['id'].toString(),
      images: _images,
      foods: _foods,
      restaurants: _restaurants,
      extrasGroupData: _extrasGroupData,
      nutritionGroupData: _nutritionGroupData,
      numberOfDigits: toInt(json['numberOfDigits'].toString()),
    );
  }
}

class FoodsData {
  String id;
  String updatedAt;
  String name;
  int imageid;
  String price;
  String desc;
  int restaurant;
  int category;
  String ingredients;
  String visible;
  int extras;
  int nutrition;

  FoodsData({this.id, this.name, this.updatedAt, this.desc, this.imageid, this.price,
    this.ingredients, this.visible, this.extras, this.nutrition,
    this.restaurant, this.category
  });
  factory FoodsData.fromJson(Map<String, dynamic> json) {
    return FoodsData(
      id : json['id'].toString(),
      updatedAt : json['updated_at'].toString(),
      name: json['name'].toString(),
      imageid: toInt(json['imageid'].toString()),
      price : json['price'].toString(),
      desc : json['desc'].toString(),
      ingredients : json['ingredients'].toString(),
      visible : json['published'].toString(),
      extras : toInt(json['extras'].toString()),
      nutrition : toInt(json['nutritions'].toString()),
      restaurant : toInt(json['restaurant'].toString()),
      category : toInt(json['category'].toString()),
    );
  }
}

class RestaurantData {
  int id;
  String updatedAt;
  String name;
  String imageId;
  String published;

  RestaurantData({this.id, this.name, this.updatedAt, this.imageId, this.published});
  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      id : toInt(json['id'].toString()),
      updatedAt : json['updatedAt'].toString(),
      name: json['name'].toString(),
      imageId: json['imageId'].toString(),
      published : json['published'].toString(),
    );
  }
}


class ExtrasGroupData {
  int id;
  String updatedAt;
  String name;
  int restaurant;

  ExtrasGroupData({this.id, this.name, this.updatedAt, this.restaurant});
  factory ExtrasGroupData.fromJson(Map<String, dynamic> json) {
    return ExtrasGroupData(
      id : toInt(json['id'].toString()),
      updatedAt : json['updated_at'].toString(),
      name: json['name'].toString(),
      restaurant: toInt(json['restaurant'].toString()),
    );
  }
}

class NutritionGroupData {
  int id;
  String updatedAt;
  String name;

  NutritionGroupData({this.id, this.name, this.updatedAt});
  factory NutritionGroupData.fromJson(Map<String, dynamic> json) {
    return NutritionGroupData(
      id : toInt(json['id'].toString()),
      updatedAt : json['updatedAt'].toString(),
      name: json['name'].toString(),
    );
  }
}
