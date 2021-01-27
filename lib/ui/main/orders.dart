import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/geolocator.dart';
import 'package:delivery_owner/model/server/category.dart';
import 'package:delivery_owner/model/server/changeDriver.dart';
import 'package:delivery_owner/model/server/changeStatus.dart';
import 'package:delivery_owner/model/server/orders.dart';
import 'package:delivery_owner/model/util.dart';
import 'package:delivery_owner/ui/main/home.dart';
import 'package:delivery_owner/ui/widgets/ICard22.dart';
import 'package:delivery_owner/ui/widgets/ICard23.dart';
import 'package:delivery_owner/ui/widgets/ICard24.dart';
import 'package:delivery_owner/ui/widgets/ICard27.dart';
import 'package:delivery_owner/ui/widgets/ICard28FileCaching.dart';
import 'package:delivery_owner/ui/widgets/colorloader2.dart';
import 'package:delivery_owner/ui/widgets/easyDialog2.dart';
import 'package:delivery_owner/ui/widgets/iboxCircle.dart';
import 'package:delivery_owner/ui/widgets/ibutton3.dart';
import 'package:delivery_owner/ui/widgets/iline.dart';
import 'package:delivery_owner/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:delivery_owner/main.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class OrdersScreen extends StatefulWidget {
  final Function(String) callback;
  OrdersScreen({Key key, this.callback}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

int _currentTabIndex = 0;
List<ImageData> _image;
List<OrdersData> _orders;
List<OrderStatusData> _orderStatus;
List<DriversData> _drivers;
String currency;
String _rightSymbol;
String _distanceUnit;
String _googleApiKey;

class _OrdersScreenState extends State<OrdersScreen>  with TickerProviderStateMixin{

  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _driverSelect(String id){
    print("Selected driver with id: $id");

    changeDriver(_driverSetData.id, id,
            (){
          _driverSetData.driver = id;
          setState(() {
          });
        },
        _openDialogError
    );

    _state = "orderDetails";
    setState(() {

    });
  }


  _onCallback(String id){
    print("User tap on order card with id: $id");
    _currentOrder = id;
    _state = "orderDetails";
    setState(() {
    });
  }

  _onMapClick(String id){
    print("User click On Map button with id: $id");
    _state = "map";
    _addToMap();
    for (var item in _orders)
      if (item.id == id)
        _kGooglePlex = CameraPosition(target: LatLng(item.latDest, item.lngDest), zoom: _currentZoom,); // paris coordinates
    setState(() {
    });
  }

  OrdersData _driverSetData;

  _setDriver(OrdersData _data){
    _driverSetData = _data;
    _state = "drivers";
    setState(() {
    });
  }

  _tabIndexChanged(){
    print("Tab index is changed. New index: ${_tabController.index}");
    setState(() {
    });
    _currentTabIndex = _tabController.index;
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController _tabController;
  final editController = TextEditingController();
  Widget _dialogBody = Container();
  bool _wait = false;
  double _show = 0;
  String _state = "root";
  String _currentOrder = "";

  @override
  void initState() {
    _loadOrdersList();
    if (_orders == null)
      _waits(true);
    _tabController = TabController(vsync: this, length: 7);
    _tabController.addListener(_tabIndexChanged);
    _tabController.animateTo(_currentTabIndex);
    account.addOrdersCallback(_loadOrdersList);
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
      if (_controller != null)
        if (theme.darkMode)
          _controller.setMapStyle(_mapStyle);
        else
          _controller.setMapStyle(null);
    });

    super.initState();
  }

  _loadOrdersList() {
    ordersLoad(
        account.token, (List<OrdersData> orders, List<OrderStatusData> orderStatus, List<DriversData> drivers, List<ImageData> image,
        String _currency, String rightSymbol, String distanceUnit, String googleApiKey) {
      _orders = orders;
      _drivers = drivers;
      _image = image;
      _orderStatus = orderStatus;
      currency = _currency;
      _distanceUnit = distanceUnit;
      _rightSymbol = rightSymbol;
      _googleApiKey = googleApiKey;
      _waits(false);
      setState(() {});
      _initDistance();
    }, _openDialogError);
  }

  _initDistance() async {
    await ordersSetDistance();
    setState(() {
    });
  }

  ordersSetDistance() async {
    var location = Location();
    for (var item in _orders){
      item.distance = await location.distanceBetween(item.latRest, item.lngRest, item.latDest, item.lngDest);
    }
  }

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {});
  }

  _openDialogError(String _text) {
    _waits(false);
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(66), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );
    setState(() {
      _show = 1;
    });
  }

  _onBack(){
    if (_state == "root")
        return widget.callback("home");
    if (_state == "orderDetails")
      _state = "root";
    if (_state == "drivers")
      _state = "orderDetails";
    if (_state == "map")
        _state = "orderDetails";
    setState(() {
    });
  }

  @override
  void dispose() {
    account.addOrdersCallback(null);
    _controller?.dispose();
    editController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dprint ("orders build");
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
      if (_show != 0) {
        setState(() {
          _show = 0;
        });
        return false;
      }
      _onBack();
      return false;
    },
    child: Stack(
        children: <Widget>[
          if (_state == "map")
            _map(),

          if (_state == "drivers")
            Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+20),
                child: ListView(
             children: _bodyDrivers(),
          )),

          if (_state == "orderDetails")
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+50),
              child: ListView(
              shrinkWrap: true,
              children: _bodyDetails(),
            ),),

          if (_state == "root")
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
            height: 30,
            child: TabBar(
              indicatorColor: theme.colorPrimary,
              labelColor: Colors.black,
                isScrollable: true,
              tabs: [
                Text(strings.get(41),     // "All",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(95),     // "Received",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(42),     // "Preparing",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(43),     // "Ready",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(96),     // "On the way",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(97),     // "Delivered",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(232),     // "Cancelled",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
              ],
              controller: _tabController,
            ),
          ),

          if (_state == "root")
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+90),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[

                  Container(
                    child: _body(-1),
                  ),

                  Container(
                    child: _body(1),
                  ),

                  Container(
                    child:_body(2),
                  ),

                  Container(
                    child:_body(3),
                  ),

                  Container(
                    child:_body(4),
                  ),

                  Container(
                    child:_body(5),
                  ),

                  Container(
                    child:_body(6),
                  ),

                ],

              )  ),

          buttonBack(_onBack),

          if (_wait)(
              Container(
                color: Color(0x80000000),
                width: windowWidth,
                height: windowHeight,
                child: Container(
                  alignment: Alignment.center,
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
                    color2: theme.colorCompanion,
                    color3: theme.colorPrimary,
                  ),
                ),
              )) else
            (Container()),

          IEasyDialog2(setPosition: (double value) {
            _show = value;
          },
            getPosition: () {
              return _show;
            },
            color: theme.colorGrey,
            body: _dialogBody,
            backgroundColor: theme.colorBackground,),


        ],
    ));
  }

  _body(int status){
    int size = 0;
    if (_orders != null)
      for (var _data in _orders)
        if (_data.status == status || status == -1)
          size++;

      if (size == 0)
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      height: windowHeight/3,
                      width: windowWidth/2,
                      child: Container(
                        child: Image.asset("assets/nonotify.png",
                            fit: BoxFit.contain,
                        ),
                      )
                  )),
              SizedBox(height: 20,),
              Text(strings.get(50),    // "Not Have Orders",
                  overflow: TextOverflow.clip,
                  style: theme.text16bold
                  ),
              SizedBox(height: 50,),
            ],
          )

      );
    return ListView(
      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
      children: _body2(status),
    );
  }

  _body2(int status){
    var list = List<Widget>();
    if (_orders == null)
      return list;

    for (var _data in _orders) {
      if (_data.status == status || status == -1) {
        var _balloonText = _getStatus(_data.status); // "Received"
        Color _balloonColor = theme.colorCompanion3;
        if (_data.status == 2)
          _balloonColor = theme.colorPrimary; // "Preparing"
        if (_data.status == 3)
          _balloonColor = theme.colorCompanion4; // "Ready",
        if (_data.status == 4)
          _balloonColor = theme.colorCompanion2; // "On the way",
        if (_data.status == 5)
          _balloonColor = Colors.blue; // "Delivered",
        if (_data.status == 6)
          _balloonColor = theme.colorRed; // "Canceled",

        list.add(
            ICard27(
                color: theme.colorBackgroundDialog,
                colorRoute: theme.colorPrimary,
                id: _data.id,
                text: "${strings.get(44)} #${_data.id}",    // Order ID122
                textStyle: theme.text18boldPrimary,
                text2: "${strings.get(45)}: ${_data.updatedAt}",   // Date: 2020-07-08 12:35
                text2Style: theme.text14,
                text3: (_rightSymbol == "true") ? "${_data.total}$currency" : "$currency${_data.total}",
                text3Style: theme.text18bold,
                text4: _data.method,            // cache on delivery
                text4Style: theme.text14,
                text5: "${strings.get(52)}:", // Customer name",
                text5Style: theme.text16,
                text6: _data.userName,
                text6Style: theme.text18boldPrimary,
                text7: (_data.curbsidePickup == "true") ? strings.get(235) :_data.address,  // "Curbside Pickup",
                text7Style: theme.text14,
                callback: _onCallback,
                //
                balloon: true,
              balloonColor: _balloonColor,
              balloonText: _balloonText,
              balloonStyle: theme.text14boldWhite,
            ));
      }
    }
    list.add(SizedBox(height: 100,));
    return list;
  }

  slideRightBackground(){
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset("assets/delete.png",
                      fit: BoxFit.contain, color: Colors.white
                  ))),
          SizedBox(width: 20,),
        ],
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20,),
            UnconstrainedBox(
                child: Container(
                height: 25,
                width: 25,
                child: Image.asset("assets/delete.png",
                fit: BoxFit.contain, color: Colors.white
            )))
          ],
        ),
    );
  }

  _bodyDetails(){
    var list = List<Widget>();

    for (var _data in _orders) {
      if (_currentOrder == _data.id) {
        var dist;
        if (_distanceUnit == "km")
          dist = "${(_data.distance / 1000).toStringAsFixed(3)} $_distanceUnit"; // km
        else
          dist = "${(_data.distance / 1609).toStringAsFixed(3)} $_distanceUnit"; // miles
        list.add(
            ICard22(
                curbsidePickup: _data.curbsidePickup,
                color: theme.colorBackgroundDialog,
                colorRoute: theme.colorPrimary,
                id: _data.id,
                text: "${strings.get(44)} #${_data.id}",      // Order ID122
                textStyle: theme.text18boldPrimary,
                text2: "${strings.get(45)}: ${_data.updatedAt}",   // Date: 2020-07-08 12:35
                text2Style: theme.text14,
                text3: (_rightSymbol == "true") ? "${_data.total}$currency" : "$currency${_data.total}",
                text3Style: theme.text18bold,
                text4: _data.method,      // cache on delivery
                text4Style: theme.text14,
                text5: "${strings.get(46)}:",     // Distance
                text5Style: theme.text16,
                text6: dist, // km
                text6Style: theme.text18boldPrimary,
                text7: _data.address,
                text7Style: theme.text14,
                text8: _data.addressDest,
                text8Style: theme.text14,
                button1Enable: false,
                button2Enable: true,
                button1Text: strings.get(47),   // On Map
                button1Style: theme.text14boldWhite,
                button2Style: theme.text14boldWhite,
                callbackButton2: _onMapClick
        ));
        list.add(SizedBox(height: 10,));
        _status(_data, list);
        list.add(SizedBox(height: 10,));
        list.add(ILine());
        list.add(
            ICard23(
              text: "${strings.get(52)}:", // Customer name
              textStyle: theme.text14,
              text2: "${strings.get(53)}:", // "Customer phone",
              text2Style: theme.text14,
              text3: "${_data.userName}",
              text3Style: theme.text16bold,
              text4: _data.phone,
              text4Style: theme.text16bold,
            ));
        list.add(Container(
          margin: EdgeInsets.only(left: 22, right: 22, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${strings.get(249)}:", style: theme.text14,),
              SizedBox(height: 10,),
              Text("${_data.hint}", style: theme.text16bold,)
            ],
          ),
        ));
        list.add(SizedBox(height: 10,));
        list.add(Container(
          alignment: Alignment.center,
          child: IButton3(
              color: theme.colorPrimary,
              text: strings.get(54), // "Call to Customer",
              textStyle: theme.text14boldWhite,
              pressButton: _onCallToCustomer
          ),
        ));
        list.add(SizedBox(height: 10,));
        var _dataDetails = List<ICard24Data>();
        var _total = 0.0;
        if (_data.ordersData != null){
          for (var _details in _data.ordersData)
            if (toInt(_details.count) != 0) {
              _dataDetails.add(ICard24Data(
                  currency, "$serverImages${_details.image}", _details.food,
                  toInt(_details.count),
                  toDouble(_details.foodprice)));
              _total += (toDouble(_details.foodprice) * toInt(_details.count));
            }else{
              if (toInt(_details.extrascount) != 0) {
                _dataDetails.add(ICard24Data(
                    currency, "$serverImages${_details.image}", _details.extras,
                    toInt(_details.extrascount),
                    toDouble(_details.extrasprice)));
                _total +=
                (toDouble(_details.extrasprice) * toInt(_details.extrascount));
              }
            }
        }
        var symbolDigits = 2;
        if (totals != null) symbolDigits = totals.symbolDigits;

        var _fee = "";
        if (_data.percent == "1")
          _fee = (toDouble(_data.fee)*_total/100).toStringAsFixed(symbolDigits);
        else
          _fee = toDouble(_data.fee).toStringAsFixed(symbolDigits);

        var fee = (_rightSymbol == "true") ? "$_fee$currency" : "$currency$_fee";

        var _tax = (toDouble(_data.tax)/100*_total).toStringAsFixed(symbolDigits);
        var tax = (_rightSymbol == "true") ? "$_tax$currency" : "$currency$_tax";

        var total = (_rightSymbol == "true") ? "${_data.total}$currency" : "$currency${_data.total}";
        list.add(
            ICard24(
              color: theme.colorBackgroundDialog,
              text: "${strings.get(56)}:",        // Order Details
              textStyle: theme.text18boldPrimary,
              text2Style: theme.text16,
              colorProgressBar: theme.colorPrimary,
              data: _dataDetails,
              text3Style: theme.text16,
              text3: "${strings.get(57)}:", // Subtotal
              text4: "${strings.get(58)}: $fee", // Shopping costs
              text5: "${strings.get(59)}: $tax", // Taxes
              text6: "${strings.get(60)}: $total", // Total
              text6Style: theme.text16bold,
            ));
        list.add(SizedBox(height: 15,));
        list.add(SizedBox(height: 15,));
        _backButton(list);
        list.add(SizedBox(height: 100,));
      }
    }
    return list;
  }

  _onCallToCustomer() async {
    for (var item in _orders)
      if (item.id == _currentOrder) {
        var uri = 'tel:${item.phone}';
        if (await canLaunch(uri))
          await launch(uri);
      }
  }

  _backButton(List<Widget> list){
    list.add(Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(55), // "Back To Orders",
          textStyle: theme.text14boldWhite,
          pressButton: (){
            _state = "root";
            setState(() {
            });
          }
      ),
    ));
  }

  _getStatus(int id){
    if (_orderStatus == null)
      return "";
    for (var item in _orderStatus)
      if (item.id == id)
        return item.status;
    return "";
  }

  _status(OrdersData _data, List<Widget> list) {
    var _text = "${strings.get(99)} ${strings.get(42)}"; // "Set To", "Preparing"
    var _status = _getStatus(_data.status); // "Received"
    if (_data.status == 2)  // "Preparing"
      _text = "${strings.get(99)} ${strings.get(43)}"; // "Set To", "Ready"
    if (_data.status == 3)  // "Ready",
      _text = strings.get(100); // "Set Driver"
    if (_data.status > 2)
      if (_data.curbsidePickup == "true")
        _text = _text = "${strings.get(99)} ${strings.get(97)}"; // "Set To", "Delivered"

    var _name = "";

    if (_data.driver.isNotEmpty && _data.driver != "0") {
      for (var _driver in _drivers)
        if (_driver.id == _data.driver)
          _name = _driver.name;
      _text = strings.get(231); // Change Driver
    }


    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Text("${strings.get(98)}:", style: theme.text18boldPrimary,),  // "Status",
            SizedBox(width: 10,),
            Expanded(child: Text(_status, style: theme.text16,)),
            if (_data.status != 5 && _data.status != 6)
            Container(
              width: windowWidth*0.4,
              alignment: Alignment.center,
              child: IButton3(
                  color: theme.colorPrimary,
                  text: _text,
                  textStyle: theme.text14boldWhite,
                  pressButton: () {
                    if (_data.status == 3) {
                      if (_data.curbsidePickup == "true"){
                        _changeStatus(_data, 5); // delivered
                      }else
                        _setDriver(_data);
                    }else
                      _changeStatus(_data, _data.status+1);
                  }
              ),
            )
          ],
        )
    ));
      list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_data.curbsidePickup != "true")
              Text("${strings.get(104)}:", style: theme.text18boldPrimary,),  // Driver
              SizedBox(width: 10,),
              if (_data.curbsidePickup != "true")
              Expanded(child: Text(_name, style: theme.text16,)),
              if (_data.status != 5 && _data.status != 6)
              Container(
                width: windowWidth*0.4,
                alignment: Alignment.center,
                child: IButton3(
                    color: theme.colorRed,
                    text: strings.get(232), // "Cancelled",
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      _openDialogCancelled(_data);
                    }
                ),
              )
          ],)
      ));
  }

  _changeStatus(OrdersData _data, int status){
    changeStatus(_data.id, status.toString(),
        (){
          setState(() {
            _data.status = status;
          });
        },
        _openDialogError
      );
  }

  String _searchValue = "";
  bool _searchOnline = true;
  bool _searchOffline = true;

  _searchBar(){
    return formSearch((String value){
      _searchValue = value.toUpperCase();
      setState(() {});
    });
  }

  _bodyDrivers(){
    var list = List<Widget>();
    list.add(SizedBox(height: 10,));
    list.add(Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: _searchBar()) // Search
    );
    list.add(Row(children: [
      checkBox(strings.get(102), _searchOnline, (bool value){ // "online",
        _searchOnline = value;
        setState(() {});
      }),
      checkBox(strings.get(103), _searchOffline, (bool value){  // offline
        _searchOffline = value;
        setState(() {});
      }),
    ],));
    list.add(SizedBox(height: 10,));

    for (var _data in _drivers) {
      if (!_searchOnline && _data.active == '1')
        continue;
      if (!_searchOffline && _data.active != '1')
        continue;
      if (_data.name.toUpperCase().contains(_searchValue)){
        list.add(ICard28FileCaching(
            id: _data.id,
            color: theme.colorGrey2,
            title: _data.name,
            titleStyle: theme.text14bold,
            userAvatar: _getImage(_data.imageid),
            text: _data.phone,
            textStyle: theme.text14,
            balloonColor2: (_data.active == '1') ? Colors.green : Colors.red,
            balloonText2: (_data.active == '1') ? strings.get(102) : strings.get(103), // "online", - offline
            balloonStyle2: theme.text14boldWhite,
            enable: (_data.active == '1'),
            callback: _driverSelect
        ));
      }
    }
    return list;
  }

  _openDialogCancelled(OrdersData _data) {
    _waits(false);
    _dialogBody = Column(
      children: [
        Text(strings.get(111), style: theme.text14,), // "Are you sure?",
        SizedBox(height: 40,),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: windowWidth/2-45,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(233),                  // YES
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                          _changeStatus(_data, 6);
                        }
                    )),
                SizedBox(width: 10,),
                Container(
                    width: windowWidth/2-45,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(234),              // NO
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                        }
                    )),
              ],
            )),
      ],
    );
    setState(() {
      _show = 1;
    });
  }

  _getImage(int imageid){
      if (_image != null)
        for(var item in _image)
          if (item.id == imageid)
            return "$serverImages${item.filename}";
      return serverImgNoImage;
  }

  //
  // Map
  //
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(48.895605, 2.087823), zoom: 12,); // paris coordinates
  Set<Marker> markers = {};
  GoogleMapController _controller;
  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;
  var location = Location();
  String _currentDistance = "";
  MarkerId _lastMarkerId;
  double _currentZoom = 12;
  String _mapStyle;

  Future<void> _addToMap() async {
    for (var item in _orders) {
      if (_currentOrder == item.id) {
        final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
        _polylineIdCounter++;
        final PolylineId polylineId = PolylineId(polylineIdVal);

        var polylinePoints = PolylinePoints();
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          _googleApiKey,
          PointLatLng(item.latRest, item.lngRest),
          PointLatLng(item.latDest, item.lngDest),
          travelMode: TravelMode.driving,
        );
        List<LatLng> polylineCoordinates = [];

        if (result.points.isNotEmpty) {
          result.points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }

        final Polyline polyline = Polyline(
          polylineId: polylineId,
          consumeTapEvents: true,
          color: Colors.red,
          width: 4,
          points: polylineCoordinates,
        );

        setState(() {
          _mapPolylines[polylineId] = polyline;
        });
        LatLng coordinates = LatLng(item.latRest, item.latRest);
        if (polylineCoordinates.isNotEmpty)
          coordinates = polylineCoordinates[polylineCoordinates.length ~/ 2];
        _initCameraPosition(item, coordinates);
        _addMarker(item);
      }
    }
  }

  _addMarker(OrdersData item){
    print("add marker ${item.id}");
    _lastMarkerId = MarkerId("addr1${item.id}");
    final marker = Marker(
        markerId: _lastMarkerId,
        position: LatLng(
            item.latRest, item.lngRest
        ),
        onTap: () {

        }
    );
    markers.add(marker);
    _lastMarkerId = MarkerId("addr2${item.id}");
    final marker2 = Marker(
        markerId: _lastMarkerId,
        position: LatLng(
            item.latDest, item.lngDest
        ),
        onTap: () {

        }
    );
    markers.add(marker2);
  }

  _initCameraPosition(OrdersData item, LatLng coord) async{
      // calculate zoom
      LatLng latLng_1 = LatLng(item.latRest, item.lngRest);
      LatLng latLng_2 = LatLng(item.latDest, item.lngDest);
      dprint("latLng_1 = $latLng_1");
      dprint("latLng_2 = $latLng_2");
      LatLngBounds bound;
      if (latLng_1.latitude >= latLng_2.latitude) {
        if (latLng_1.longitude <= latLng_2.longitude){
          latLng_1 = LatLng(item.latRest, item.lngDest);
          latLng_2 = LatLng(item.latDest, item.lngRest);
        }
        bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
      }else
        bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);

      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
      if (_controller != null)
        _controller.animateCamera(u2).then((void v){
          // check(u2,_controller);
        });

      double distance = await location.distanceBetween(item.latRest, item.lngRest,
          item.latDest, item.lngDest);

      if (_distanceUnit == "km")
        _currentDistance = (distance/1000).toStringAsFixed(3); // to km
      else
        _currentDistance = (distance/1609).toStringAsFixed(3); // to miles

      setState(() {
      });
    }

    _map(){
      return Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
          child: Stack(children: <Widget>[

            _map2(),

            Align(
              alignment: Alignment.topRight,
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15,),
                      _buttonPlus(),
                      _buttonMinus(),
                    ],
                  )
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15,),
                      _buttonMyLocation(),
                    ],
                  )
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15,),
                      //_buttonBack(),
                    ],
                  )
              ),
            ),

            if (_currentDistance.isNotEmpty)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: theme.colorBackgroundDialog,
                          borderRadius: new BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(40),
                              spreadRadius: 6,
                              blurRadius: 6,
                              offset: Offset(2, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child:
                        Text("${strings.get(46)}: $_currentDistance ${strings.get(49)}", style: theme.text14bold) // Distance 4 km
                    )
                ),
              ),


          ]
          )
      );
    }

  _buttonMyLocation(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.my_location, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _getCurrentLocation();
                }, // needed
              )),
        )
      ],
    );
  }

  _getCurrentLocation() async {
    var position = await location.getCurrent();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }

  _buttonPlus(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.add, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _controller.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMinus(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.remove, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _controller.animateCamera(
                    CameraUpdate.zoomOut(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _map2(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: false, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        polylines: Set<Polyline>.of(_mapPolylines.values),
        onCameraMove:(CameraPosition cameraPosition){
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {

        },
        onLongPress: (LatLng pos) {

        },
        markers: markers != null ? Set<Marker>.from(markers) : null,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode)
            _controller.setMapStyle(_mapStyle);
        });
  }
}


