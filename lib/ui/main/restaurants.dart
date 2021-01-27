import 'dart:math';
import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/geolocator.dart';
import 'package:delivery_owner/model/server/category.dart';
import 'package:delivery_owner/model/server/restaurantDelete.dart';
import 'package:delivery_owner/model/server/restaurantSave.dart';
import 'package:delivery_owner/model/server/restaurants.dart';
import 'package:delivery_owner/model/server/uploadImage.dart';
import 'package:delivery_owner/ui/widgets/colorloader2.dart';
import 'package:delivery_owner/ui/widgets/easyDialog2.dart';
import 'package:delivery_owner/ui/widgets/iboxCircle.dart';
import 'package:delivery_owner/ui/widgets/ibutton3.dart';
import 'package:delivery_owner/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_owner/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;

class RestaurantsScreen extends StatefulWidget {
  final Function(String) callback;
  final String param1;
  RestaurantsScreen({Key key, this.callback, this.param1}) : super(key: key);

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {

  double windowWidth = 0.0;
  double windowHeight = 0.0;
  List<ImageData> _image;
  List<RestaurantsData> _restaurants;

  //
  var editControllerName = TextEditingController();
  var editControllerAddress = TextEditingController();
  var editControllerPhone = TextEditingController();
  var editControllerLng = TextEditingController();
  var editControllerLat = TextEditingController();
  var editControllerDesc = TextEditingController();
  var editControllerFee = TextEditingController();
  var editControllerMobilePhone = TextEditingController();
  var editControllerArea = TextEditingController();
  var editControllerMondayOpen = TextEditingController();
  var editControllerMondayClose = TextEditingController();
  //
  var _percents = false;
  var _published = true;
  String _imagePath = "";
  String _serverImagePath = "";
  String _imageId = "";
  bool _wait = false;
  String _searchValue = "";
  var _editItem = false;
  var _editItemId = "";
  var _ensureVisibleId = "";
  var scrollController = ScrollController();
  final picker = ImagePicker();
  String _mapStyle;
  GoogleMapController _controller;
  double _currentZoom = 12;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(48.895605, 2.087823), zoom: 12,); // paris coordinates
  String selectLatLng = "true";
  Set<Marker> markers = {};
  LatLng _currentPos;
  MarkerId _lastMarkerId;
  double _show = 0;
  Widget _dialogBody = Container();
  var location = Location();
  bool _searchPublished = true;
  bool _searchHidden = true;
  var _time = "12:00";
  List<String> _openTimes = ["12:00", "12:00", "12:00", "12:00",
    "12:00", "12:00", "12:00", "12:00", "12:00", "12:00", "12:00", "12:00", "12:00", "12:00"];
  var _state = "root";
  var _lastState = "root";
  bool _posSelected = false;

  @override
  void initState() {
    if (widget.param1 == "edit1")
      _waits(true);
    _loadRestaurantsList();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    if (_controller != null)
      if (theme.darkMode)
        _controller.setMapStyle(_mapStyle);
      else
        _controller.setMapStyle(null);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    editControllerName.dispose();
    editControllerDesc.dispose();
    editControllerAddress.dispose();
    editControllerPhone.dispose();
    editControllerLng.dispose();
    editControllerLat.dispose();
    editControllerFee.dispose();
    editControllerMobilePhone.dispose();
    editControllerArea.dispose();
    editControllerMondayOpen.dispose();
    editControllerMondayClose.dispose();
    super.dispose();
  }

  _selectPositionOnMap() {
    _state = "map";
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
              child: _map()),

