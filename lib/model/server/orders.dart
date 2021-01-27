import 'package:delivery_owner/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import '../util.dart';
import 'category.dart';

ordersLoad(String uid, Function(List<OrdersData>,
    List<OrderStatusData>, List<DriversData>, List<ImageData> image,
    String currency, String rightSymbol, String distanceUnit, String googleApiKey) callback, Function(String) callbackError) async {

  var url = '${serverPath}ordersList';
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
      var ret = ResponseOrders.fromJson(jsonResult);
      callback(ret.orders, ret.orderStatus, ret.drivers,
          ret.images, ret.currency, ret.rightSymbol, ret.distanceUnit, ret.googleApiKey);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class ResponseOrders {
  String error;
  String id;
  String currency;
  String rightSymbol;
  String distanceUnit;
  String googleApiKey;
  List<OrdersData> orders;
  List<OrderStatusData> orderStatus;
  List<DriversData> drivers;
  List<ImageData> images;
  ResponseOrders({this.error, this.orders, this.id, this.currency, this.rightSymbol,
    this.distanceUnit, this.drivers, this.orderStatus, this.images, this.googleApiKey});
  factory ResponseOrders.fromJson(Map<String, dynamic> json){

    var t = json['orders'].map((f) => OrdersData.fromJson(f)).toList();
    var _orders = t.cast<OrdersData>().toList();

    t = json['orderStatus'].map((f) => OrderStatusData.fromJson(f)).toList();
    var _orderStatus = t.cast<OrderStatusData>().toList();

    t = json['drivers'].map((f) => DriversData.fromJson(f)).toList();
    var _drivers = t.cast<DriversData>().toList();

    t = json['images'].map((f) => ImageData.fromJson(f)).toList();
    var _images = t.cast<ImageData>().toList();

    return ResponseOrders(
      error: json['error'].toString(),
      id: json['id'].toString(),
      currency: json['currency'].toString(),
      distanceUnit: json['distanceUnit'].toString(),
      rightSymbol: json['rightSymbol'].toString(),
      googleApiKey: json['googleApiKey'].toString(),
      orders: _orders,
      orderStatus: _orderStatus,
      drivers: _drivers,
      images: _images,
    );
  }
}

class OrdersData {
  String id;
  String updatedAt;
  String userName;
  String user;
  String driver;
  int status;
  String tax;
  String hint;
  String restaurant;
  String method;
  String total;
  String fee;
  String address;
  String phone;
  double latRest;
  double lngRest;
  String addressDest;
  double latDest;
  double lngDest;
  String percent;
  String curbsidePickup;
  String arrived;
  String couponName;
  //
  double distance;
  List<OrdersDetailsData> ordersData;

  OrdersData({this.id, this.updatedAt, this.user, this.driver, this.status, this.tax, this.hint,
        this.restaurant, this.method, this.total, this.fee, this.address, this.phone, this.latRest,
        this.lngRest, this.percent, this.curbsidePickup, this.arrived, this.couponName, this.userName,
        this.addressDest, this.distance = 0, this.ordersData, this.latDest, this.lngDest
  });
  factory OrdersData.fromJson(Map<String, dynamic> json) {
    var t = json['ordersData'].map((f) => OrdersDetailsData.fromJson(f)).toList();
    var _ordersData = t.cast<OrdersDetailsData>().toList();
    return OrdersData(
        id : json['id'].toString(),
        updatedAt : json['updated_at'].toString(),
        user : json['user'].toString(),
        userName : json['userName'].toString(),
        driver : json['driver'].toString(),
        status : toInt(json['status'].toString()),
        tax : json['tax'].toString(),
        hint : json['hint'].toString(),
        restaurant : json['restaurant'].toString(),
        method : json['method'].toString(),
        total : json['total'].toString(),
        fee : json['fee'].toString(),
        phone : json['phone'].toString(),
        address : json['address'].toString(),
        latRest : toDouble(json['latRest'].toString()),
        lngRest : toDouble(json['lngRest'].toString()),
        addressDest : json['addressDest'].toString(),
        latDest : toDouble(json['lat'].toString()),
        lngDest : toDouble(json['lng'].toString()),
        percent : json['percent'].toString(),
        curbsidePickup : json['curbsidePickup'].toString(),
        arrived : json['arrived'].toString(),
        couponName : json['couponName'].toString(),
        ordersData: _ordersData,
    );
  }
}

class OrdersDetailsData {
  String id;
  String updatedAt;
  String order;
  String food;
  String count;
  String foodprice;
  String extras;
  String extrascount;
  String extrasprice;
  String foodid;
  String extrasid;
  String image;

  OrdersDetailsData({this.id, this.updatedAt, this.order, this.food, this.count, this.foodprice, this.extras,
    this.extrascount, this.extrasprice, this.foodid, this.extrasid, this.image
  });
  factory OrdersDetailsData.fromJson(Map<String, dynamic> json) {
    return OrdersDetailsData(
        id : json['id'].toString(),
        updatedAt : json['updated_at'].toString(),
        order : json['order'].toString(),
        food : json['food'].toString(),
        count : json['count'].toString(),
        foodprice : json['foodprice'].toString(),
        extras : json['extras'].toString(),
        extrascount : json['extrascount'].toString(),
        extrasprice : json['extrasprice'].toString(),
        foodid : json['foodid'].toString(),
        extrasid : json['extrasid'].toString(),
        image : json['image'].toString(),
    );
  }
}

class OrderStatusData {
  int id;
  String status;

  OrderStatusData({this.id, this.status
  });
  factory OrderStatusData.fromJson(Map<String, dynamic> json) {
    return OrderStatusData(
      id : toInt(json['id'].toString()),
      status : json['status'].toString(),
    );
  }
}

class DriversData {
  String id;
  String name;
  int imageid;
  String phone;
  String active;

  DriversData({this.id, this.name, this.imageid, this.phone, this.active
  });
  factory DriversData.fromJson(Map<String, dynamic> json) {
    return DriversData(
      id : json['id'].toString(),
      name : json['name'].toString(),
      imageid : json['imageid'],
      phone : json['phone'].toString(),
      active : json['active'].toString(),
    );
  }
}


