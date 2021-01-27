import 'dart:math';
import 'package:delivery_owner/config/api.dart';
import 'package:delivery_owner/model/server/category.dart';
import 'package:delivery_owner/model/server/categoryDelete.dart';
import 'package:delivery_owner/model/server/categorySave.dart';
import 'package:delivery_owner/model/server/extras.dart';
import 'package:delivery_owner/model/server/extrasDelete.dart';
import 'package:delivery_owner/model/server/extrasGroupDelete.dart';
import 'package:delivery_owner/model/server/extrasGroupSave.dart';
import 'package:delivery_owner/model/server/extrasSave.dart';
import 'package:delivery_owner/model/server/foodDelete.dart';
import 'package:delivery_owner/model/server/foodSave.dart';
import 'package:delivery_owner/model/server/foods.dart';
import 'package:delivery_owner/model/server/uploadImage.dart';
import 'package:delivery_owner/ui/widgets/colorloader2.dart';
import 'package:delivery_owner/ui/widgets/easyDialog2.dart';
import 'package:delivery_owner/ui/widgets/ibutton3.dart';
import 'package:delivery_owner/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:delivery_owner/main.dart';
import 'package:image_picker/image_picker.dart';

class FoodsScreen extends StatefulWidget {
  final Function(String) callback;
  FoodsScreen({Key key, this.callback}) : super(key: key);

  @override
  _FoodsScreenState createState() => _FoodsScreenState();
}

/*
      initState()
        _loadCategoryList()
        _loadFoodsList()
        _loadExtrasList()

      // screens
      _bodyRoot()
          _viewCategoryList()               // category
              _addCategory()
                  _addNewCategory()
                      _catSave()
              _editCategory()
              _deleteCategory()
          _viewFoodList()                   // food
              _addFood()
                    _addNewFood()
                        _foodSave()
              _editFood()
              _deleteFood()
          _viewExtrasGroupList()            // extras group
              _addExtrasGroup
                    _addNewExtrasGroup
                        _extrasGroupSave
              _editExtrasGroup
              _deleteExtrasGroup()

          _viewExtrasList()            // extras
              _addExtras();
                    _addNewExtras
                      _extrasSave
                        _extrasSave2
              _editExtras
              _deleteExtras()

          _nutritionComboBoxInForm
          _extrasComboBoxInForm
          _restaurantsComboBoxInForm
          _categoryComboBoxInForm

      _onBack()
      _changeState()
      _clearVariables()

      dialogs:
        _openDialogError()
        _makeImageDialog()
        _deleteDialog()
        _filterDialog()
            _categoryComboBox()
            _restaurantsComboBox()

 */

class _FoodsScreenState extends State<FoodsScreen> {

  double windowWidth = 0.0;
  double windowHeight = 0.0;
  List<ImageData> _image;
  List<CategoriesData> _cat;
  List<FoodsData> _foods;
  List<RestaurantData> _restaurants;
  List<ExtrasGroupData> _extrasGroup;
  List<NutritionGroupData> _nutritionGroup;
  List<ExtrasData> _extras;
  int _numberOfDigits;
  var editControllerName = TextEditingController();
  var editControllerPrice = TextEditingController();
  var editControllerDesc = TextEditingController();
  var editControllerIngredients = TextEditingController();
  var _categoryValueOnForm = 0;
  var _restaurantValueOnForm = 0;
  var _extrasGroupValueOnForm = 0;
  var _nutritionGroupValueOnForm = 0;
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

  @override
  void initState() {
    _loadCategoryList();
    _loadFoodsList();
    _loadExtrasList();
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerDesc.dispose();
    editControllerPrice.dispose();
    editControllerIngredients.dispose();
    super.dispose();
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
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50, left: 15, right: 15),
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

        IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
          body: _dialogBody, backgroundColor: theme.colorBackground,),

      ],
    ));
  }

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _getImage(int imageid){
    if (_image != null)
      for(var item in _image)
        if (item.id == imageid)
          return "$serverImages${item.filename}";
    return serverImgNoImage;
  }

  _onBack(){
    if (_state == "root")
      return widget.callback("home");

    // category
    if (_state == "viewCategoryList")
      _state = "root";
    if (_state == "addCategory")
      _state = "root";
    if (_state == "editCategory")
      _state = "viewCategoryList";

    // foods
    if (_state == "viewFoodsList")
      _state = "root";
    if (_state == "addFood")
      _state = "root";
    if (_state == "editFood")
      _state = "viewFoodsList";

    // extras group
    if (_state == "viewExtrasGroupList")
      _state = "root";
    if (_state == "editExtrasGroup")
      _state = "viewExtrasGroupList";
    if (_state == "addExtrasGroup")
      _state = "root";

    // extras
    if (_state == "viewExtrasList")
      _state = "root";
    if (_state == "editExtras")
      _state = "viewExtrasList";
    if (_state == "addExtras")
      _state = "root";

    setState(() {});
  }

  var _state = "root";
  var _lastState = "root";
  _body(){
    switch(_state){
      case "viewFoodsList":
        return _viewFoodList();
      break;
      case "addFood":
        return _addFood();
        break;
      case "editFood":
        return _addFood();
        break;
      case "viewCategoryList":
        return _viewCategoryList();
        break;
      case "viewExtrasGroupList":
        return _viewExtrasGroupList();
        break;
      case "addCategory":
        return _addCategory();
        break;
      case "editCategory":
        return _addCategory();
        break;
      case "addExtrasGroup":
        return _addExtrasGroup();
        break;
      case "editExtrasGroup":
        return _addExtrasGroup();
        break;
      case "viewExtrasList":
        return _viewExtrasList();
        break;
      case "addExtras":
        return _addExtras();
        break;
      case "editExtras":
        return _addExtras();
        break;
      default:
        return _bodyRoot();
    }
  }

  _changeState(String state){
    if (state != _lastState){
      _state = state;
      _clearVariables();
      setState(() {
      });
    }
  }

  _clearVariables(){
    editControllerName.text = "";
    editControllerDesc.text = "";
    editControllerPrice.text = "";
    editControllerIngredients.text = "";
    _searchPublished = true;
    _searchHidden = true;
    _published = true;
    _imagePath = "";
    _serverImagePath = "";
    _imageId = "";
    _editItem = false;
    _editItemId = "";
    _searchValue = "";
    _categoryValueOnForm = 0;
    _restaurantValueOnForm = 0;
    _extrasGroupValueOnForm = 0;
    _nutritionGroupValueOnForm = 0;
    _ensureVisibleId = "";
  }

  _loadCategoryList(){
    categoryLoad(account.token, (List<ImageData> image, List<CategoriesData> cat){
      _image = image; _cat = cat;
      setState(() {});
    }, _openDialogError);
  }

  _loadExtrasList(){
    extrasLoad(account.token, (List<ImageData> image, List<ExtrasData> extras){
      _image = image;
      _extras = extras;
      setState(() {});
    }, _openDialogError);
  }

  _loadFoodsList(){
    foodsLoad(account.token,
            (List<ImageData> image, List<FoodsData> foods, List<RestaurantData> restaurants,
            List<ExtrasGroupData> extrasGroup, List<NutritionGroupData> nutritionGroup, int numberOfDigits){
      _image = image;
      _foods = foods;
      _restaurants = restaurants;
      _extrasGroup = extrasGroup;
      _nutritionGroup = nutritionGroup;
      _numberOfDigits = numberOfDigits;
      setState(() {});
    }, _openDialogError);
  }

  double _show = 0;
  Widget _dialogBody = Container();
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
            text: strings.get(66),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
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

  _searchBar(){
    return formSearch((String value){
        _searchValue = value.toUpperCase();
        _ensureVisibleId = "";
        setState(() {});
      });
  }

  _viewFoodList(){
      var list = List<Widget>();
      var _needShow = 0.0;
      if (_foods != null){
        list.add(_titlePath("${strings.get(94)} > ${strings.get(94)}"));  // "Foods",  // "Foods",
        list.add(_searchBar());  // Search
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
        list.add(_categoryComboBox());
        list.add(Container(
            width: windowWidth,
            child: Text(strings.get(146), style: theme.text12bold, textAlign: TextAlign.start,),                // Choose Food Category
            ));
        if (theme.multiple){
          list.add(_restaurantsComboBox());
          list.add(Container(
              width: windowWidth,
              child: Text(strings.get(179), style: theme.text12bold, textAlign: TextAlign.start,),                // "Choose Restaurant",
              ));
        }

        list.add(SizedBox(height: 20,));
        var count = 0;
        for (var item in _foods){
          if (!_searchPublished && item.visible == '1')
            continue;
          if (!_searchHidden && item.visible == '0')
            continue;
          if (_categoryValue != 0 && item.category != _categoryValue)
            continue;
          if (_restaurantValue != 0 && item.restaurant != _restaurantValue)
            continue;
          if (item.name.toUpperCase().contains(_searchValue)){
            if (_ensureVisibleId == item.id.toString()) {
              if (count > 0)
                _needShow = 60.0+(290)*count-290;//-290;
              else
                _needShow = 60.0+(290)*count;
              dprint("${item.id} $count");
            }
            count++;
            list.add(Container(
              height: 120+90.0,
              child: oneItem("${strings.get(163)}${item.id}", item.name, "${strings.get(164)}${item.updatedAt}", _getImage(item.imageid),
                windowWidth, item.visible),)
                ); // "Last update: ",
            list.add(SizedBox(height: 10,));
            list.add(Container(
              height: 50,
                child: buttonsEditOrDelete(item.id.toString(), _editFood, _deleteDialog, windowWidth)));
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

  _titlePath(String text){
    return Container(
      child: Text(text, style: theme.text14),
    );
  }

  _viewCategoryList(){
    var list = List<Widget>();
    list.add(_titlePath("${strings.get(94)} > ${strings.get(135)}"));  // "Foods",  // "Category",
    list.add(_searchBar());  // Search
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
    var _needShow = 0.0;
    if (_cat != null){
      var count = 0;
      for (var item in _cat){
        if (!_searchPublished && item.visible == '1')
          continue;
        if (!_searchHidden && item.visible == '0')
          continue;
        if (!item.name.toUpperCase().contains(_searchValue))
          continue;
        if (_ensureVisibleId == item.id.toString()) {
          if (count > 0)
            _needShow = 60.0+(290)*count-290;//-290;
          else
            _needShow = 0;
          dprint("${item.id} $count");
        }
        count++;
        list.add(Container(
            height: 120+90.0,
            child: oneItem("${strings.get(163)}${item.id}", item.name, "${strings.get(164)}${item.updatedAt}", _getImage(item.imageid),
            windowWidth, item.visible))); // "Last update: ",
        list.add(SizedBox(height: 10,));
        list.add(Container(
            height: 50,
            child: buttonsEditOrDelete(item.id.toString(), _editCategory, _deleteDialog, windowWidth)
        ));
        list.add(SizedBox(height: 20,));
      }
    }
    dprint("_needShow $_needShow");
    if (_needShow != null && _ensureVisibleId != "")
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_needShow < 0) _needShow = 0;
        scrollController.jumpTo(_needShow+100);
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(_needShow, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        });
      });

    list.add(SizedBox(height: 200,));
    return list;
  }

  _viewExtrasList(){
    var list = List<Widget>();
    list.add(_titlePath("${strings.get(94)} > ${strings.get(199)}"));  // "Foods",  // "Extras",
    list.add(_searchBar());  // Search
    list.add(_extrasGroupComboBox());
    list.add(SizedBox(height: 20,));
    var _needShow = 0.0;
    if (_extras != null){
      var count = 0;
      for (var item in _extras){
        if (!item.name.toUpperCase().contains(_searchValue))
          continue;
        if (_extrasGroupValue != 0 && item.extrasGroup != _extrasGroupValue)
          continue;
        if (_ensureVisibleId == item.id.toString()) {
          if (count > 0)
            _needShow = 60.0+(290)*count-290;//-290;
          else
            _needShow = 0;
          dprint("${item.id} $count");
        }
        count++;
        list.add(Container(
            height: 120+90.0,
            child: oneItem("${strings.get(163)}${item.id}", item.name, "${strings.get(164)}${item.updatedAt}", _getImage(item.imageid),
                windowWidth, '1'))); // "Last update: ",
        list.add(SizedBox(height: 10,));
        list.add(Container(
            height: 50,
            child: buttonsEditOrDelete(item.id.toString(), _editExtras, _deleteDialog, windowWidth)
        ));
        list.add(SizedBox(height: 20,));
      }
    }
    dprint("_needShow $_needShow");
    if (_needShow != null && _ensureVisibleId != "")
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_needShow < 0) _needShow = 0;
        scrollController.jumpTo(_needShow+100);
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(_needShow, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        });
      });

    list.add(SizedBox(height: 200,));
    return list;
  }

  _editExtras(String id){
    for (var item in _extras)
      if (item.id.toString() == id) {
        editControllerName.text = item.name;
        editControllerPrice.text = item.price;
        editControllerDesc.text = item.desc;
        _imagePath = "";
        _serverImagePath = "";
        for (var image in _image)
          if (image.id == item.imageid) {
            _serverImagePath = "$serverImages${image.filename}";
            _imageId = image.id.toString();
          }
        for (var ex in _extrasGroup)
          if (ex.id == item.extrasGroup)
            _extrasGroupValueOnForm = item.extrasGroup;
        _state = "editExtras";
        _editItem = true;
        _editItemId = id;
        setState(() {});
      }
  }

  _viewExtrasGroupList(){
    var list = List<Widget>();
    list.add(_titlePath("${strings.get(94)} > ${strings.get(195)}"));  // "Foods",  // "Extras Groups",
    list.add(_searchBar());  // Search
    list.add(SizedBox(height: 20,));
    var _needShow = 0.0;
    if (_extrasGroup != null){
      var count = 0;
      for (var item in _extrasGroup){
        if (!item.name.toUpperCase().contains(_searchValue))
          continue;
        if (_ensureVisibleId == item.id.toString()) {
          if (count > 0)
            _needShow = 60.0+(290)*count-290;//-290;
          else
            _needShow = 0;
          dprint("${item.id} $count");
        }
        count++;
        list.add(Container(
            height: 120+90.0,
            child: oneItem("${strings.get(163)}${item.id}", item.name, "${strings.get(164)}${item.updatedAt}", serverImgNoImage,
                windowWidth, '1'))); // "Last update: ",
        list.add(SizedBox(height: 10,));
        list.add(Container(
            height: 50,
            child: buttonsEditOrDelete(item.id.toString(), _editExtrasGroup, _deleteDialog, windowWidth)
        ));
        list.add(SizedBox(height: 20,));
      }
    }
    dprint("_needShow $_needShow");
    if (_needShow != null && _ensureVisibleId != "")
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_needShow < 0) _needShow = 0;
        scrollController.jumpTo(_needShow+100);
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(_needShow, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        });
      });

    list.add(SizedBox(height: 200,));
    return list;
  }

  _editCategory(String id){
    for (var item in _cat)
      if (item.id.toString() == id) {
        editControllerName.text = item.name;
        editControllerDesc.text = item.desc;
        _categoryValue = item.parent;
        if (item.visible == '1') _published = true; else _published = false;
        _imagePath = "";
        _serverImagePath = "";
        for (var image in _image)
          if (image.id == item.imageid) {
            _serverImagePath = "$serverImages${image.filename}";
            _imageId = image.id.toString();
          }
        _state = "editCategory";
        _editItem = true;
        _editItemId = id;
        setState(() {});
      }
  }

  _editFood(String id){
    for (var item in _foods)
      if (item.id.toString() == id) {
        editControllerName.text = item.name;
        editControllerDesc.text = item.desc;
        editControllerPrice.text = item.price;
        for (var ex in _restaurants)
          if (ex.id == item.restaurant)
            _restaurantValueOnForm = item.restaurant;
        for (var ex in _cat)
          if (ex.id == item.category)
            _categoryValueOnForm = item.category;
        for (var ex in _extrasGroup)
            if (ex.id == item.extras)
              _extrasGroupValueOnForm = item.extras;
        for (var ex in _nutritionGroup)
          if (ex.id == item.nutrition)
            _nutritionGroupValueOnForm = item.nutrition;

        editControllerIngredients.text = item.ingredients;
        if (item.visible == '1') _published = true; else _published = false;
        _imagePath = "";
        _serverImagePath = "";
        for (var image in _image)
          if (image.id == item.imageid) {
            _serverImagePath = "$serverImages${image.filename}";
            _imageId = image.id.toString();
          }
        _state = "editFood";
        _editItem = true;
        _editItemId = id;
        setState(() {});
      }
  }

  _editExtrasGroup(String id){
    for (var item in _extrasGroup)
      if (item.id.toString() == id) {
        editControllerName.text = item.name;
        _restaurantValueOnForm = 0;
        for (var ex in _restaurants)
          if (ex.id == item.restaurant)
            _restaurantValueOnForm = item.restaurant;
        _state = "editExtrasGroup";
        _editItem = true;
        _editItemId = id;
        setState(() {});
      }
  }

  _deleteCategory(String id){
    categoryDelete(id,
      (List<ImageData> image, List<CategoriesData> cat) {
      _image = image; _cat = cat;
      _waits(false);
      setState(() {});
    }, _openDialogError);
  }

  _deleteFood(String id){
    foodDelete(id,
            (List<ImageData> image, List<FoodsData> foods, List<RestaurantData> restaurants,
                List<ExtrasGroupData> extrasGroup, List<NutritionGroupData> nutritionGroup) {
              _image = image;
              _foods = foods;
              _restaurants = restaurants;
              _extrasGroup = extrasGroup;
              _nutritionGroup = nutritionGroup;
              _waits(false);
        }, _openDialogError);
  }

  _deleteExtrasGroup(String id){
    extrasGroupDelete(id,
            (List<ExtrasGroupData> extrasGroup, ) {
          _extrasGroup = extrasGroup;
          _waits(false);
        }, _openDialogError);
  }

  _deleteExtras(String id){
    extrasDelete(id,
            (List<ImageData> image, List<ExtrasData> extras) {
          _extras = extras;
          _image = image;
          _waits(false);
          setState(() {
          });
        }, _openDialogError);
  }

  _addFood(){
    var list = List<Widget>();
    list.add(_titlePath((_editItem) ? "${strings.get(94)} > ${strings.get(94)} > ${strings.get(108)}" :
            "${strings.get(94)} > ${strings.get(94)} > ${strings.get(200)}"));  // "Foods",  // "Foods", Edit Add
    list.add(SizedBox(height: 20,));
    list.add(Text((_editItem) ? strings.get(202) : strings.get(181), style: theme.text16bold, textAlign: TextAlign.center,));  // "Add New Food",
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(113), editControllerName, "", 100)); // Name
    list.add(Row(children: [
        Text(strings.get(182), style: theme.text12bold,),  // "Enter Food name"
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
    list.add(formEditPrice(strings.get(183), editControllerPrice, "", _numberOfDigits)); // Price -
    list.add(Row(children: [
      Text(strings.get(184), style: theme.text12bold,),  //  "Enter Price",
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
    list.add(_categoryComboBoxInForm());
    list.add(Row(children: [
      Text(strings.get(185), style: theme.text12bold,),  //  "Select Category"
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));

    if (theme.multiple){
      list.add(_restaurantsComboBoxInForm());
      list.add(Row(children: [
        Text(strings.get(186), style: theme.text12bold,),  //  "Select Restaurant"
        SizedBox(width: 4,),
        Text("*", style: theme.text28Red)
      ],));
      list.add(SizedBox(height: 20,));
    }else
      _restaurantValueOnForm = 1;

    list.add(formEdit(strings.get(169), editControllerDesc, strings.get(170), 250)); // Description - "Enter description",
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(187), editControllerIngredients, strings.get(188), 250)); // Ingredients - "Enter Ingredients",
    list.add(SizedBox(height: 20,));
    if (theme.extras){
      list.add(_extrasComboBoxInForm());
      list.add(Text(strings.get(191), style: theme.text12bold,));           // "Select Extras"
      list.add(SizedBox(height: 20,));
      list.add(_nutritionComboBoxInForm());
      list.add(Text(strings.get(190), style: theme.text12bold,));           // "Select Nutritions"
      list.add(SizedBox(height: 20,));
    }
    list.add(selectImage(windowWidth, _makeImageDialog));                                        // select image
    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(173), style: theme.text14, textAlign: TextAlign.start,));  // "Current Image",
    list.add(SizedBox(height: 20,));
    list.add(Container(child: drawImage(_imagePath, _serverImagePath, windowWidth)));
    list.add(SizedBox(height: 20,));
    list.add(checkBox(strings.get(171), _published, (bool value){setState(() {_published = value;});}));                      // "Published item",
    list.add(SizedBox(height: 20,));
    list.add(IButton3(color: theme.colorPrimary,
        text: strings.get(65),              // Save
        textStyle: theme.text14boldWhite,
        pressButton: _addNewFood
    ));

    list.add(SizedBox(height: 150,));
    return list;
  }

  _addExtrasGroup(){
    var list = List<Widget>();
    list.add(_titlePath((_editItem) ? "${strings.get(94)} > ${strings.get(195)} > ${strings.get(108)}" :
          "${strings.get(94)} > ${strings.get(195)} > ${strings.get(200)}"));  // "Foods",  // Extras Groups", Edit Add
    list.add(SizedBox(height: 20,));
    if (_editItem)
      list.add(Text(strings.get(196), style: theme.text16bold, textAlign: TextAlign.center,));  // "Edit Extras Groups",
    else
      list.add(Text(strings.get(197), style: theme.text16bold, textAlign: TextAlign.center,));  // "Add New Extras Groups",
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(113), editControllerName, "", 100)); // Name
    list.add(Row(children: [
      Text(strings.get(198), style: theme.text12bold,),  // "Enter Extras Group Name"
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
    list.add(_restaurantsComboBoxInForm());
    list.add(Row(children: [
      Text(strings.get(186), style: theme.text12bold,),  //  "Select Restaurant"
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
    list.add(IButton3(color: theme.colorPrimary,
        text: strings.get(65),              // Save
        textStyle: theme.text14boldWhite,
        pressButton: _addNewExtrasGroup
    ));
    list.add(SizedBox(height: 150,));
    return list;
  }

  _addExtras(){
    var list = List<Widget>();
    list.add(_titlePath((_editItem) ? "${strings.get(94)} > ${strings.get(199)} > ${strings.get(108)}" :
          "${strings.get(94)} > ${strings.get(199)} > ${strings.get(200)}"));  // "Foods",  // Extras", Edit Add
    list.add(SizedBox(height: 20,));
    if (!_editItem)
      list.add(Text(strings.get(203), style: theme.text16bold, textAlign: TextAlign.center,));  // "Add Extras",
    else
      list.add(Text(strings.get(204), style: theme.text16bold, textAlign: TextAlign.center,));  // "Edit Extras"
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(113), editControllerName, "", 100)); // Name
    list.add(SizedBox(height: 20,));
    list.add(formEditPrice(strings.get(183), editControllerPrice, "", _numberOfDigits)); // Price -
    list.add(Row(children: [
      Text(strings.get(184), style: theme.text12bold,),  //  "Enter Price",
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
    list.add(_extrasGroupComboBoxInForm());
    list.add(Row(children: [
      Text(strings.get(205), style: theme.text12bold,),  //   "Select Extras Groups",
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(169), editControllerDesc, strings.get(170), 250)); // Description - "Enter description",
    list.add(SizedBox(height: 20,));
    list.add(selectImage(windowWidth, _makeImageDialog));               // select image
    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(173), style: theme.text14, textAlign: TextAlign.start,));  // "Current Image",
    list.add(SizedBox(height: 20,));
    list.add(Container(child: drawImage(_imagePath, _serverImagePath, windowWidth)));
    list.add(SizedBox(height: 20,));
    list.add(IButton3(color: theme.colorPrimary,
        text: strings.get(65),              // Save
        textStyle: theme.text14boldWhite,
        pressButton: _addNewExtras
    ));
    list.add(SizedBox(height: 150,));
    return list;
  }

  _addNewExtras(){
    if (editControllerName.text.isEmpty)
      return _openDialogError(strings.get(172));  // "The Name field is request",
    if (_extrasGroupValueOnForm == 0)
      return _openDialogError(strings.get(206));  // "The Extras Group field is request",
    if (editControllerPrice.text.isEmpty)
      return _openDialogError(strings.get(194));  // "The Price field is request",
    _waits(true);
    _extrasSave();
  }

  _extrasSave(){
    if (_imagePath.isNotEmpty)
      uploadImage(_imagePath, account.token, (String path, String id) {
        _extrasSave2(id);
      }, _openDialogError);
    else
      _extrasSave2(_imageId);
  }

  _extrasSave2(String image){
    extrasSave(editControllerName.text, _extrasGroupValueOnForm.toString(), editControllerPrice.text,
        editControllerDesc.text, image,
        (_editItem) ? "1" : "0", _editItemId,
        account.token, (List<ImageData> image, List<ExtrasData> extras, String id) {
          _extras = extras;
          _image = image;
          _state = "viewExtrasList";
          _ensureVisibleId = id;
          _waits(false);
          setState(() {});
        }, _openDialogError);
  }

  _nutritionComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _nutritionGroup) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _nutritionGroupValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _nutritionGroupValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  _extrasComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _extrasGroup) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _extrasGroupValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _extrasGroupValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  _extrasGroupComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _extrasGroup) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _extrasGroupValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _extrasGroupValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  _restaurantsComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _restaurants) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _restaurantValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _restaurantValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  _categoryComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _cat) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
      width: windowWidth,
      child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
              isExpanded: true,
              value: _categoryValueOnForm,
              items: menuItems,
              onChanged: (value) {
                _categoryValueOnForm = value;
                setState(() {
                });
              })
      )
    );
  }

  _addCategory(){
    var list = List<Widget>();
    list.add(_titlePath((_editItem) ? "${strings.get(94)} > ${strings.get(135)} > ${strings.get(108)}" :
              "${strings.get(94)} > ${strings.get(135)} > ${strings.get(200)}"));  // "Foods",  // "Category", Edit Add
    list.add(SizedBox(height: 20,));
    list.add(Text((_editItem) ? strings.get(201) : strings.get(168), style: theme.text16bold, textAlign: TextAlign.center,));  // "Add New Category",
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(113), editControllerName, strings.get(167), 100)); // Name - "Enter Category name",
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(169), editControllerDesc, strings.get(170), 100)); // Description - "Enter description",
    list.add(SizedBox(height: 20,));
    list.add(_categoryComboBox2(toInt(_editItemId)));
    list.add(Container(
      width: windowWidth,
      child: Text(strings.get(247), style: theme.text12bold, textAlign: TextAlign.start,),                // Choose Category
    ));
    list.add(SizedBox(height: 20,));
    list.add(selectImage(windowWidth, _makeImageDialog));               // select image
    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(173), style: theme.text14, textAlign: TextAlign.start,));  // "Current Image",
    list.add(SizedBox(height: 20,));
    list.add(Container(child: drawImage(_imagePath, _serverImagePath, windowWidth)));
    list.add(SizedBox(height: 20,));
    list.add(checkBox(strings.get(171), _published, (bool value){setState(() {_published = value;});}));                      // "Published item",
    list.add(SizedBox(height: 20,));
    list.add(IButton3(color: theme.colorPrimary,
        text: strings.get(65),              // Save
        textStyle: theme.text14boldWhite,
        pressButton: _addNewCategory
    ));

    list.add(SizedBox(height: 150,));
    return list;
  }

  _addNewExtrasGroup(){
    if (editControllerName.text.isEmpty)
      return _openDialogError(strings.get(172));  // "The Name field is request",
    if (_restaurantValueOnForm == 0)
      return _openDialogError(strings.get(192));  // "The Restaurant field is request",
    _waits(true);
    _extrasGroupSave();
  }

  _addNewFood(){
    if (editControllerName.text.isEmpty)
      return _openDialogError(strings.get(172));  // "The Name field is request",
    if (editControllerPrice.text.isEmpty)
      return _openDialogError(strings.get(194));  // "The Price field is request",
    if (_restaurantValueOnForm == 0)
      return _openDialogError(strings.get(192));  // "The Restaurant field is request",
    if (_categoryValueOnForm == 0)
      return _openDialogError(strings.get(193));  // "The Category field is request",
    _waits(true);

    if (_imagePath.isNotEmpty)
      uploadImage(_imagePath, account.token, (String path, String id) {
        _foodSave(id);
      }, _openDialogError);
    else
      _foodSave(_imageId);
  }

  _addNewCategory(){
    var name = editControllerName.text;
    if (name.isEmpty)
      return _openDialogError(strings.get(172));  // "The Name field is request",
    _waits(true);
    var desc = editControllerDesc.text;
    if (_imagePath.isNotEmpty)
      uploadImage(_imagePath, account.token, (String path, String id) {
        _catSave(name, desc, id);
      }, _openDialogError);
    else
      _catSave(name, desc, _imageId);
  }

  _catSave(String name, String desc, String imageid){
    categorySave(name, desc, imageid, (_published) ? "1" : "0",
        _categoryValue.toString(),
        (_editItem) ? "1" : "0", _editItemId,
        account.token, (List<ImageData> image, List<CategoriesData> cat, String id) {
          _image = image; _cat = cat;
          _state = "viewCategoryList";
          _ensureVisibleId = id;
          _waits(false);
          setState(() {});
        }, _openDialogError);
  }

  _extrasGroupSave(){
    extrasGroupSave(editControllerName.text, _restaurantValueOnForm.toString(),
        (_editItem) ? "1" : "0", _editItemId,
        account.token, (List<ExtrasGroupData> extrasGroup, String id) {
          _extrasGroup = extrasGroup;
          _state = "viewExtrasGroupList";
          _ensureVisibleId = id;
          _waits(false);
          setState(() {});
        }, _openDialogError);
  }

  _foodSave(String imageid){
      foodSave(editControllerName.text, editControllerDesc.text, imageid, (_published) ? "1" : "0",
          editControllerPrice.text, _restaurantValueOnForm.toString(), _categoryValueOnForm.toString(),
          editControllerIngredients.text, _extrasGroupValueOnForm.toString(), _nutritionGroupValueOnForm.toString(),
        (_editItem) ? "1" : "0", _editItemId,
        account.token, (List<ImageData> image, List<FoodsData> foods, List<RestaurantData> restaurants,
              List<ExtrasGroupData> extrasGroup, List<NutritionGroupData> nutritionGroup, String id) {
          _image = image;
          _foods = foods;
          _restaurants = restaurants;
          _extrasGroup = extrasGroup;
          _nutritionGroup = nutritionGroup;
          _state = "viewFoodsList";
          _ensureVisibleId = id;
          _waits(false);
          setState(() {});
        }, _openDialogError);
  }

  _makeImageDialog(){
    _dialogBody = Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(strings.get(126), textAlign: TextAlign.center, style: theme.text18boldPrimary,), // "Select image from",
            SizedBox(height: 50,),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: windowWidth/2-25,
                        child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(127), // "Camera",
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                          getImage2(ImageSource.camera);
                        }
                    )),
                    SizedBox(width: 10,),
                Container(
                  width: windowWidth/2-25,
                  child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(128), // Gallery
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
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
      setState(() {
      });
    }
  }

  _bodyRoot(){
    var list = List<Widget>();
    list.add(SizedBox(height: 20,));
    // categories
    list.add(oneItem(strings.get(160), "", "${strings.get(162)} ${(_cat != null) ? _cat.length : 0}",
        _getRandomImageFromCategories(), windowWidth, "")); // "Categories"  // "Total Count:"
    list.add(SizedBox(height: 5,));
    list.add(buttonsViewAllAndAddNew((){_changeState("viewCategoryList");}, (){_changeState("addCategory");}, windowWidth));
    list.add(SizedBox(height: 20,));
    // foods
    list.add(oneItem(strings.get(176), "", "${strings.get(162)} ${(_foods != null) ? _foods.length : 0}",
        _getRandomImageFromFoods(), windowWidth, "")); // "Foods"  // "Total Count:"
    list.add(SizedBox(height: 5,));
    list.add(buttonsViewAllAndAddNew((){_changeState("viewFoodsList");}, (){_changeState("addFood");}, windowWidth));
    list.add(SizedBox(height: 20,));
    if (theme.extras){
      // Extras Group
      list.add(oneItem(strings.get(195), "", "${strings.get(162)} ${(_extrasGroup != null) ? _extrasGroup.length : 0}",
          _getRandomImageFromExtrasGroup(), windowWidth, "")); // "Extras Groups"  // "Total Count:"
      list.add(SizedBox(height: 5,));
      list.add(buttonsViewAllAndAddNew((){_changeState("viewExtrasGroupList");}, (){_changeState("addExtrasGroup");}, windowWidth));
      list.add(SizedBox(height: 20,));
      // Extras
      list.add(oneItem(strings.get(199), "", "${strings.get(162)} ${(_extras != null) ? _extras.length : 0}",
          _getRandomImageFromExtras(), windowWidth, "")); // "Extras"  // "Total Count:"
      list.add(SizedBox(height: 5,));
      list.add(buttonsViewAllAndAddNew((){_changeState("viewExtrasList");}, (){_changeState("addExtras");}, windowWidth));
      list.add(SizedBox(height: 20,));
    }

    // Foods on Home Screen

    list.add(SizedBox(height: 150,));
    return list;
  }

  final _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  _getRandomImageFromFoods(){
     if (_foods != null && _foods.isNotEmpty){ // mainn
       var id = 0;
       if (_foods.length != 1)
        id = next(0, _foods.length-1);
       var imageId = _foods[id].imageid;
       for (int i = 0; i < 30; i++) {
         for (var item in _image)
           if (item.id == imageId)
             return "$serverImages${item.filename}";
       }
       return serverImgNoImage;
    }  else
      return serverImgNoImage;
  }

  _getRandomImageFromCategories(){
    if (_cat != null && _cat.isNotEmpty){
      var id = 0;
      if (_cat.length != 1)
        id = next(0, _cat.length-1);
      var imageId = _cat[id].imageid;
      for (int i = 0; i < 30; i++) {
        for (var item in _image)
          if (item.id == imageId)
            return "$serverImages${item.filename}";
      }
      return serverImgNoImage;
    }  else
      return serverImgNoImage;
  }

  _getRandomImageFromExtrasGroup(){
      return serverImgNoImage;
  }

  _getRandomImageFromExtras(){
    if (_extras != null && _extras.isNotEmpty){
      var id = 0;
      if (_extras.length != 1)
        id = next(0, _extras.length-1);
      var imageId = _extras[id].imageid;
      for (int i = 0; i < 30; i++) {
        for (var item in _image)
          if (item.id == imageId)
            return "$serverImages${item.filename}";
      }
      return serverImgNoImage;
    }  else
      return serverImgNoImage;
  }

  _deleteDialog(String id){
    if (demoMode == "true")
      return _openDialogError(strings.get(248)); // "This is demo application. Your can not modify this section.",

    _dialogBody =  Container(
      width: windowWidth,
        child: Column(
          children: [
            Text(strings.get(111), textAlign: TextAlign.center, style: theme.text18boldPrimary,), // "Are you sure?",
            SizedBox(height: 20,),
            Text(strings.get(112), textAlign: TextAlign.center, style: theme.text16,), // "You will not be able to recover this item!"
            SizedBox(height: 50,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
          width: windowWidth/2-25,
            child: IButton3(
                  color: Colors.red,
                  text: strings.get(109),                     // Yes, delete it!
                  textStyle: theme.text14boldWhite,
                  pressButton: (){
                    setState(() {
                      _show = 0;
                    });
                    _ensureVisibleId = "";
                    if (_state == "viewFoodsList")
                      _deleteFood(id);
                    if (_state == "viewCategoryList")
                      _deleteCategory(id);
                    if (_state == "viewExtrasGroupList")
                      _deleteExtrasGroup(id);
                    if (_state == "viewExtrasList")
                      _deleteExtras(id);
                  }
              )),
              SizedBox(width: 10,),
            Container(
              width: windowWidth/2-25,
              child: IButton3(
                  color: theme.colorPrimary,
                  text: strings.get(110),                 // No, cancel plx!
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
        )
    );
    setState(() {
      _show = 1;
    });
  }

  bool _searchPublished = true;
  bool _searchHidden = true;
  var _categoryValue = 0;
  var _restaurantValue = 0;
  var _extrasGroupValue = 0;

  _categoryComboBox2(int id){
    var found = false;
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _cat) {
      if (item.id != id) {
        menuItems.add(DropdownMenuItem(
          child: Text(item.name, style: theme.text14,),
          value: item.id,
        ),);
      }
      if (item.id == _categoryValue)
        found = true;
    }
    if (!found)
      _categoryValue = 0;
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _categoryValue,
                items: menuItems,
                onChanged: (value) {
                  _categoryValue = value;
                  setState(() {
                  });
                })
        ));
  }

  _categoryComboBox(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(180), style: theme.text14,), // All
      value: 0,
    ),);
    for (var item in _cat) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _categoryValue,
                items: menuItems,
                onChanged: (value) {
                  _categoryValue = value;
                  setState(() {
                  });
                })
        ));
  }

  _restaurantsComboBox(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(180), style: theme.text14,), // All
      value: 0,
    ),);
    for (var item in _restaurants) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _restaurantValue,
                items: menuItems,
                onChanged: (value) {
                  _restaurantValue = value;
                  //_dialogBody = _getBodySearchDialog();
                  setState(() {
                  });
                })
        ));
  }

  _extrasGroupComboBox(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(180), style: theme.text14,), // All
      value: 0,
    ),);
    for (var item in _extrasGroup) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _extrasGroupValue,
                items: menuItems,
                onChanged: (value) {
                  _extrasGroupValue = value;
                  setState(() {
                  });
                })
        ));
  }


}