        if (_state != "map")
            Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50, left: 15, right: 15),
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  controller: scrollController,
                  children: _body(),
                )),

            buttonBack(_onBack),

            if (_wait)
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
                ),

            IEasyDialog2(setPosition: (double value) {_show = value;}, getPosition: () {return _show;},
              color: theme.colorGrey, body: _dialogBody, backgroundColor: theme.colorBackground,),

          ],
        ));
  }

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {});
  }

  _getImage(int imageid) {
    if (_image != null)
      for (var item in _image)
        if (item.id == imageid)
          return "$serverImages${item.filename}";
    return serverImgNoImage;
  }

  _backButtonPress() {
    _posSelected = true;
    _onBack();
  }

  _onBack() {
    if (widget.param1 == "edit1")
      return widget.callback("home");
    if (_state == "root")
      return widget.callback("home");
    if (_state == "viewRestaurantsList")
      _state = "root";
    if (_state == "addRestaurant")
      _state = "root";
    if (_state == "editRestaurant")
      _state = "viewRestaurantsList";
    if (_state == "map")
      _state = "editRestaurant";
    setState(() {});
  }

  _body() {
    if (widget.param1 == "edit1") {
      if (_restaurants == null)
        return List<Widget>();
      return _addRestaurant();
    }
    switch (_state) {
      case "viewRestaurantsList":
        return _viewRestaurantsList();
        break;
      case "addRestaurant":
        return _addRestaurant();
        break;
      case "editRestaurant":
        return _addRestaurant();
        break;
      default:
        return _bodyRoot();
    }
  }

  _changeState(String state) {
    if (state != _lastState) {
      _state = state;
      _clearVariables();
      setState(() {});
    }
  }

  _clearVariables() {
    editControllerName.text = "";
    editControllerDesc.text = "";
    editControllerAddress.text = "";
    editControllerPhone.text = "";
    editControllerLng.text = "";
    editControllerLat.text = "";
    //
    _published = true;
    _imagePath = "";
    _serverImagePath = "";
    _imageId = "";
    _editItem = false;
    _editItemId = "";
    _searchValue = "";
    _ensureVisibleId = "";
  }

  _loadRestaurantsList() {
    restaurantsLoad(
        account.token, (List<ImageData> image, List<RestaurantsData> rest) {
      _image = image;
      _restaurants = rest;
      if (widget.param1 == "edit1") {
        _editRestaurant("1");
        _waits(false);
      }
      setState(() {});
    }, _openDialogError);
  }

  _openDialogError(String _text) {
    _waits(false);
    if (_text == '5') // You have no permissions
      _text = strings.get(250);
    if (_text == '6') // This is demo application. Your can not modify this section.
      _text = strings.get(248);
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

  _searchBar() {
    return formSearch((String value) {
      _searchValue = value.toUpperCase();
      _ensureVisibleId = "";
      setState(() {});
    });
  }

  _viewRestaurantsList() {
    var list = List<Widget>();
    var _needShow = 0.0;
    if (_restaurants != null){
      list.add(_titlePath("${strings.get(207)} > ${strings.get(207)}"));  // "Restaurants",  // "Restaurants",
      list.add(_searchBar());  // Search
      list.add(SizedBox(height: 20,));
      list.add(Row(children: [
        checkBox(strings.get(174), _searchPublished, (bool value){
          _searchPublished = value;
          setState(() {});
        }),  // "PUBLISHED",
        checkBox(strings.get(175), _searchHidden, (bool value){
          _searchHidden = value;
          setState(() {});
        }),  // "HIDDEN",
      ],));
      list.add(SizedBox(height: 20,));
      var count = 0;
      for (var item in _restaurants){
        if (!_searchPublished && item.published == '1')
          continue;
        if (!_searchHidden && item.published == '0')
          continue;
        if (item.name.toUpperCase().contains(_searchValue)){
          if (_ensureVisibleId == item.id.toString()) {
            if (count > 0)
              _needShow = 60.0+(290)*count-290;
            else
              _needShow = 60.0+(290)*count;
            dprint("${item.id} $count");
          }
          count++;
          list.add(Container(
            height: 120+90.0,
            child: oneItem("${strings.get(163)}${item.id}", item.name, "${strings.get(164)}${item.updatedAt}", _getImage(item.imageid),
                windowWidth, item.published),)
          ); // "Last update: ",
          list.add(SizedBox(height: 10,));
          list.add(Container(
              height: 50,
              child: buttonsEditOrDelete(item.id.toString(), _editRestaurant, _deleteDialog, windowWidth)));
          list.add(SizedBox(height: 20,));
        }
      }
    }
    if (_needShow != null && _ensureVisibleId != "")
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.jumpTo(_needShow+100);
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(_needShow, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        });
      });

    dprint("_needShow = $_needShow");
    list.add(SizedBox(height: 200,));
    return list;
  }

  _titlePath(String text) {
    return Container(
      child: Text(text, style: theme.text14),
    );
  }

  _map(){
    _getCurrentLocation();
    return Stack(
      children: [
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
          alignment: Alignment.centerLeft,
          child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  _buttonBack(),
                  _buttonMyLocation(),
                ],
              )
          ),
        ),

        if (selectLatLng == "true")
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
                    Text(
                      (_currentPos != null ) ? "${strings.get(129)} \n ${_currentPos.latitude.toStringAsFixed(6)}, ${_currentPos.longitude.toStringAsFixed(6)}" : "${strings.get(129)}",
                      style: theme.text14bold, textAlign: TextAlign.center,) // "Select Place and Go Back",
                )
            ),
          ),
      ],
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

  _selectPos(LatLng pos){
    markers.clear();
    _currentPos = pos;
    _lastMarkerId = MarkerId("addr${pos.latitude}");
    final marker = Marker(
        markerId: _lastMarkerId,
        position: LatLng(pos.latitude, pos.longitude),
        onTap: () {

        }
    );
    markers.add(marker);
    setState(() {
    });
  }

  _map2(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: false, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        onCameraMove:(CameraPosition cameraPosition){
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {
          if (selectLatLng == "true")
            _selectPos(pos);
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

  _editRestaurant(String id) {
    for (var item in _restaurants)
      if (item.id.toString() == id) {
        editControllerName.text = item.name;
        editControllerDesc.text = item.desc;
        editControllerPhone.text = item.phone;
        editControllerMobilePhone.text = item.mobilephone;
        editControllerAddress.text = item.address;
        editControllerLat.text = item.lat.toString();
        editControllerLng.text = item.lng.toString();
        editControllerFee.text = item.fee;
        if (item.percent == "1") _percents = true; else _percents = false;
        _openTimes[0] = item.openTimeMonday;
        _openTimes[1] = item.closeTimeMonday;
        _openTimes[2] = item.openTimeTuesday;
        _openTimes[3] = item.closeTimeTuesday;
        _openTimes[4] = item.openTimeWednesday;
        _openTimes[5] = item.closeTimeWednesday;
        _openTimes[6] = item.openTimeThursday;
        _openTimes[7] = item.closeTimeThursday;
        _openTimes[8] = item.openTimeFriday;
        _openTimes[9] = item.closeTimeFriday;
        _openTimes[10] = item.openTimeSaturday;
        _openTimes[11] = item.closeTimeSaturday;
        _openTimes[12] = item.openTimeSunday;
        _openTimes[13] = item.closeTimeSunday;
        editControllerArea.text = item.area.toString();
        if (item.published == '1') _published = true; else _published = false;
        _imagePath = "";
        _serverImagePath = "";
        for (var image in _image)
          if (image.id == item.imageid) {
            _serverImagePath = "$serverImages${image.filename}";
            _imageId = image.id.toString();
          }
        _state = "editRestaurant";
        _editItem = true;
        _editItemId = id;
        setState(() {});
      }
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

  _buttonBack(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Center(child: Text(strings.get(178), style: theme.text14bold,))),
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
                  _backButtonPress();
                }, // needed
              )),
        )
      ],
    );
  }

  _deleteRestaurant(String id) {
    restaurantDelete(id,
            (List<ImageData> image, List<RestaurantsData> restaurants) {
          _image = image;
          _restaurants = restaurants;
          _waits(false);
        }, _openDialogError);
  }

  _addRestaurant() {
    var list = List<Widget>();
    list.add(_titlePath(
        (_editItem) ? "${strings.get(207)} > ${strings.get(208)}" :
        "${strings.get(207)} > ${strings.get(209)}")); // "Restaurants",   Edit Add
    list.add(SizedBox(height: 20,));
    list.add(Text((_editItem) ? strings.get(208) : strings.get(209),
      style: theme.text16bold,
      textAlign: TextAlign.center,)); // "Add edit Restaurant
    list.add(SizedBox(height: 20,));
    //
    list.add(formEdit(strings.get(113), editControllerName, "", 100)); // Name
    list.add(Row(children: [
      Text(strings.get(210), style: theme.text12bold,), // "Enter Restaurant Name",
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    //
    if (_posSelected){
      editControllerLat.text = (_currentPos != null) ? _currentPos.latitude.toString() : "";
      editControllerLat.selection = TextSelection.fromPosition(
        TextPosition(offset: editControllerLat.text.length),
      );
      editControllerLng.text = (_currentPos != null) ? _currentPos.longitude.toString() : "";
      editControllerLng.selection = TextSelection.fromPosition(
        TextPosition(offset: editControllerLng.text.length),
      );
    }
    list.add(SizedBox(height: 20,));
    list.add(formEditLatitude(strings.get(118), editControllerLat, "")); // Latitude
    list.add(Row(children: [
      Text(strings.get(119), style: theme.text12bold,), //  "Enter Latitude. Example: 52.2165157",
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    //
    list.add(formEditLatitude(strings.get(120), editControllerLng, "")); // Longitude
    list.add(Row(children: [
      Text(strings.get(121), style: theme.text12bold,), //  "Enter Longitude. Example: 2.331359",
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    //
    list.add(Container(
      margin: EdgeInsets.only(right: 15),
      alignment: Alignment.bottomRight,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(122)  ,                                       // Select position on Map
          textStyle: theme.text14boldWhite,
          pressButton: (){
            _selectPositionOnMap();
          }
      ),
    ));
    //
    if (widget.param1 != "edit1") {
      list.add(SizedBox(height: 20,));
      list.add(checkBox(strings.get(171), _published, (bool value) {      // "Published item",
        setState(() {
          _published = value;
        });
      }));
    }
    //
    list.add(SizedBox(height: 40,));
    list.add(Text(strings.get(215), style: theme.text12bold,),); // "The following fields are optional:"
    list.add(SizedBox(height: 20,));
    //
    list.add(formEdit(strings.get(115), editControllerAddress, "", 100)); // "Address",
    list.add(Text(strings.get(116), style: theme.text12bold,),); // "Enter Restaurant Address",
    //
    list.add(SizedBox(height: 20,));
    list.add(formEditPhone(strings.get(63), editControllerPhone, "", 100)); // "Phone",
    list.add(Text(strings.get(117), style: theme.text12bold,),); // "Enter Restaurant Phone",
    //
    list.add(SizedBox(height: 20,));
    list.add(formEditPhone(strings.get(148), editControllerMobilePhone, "", 100)); // "Mobile Phone",
    list.add(Text(strings.get(130), style: theme.text12bold,),); // "Enter Restaurant Mobile Phone",
    //
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(169), editControllerDesc, strings.get(170), 250)); // Description - "Enter description",
    //
    list.add(SizedBox(height: 20,));
    list.add(formEditNumbers(strings.get(211), editControllerFee, strings.get(212), 250, _onChangeTextFee)); // "Insert Delivery Fee",
    //
    list.add(checkBox(strings.get(213), _percents, (bool value){   // "Percents",
      _percents = value;
      setState(() {});
    }));
    //
    list.add(Text(strings.get(214), style: theme.text14,
      textAlign: TextAlign.start,)); // "Delivery fee may be in percentages from order or a given amount.",
    list.add(Text(strings.get(216), style: theme.text14,),); // "If `percent` CheckBox is clear, the delivery fee in application set a given amount.",
    list.add(SizedBox(height: 5,));
    list.add(Row(
      children: [
        Text(strings.get(217), style: theme.text14bold,),
        SizedBox(width: 5,),
        Text("${(editControllerFee.text.isEmpty) ? "0" : editControllerFee.text} ${(_percents) ? "%" : ""}", style: theme.text14,),
      ],
    )); // "Current:",
    //
    list.add(SizedBox(height: 20,));
    list.add(formEditNumbers(strings.get(218), editControllerArea, strings.get(219), 250, (String _){})); // "Delivery Area",  "Select delivery Area in km or miles (Select in Admin Panel)",
    //
    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(173), style: theme.text14, textAlign: TextAlign.start,)); // "Current Image",
    list.add(Container(child: drawImage(_imagePath, _serverImagePath, windowWidth)));
    list.add(SizedBox(height: 20,));
    list.add(selectImage(windowWidth, _makeImageDialog)); // select image
    list.add(SizedBox(height: 20,));
    //
    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(220), style: theme.text12bold,),); // Opening Time:
    list.add(SizedBox(height: 10,));
    list.add(_openTimesLine(strings.get(221), 0, 1));  // "Monday:"
    list.add(_openTimesLine(strings.get(223), 2, 3));  // Tuesday:
    list.add(_openTimesLine(strings.get(224), 4, 5));  // "Wednesday:",
    list.add(_openTimesLine(strings.get(225), 6, 7));  // "Thursday:",
    list.add(_openTimesLine(strings.get(226), 8, 9));  // "Friday:",
    list.add(_openTimesLine(strings.get(227), 10, 11));  // "Saturday:",
    list.add(_openTimesLine(strings.get(228), 12, 13));  // "Sunday:",
    //
    list.add(SizedBox(height: 40,));
    list.add(IButton3(color: theme.colorPrimary,
        text: strings.get(65), // Save
        textStyle: theme.text14boldWhite,
        pressButton: _addNewRestaurant
    ));

    list.add(SizedBox(height: 150,));
    return list;
  }

  _openTimesLine(String text, int one, int two){
    return Container(
      margin: EdgeInsets.only(top: 5),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Container(
            width: windowWidth*0.3,
            child: Text(text, style: theme.text12bold,),
          ),
        Container(
            width: windowWidth*0.25,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
                onTap: () {
                  openDialogTime((String time){ setState(() { _openTimes[one] = time; });});
                },
                child: Text(_openTimes[one], style: theme.text12bold,))
        ),
        Container(
            width: windowWidth*0.25,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
                onTap: () {
                  openDialogTime((String time){ setState(() { _openTimes[two] = time; });});
                },
                child: Text(_openTimes[two], style: theme.text12bold,))
        )
      ],
    ));
  }

  openDialogTime(Function(String) callback) {
    var datePicket = CupertinoDatePicker(
      onDateTimeChanged: (DateTime picked) {
        var h = picked.hour.toString();
        if (picked.hour.toString().length == 1)
          h = "0$h";
        var m = picked.minute.toString();
        if (picked.minute.toString().length == 1)
          m = "0$m";
        _time = "$h:$m";
        callback("$h:$m");
      },
      use24hFormat: true,
      initialDateTime: DateTime(0, 0, 0, 12, 0),
      mode: CupertinoDatePickerMode.time,
    );
    _dialogBody = Column(
      children: [
        SizedBox(height: 30,),
        Container(
          width: windowWidth,
          height: 200,
          child: datePicket,
        ),
        SizedBox(height: 30,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(222),              // Confirm
            textStyle: theme.text14boldWhite,
            pressButton: (){
              callback(_time);
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

  _onChangeTextFee(String text){
    setState(() {

    });
  }

  _addNewRestaurant() {
    if (editControllerName.text.isEmpty)
      return _openDialogError(strings.get(172)); // "The Name field is request",
    if (editControllerLat.text.isEmpty)
      return _openDialogError(strings.get(229)); // "The Latitude field is request",
    if (editControllerLat.text.isEmpty)
      return _openDialogError(strings.get(230)); // "The Longitude field is request",
    _waits(true);
    if (_imagePath.isNotEmpty)
      uploadImage(_imagePath, account.token, (String path, String id) {
        _restaurantSave(id);
      }, _openDialogError);
    else
      _restaurantSave(_imageId);
  }

  _restaurantSave(String imageid) {
    restaurantSave(editControllerName.text, imageid, editControllerDesc.text, (_published) ? "1" : "0",
        editControllerPhone.text, editControllerMobilePhone.text, editControllerAddress.text, editControllerLat.text, editControllerLng.text,
        editControllerFee.text, (_percents) ? "1" : "0",
        _openTimes[0], _openTimes[1],
        _openTimes[2], _openTimes[3],
        _openTimes[4], _openTimes[5],
        _openTimes[6], _openTimes[7],
        _openTimes[8], _openTimes[9],
        _openTimes[10], _openTimes[11],
        _openTimes[12], _openTimes[13],
        (editControllerArea.text.isEmpty) ? "30" : editControllerArea.text,
        (_editItem) ? "1" : "0", _editItemId,
        account.token, (List<ImageData> image, List<RestaurantsData> restaurants, String id) {
          _image = image;
          _restaurants = restaurants;
          _state = "viewRestaurantsList";
          _ensureVisibleId = id;
          _waits(false);
          setState(() {});
        }, _openDialogError);
  }

  _makeImageDialog() {
    _dialogBody = Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(strings.get(126), textAlign: TextAlign.center,
              style: theme.text18boldPrimary,), // "Select image from",
            SizedBox(height: 50,),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: windowWidth / 2 - 25,
                        child: IButton3(
                            color: theme.colorPrimary,
                            text: strings.get(127), // "Camera",
                            textStyle: theme.text14boldWhite,
                            pressButton: () {
                              setState(() {
                                _show = 0;
                              });
                              getImage2(ImageSource.camera);
                            }
                        )),
                    SizedBox(width: 10,),
                    Container(
                        width: windowWidth / 2 - 25,
                        child: IButton3(
                            color: theme.colorPrimary,
                            text: strings.get(128), // Gallery
                            textStyle: theme.text14boldWhite,
                            pressButton: () {
                              setState(() {
                                _show = 0;
                              });
                              getImage2(ImageSource.gallery);
                            }
                        )),
                  ],
                )),
          ],
        )
    );
    setState(() {
      _show = 1;
    });
  }

  Future getImage2(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      _imagePath = pickedFile.path;
      setState(() {});
    }
  }

  _bodyRoot() {
    var list = List<Widget>();
    list.add(SizedBox(height: 20,));
    // restaurants
    list.add(oneItem(strings.get(207), "",
        "${strings.get(162)} ${(_restaurants != null)
            ? _restaurants.length
            : 0}",
        _getRandomImageFromRestaurants(), windowWidth,
        "")); // "Restaurants"  // "Total Count:"
    list.add(SizedBox(height: 5,));
    list.add(buttonsViewAllAndAddNew(() {
      _changeState("viewRestaurantsList");
    }, () {
      _changeState("addRestaurant");
    }, windowWidth));

    list.add(SizedBox(height: 150,));
    return list;
  }

  final _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  _getRandomImageFromRestaurants() {
    if (_restaurants != null && _restaurants.isNotEmpty) {
      var id = 0;
      if (_restaurants.length != 1)
        id = next(0, _restaurants.length - 1);
      var imageId = _restaurants[id].imageid;
      for (int i = 0; i < 30; i++) {
        for (var item in _image)
          if (item.id == imageId)
            return "$serverImages${item.filename}";
      }
      return serverImgNoImage;
    } else
      return serverImgNoImage;
  }

  _deleteDialog(String id) {
    if (demoMode == "true")
      return _openDialogError(strings.get(248)); // "This is demo application. Your can not modify this section.",

    _dialogBody = Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(strings.get(111), textAlign: TextAlign.center,
              style: theme.text18boldPrimary,),
            // "Are you sure?",
            SizedBox(height: 20,),
            Text(strings.get(112), textAlign: TextAlign.center,
              style: theme.text16,),
            // "You will not be able to recover this item!"
            SizedBox(height: 50,),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: windowWidth / 2 - 25,
                        child: IButton3(
                            color: Colors.red,
                            text: strings.get(109), // Yes, delete it!
                            textStyle: theme.text14boldWhite,
                            pressButton: () {
                              setState(() {
                                _show = 0;
                              });
                              _ensureVisibleId = "";
                              if (_state == "viewRestaurantsList")
                                _deleteRestaurant(id);
                            }
                        )),
                    SizedBox(width: 10,),
                    Container(
                        width: windowWidth / 2 - 25,
                        child: IButton3(
                            color: theme.colorPrimary,
                            text: strings.get(110), // No, cancel plx!
                            textStyle: theme.text14boldWhite,
                            pressButton: () {
                              setState(() {
                                _show = 0;
                              });
                            }
                        )),
                  ],
                )),

          ],
        )
    );
    setState(() {
      _show = 1;
    });
  }
}

