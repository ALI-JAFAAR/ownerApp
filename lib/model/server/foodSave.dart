
import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'category.dart';
import 'foods.dart';

foodSave(String name, String desc, String image, String published,
    String price, String restaurant, String category, String ingredients, String extras, String nutritions,
    String edit, String editid,
    String uid, Function(List<ImageData>, List<FoodsData>, List<RestaurantData>, List<ExtrasGroupData>, List<NutritionGroupData>, String id) callback, Function(String) callbackError) async {

  var url = '${serverPath}foodSave';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
    "name": name,
    "imageid": image,
    "price": price,
    "desc" : desc,
    "restaurant" : restaurant,
    "category" : category,
    "ingredients" : ingredients,
    "published": published,
    "extras": extras,
    "nutritions": nutritions,
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
      var ret = ResponseFoods.fromJson(jsonResult);
      callback(ret.images, ret.foods, ret.restaurants, ret.extrasGroupData, ret.nutritionGroupData, ret.id);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

