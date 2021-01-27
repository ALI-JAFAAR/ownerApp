import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import 'ibutton3.dart';
import 'iinputField2.dart';

buttonsViewAllAndAddNew(Function callback1, Function callback2, double windowWidth){
  return Container(
    alignment: Alignment.center,
    child: Row(
      children: [
        Container(
            width: windowWidth/2-20,
            child: IButton3(
                color: theme.colorPrimary,
                text: strings.get(161),                       // VIEW ALL
                textStyle: theme.text14boldWhite,
                pressButton: callback1,
            )
        ),
        SizedBox(width: 10,),
        Container(
            width: windowWidth/2-20,
            child: IButton3(
                onlyBorder: true,
                color: theme.colorPrimary,
                text: strings.get(106),                       // ADD NEW
                textStyle: theme.text14bold,
                pressButton: callback2
            )
        ),
      ],
    ),
  );
}

buttonsEditOrDelete(String id, Function callback1, Function callback2, double windowWidth){
  return Container(
    alignment: Alignment.center,
    child: Row(
      children: [
        Container(
            width: windowWidth/2-20,
            child: IButton3(
              color: theme.colorPrimary,
              text: strings.get(165),                       // EDIT
              textStyle: theme.text14boldWhite,
              pressButton: (){
                callback1(id);
              },
            )
        ),
        SizedBox(width: 10,),
        Container(
            width: windowWidth/2-20,
            child: IButton3(
                color: theme.colorRed,
                text: strings.get(166),                       // DELETE
                textStyle: theme.text14boldWhite,
                pressButton: (){
                  callback2(id);
                },
            )
        ),
      ],
    ),
  );
}

buttonEdit(Function callback1, double windowWidth){
  return Container(
    alignment: Alignment.centerRight,
      child: UnconstrainedBox(
    child: Container(
      width: windowWidth/2-20,
      child: IButton3(
        color: theme.colorPrimary,
        text: strings.get(165),                       // EDIT
        textStyle: theme.text14boldWhite,
        pressButton: (){
          callback1();
        },
      )
    ),
  ));
}

buttonBack(Function callback){
  return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
  alignment: Alignment.bottomLeft,
  child: Stack(
    children: <Widget>[
      buttonBack2(),
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.black.withAlpha(80),
              onTap: (){
                callback();
              }, // needed
            )),
      )
    ],
  ));
}

buttonBackUp(Function callback, double top){
  return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: top),
      alignment: Alignment.topLeft,
      child: Stack(
        children: <Widget>[
          buttonBack2(),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.black.withAlpha(80),
                  onTap: (){
                    callback();
                  }, // needed
                )),
          )
        ],
      ));
}

buttonBack2(){
  return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          color: theme.colorBackground,
          border: Border.all(color: Colors.black.withAlpha(100)),
          borderRadius: new BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(theme.shadow+10),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ]
      ),
      child: Container(
        margin: (strings.direction == TextDirection.ltr) ? EdgeInsets.only(left: 10) : EdgeInsets.only(right: 10),
        child: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black,),),
  );
}

imageWidget(String image){
  return CachedNetworkImage(
      placeholder: (context, url) =>
          UnconstrainedBox(child:
          Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: CircularProgressIndicator(backgroundColor: theme.colorPrimary, ),
          )),
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context,url,error) => new Icon(Icons.error),
  );
}

oneItem(String id, String name, String lastUpdate, String image, double windowWidth, String published){
  return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: theme.colorBackground,
          border: Border.all(color: Colors.black.withAlpha(100)),
          borderRadius: new BorderRadius.circular(theme.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(theme.shadow),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(id, style: theme.text16bold,),  // "ID: ",
              Expanded(child: Text(lastUpdate, textAlign: TextAlign.end, style: theme.text14), ),
            ],
          ),
          SizedBox(height: 5,),
          if (published != '')
            Row(children: [
              Expanded(child: Text(name, style: theme.text16bold, textAlign: TextAlign.start, maxLines: 1,)),  // name
              if (published == '1')
                Container(
                  padding: EdgeInsets.all(5),
                  color: theme.colorPrimary,
                  child: Text(strings.get(174), style: theme.text14boldWhite,), // "PUBLISHED",
                ),
              if (published == '0')
                Container(
                  padding: EdgeInsets.all(5),
                  color: theme.colorRed,
                  child: Text(strings.get(175), style: theme.text14boldWhite,), // "HIDE",
                ),
            ],),
          SizedBox(height: 5,),
          Container(
            width: windowWidth,
            height: 120,
            child: imageWidget(image),
          )

        ],
      )
  );
}

// text
formEdit(String hint, TextEditingController controller, String text, int maxLenght){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          height: 40,
          child: IInputField2(
            maxLenght: maxLenght,
            hint: hint,
            type: TextInputType.text,
            colorDefaultText: theme.colorDefaultText,
            colorBackground: theme.colorBackground,
            controller: controller,
          )),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
      if (text.isNotEmpty)
        Text(text, style: theme.text12bold,),
    ],
  );
}

// phone number
formEditPhone(String hint, TextEditingController controller, String text, int maxLenght){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          height: 40,
          child: IInputField2(
            maxLenght: maxLenght,
            hint: hint,
            type: TextInputType.phone,
            colorDefaultText: theme.colorDefaultText,
            colorBackground: theme.colorBackground,
            controller: controller,
          )),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
      if (text.isNotEmpty)
        Text(text, style: theme.text12bold,),
    ],
  );
}

formEditNumbers(String hint, TextEditingController controller, String text, int maxLenght, Function(String) _onChangeText){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 40,
        child: TextFormField(
            keyboardType: TextInputType.number,
            cursorColor: theme.colorDefaultText,
            controller: controller,
            onChanged: (String value) async {
              _onChangeText(value);
            },
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
//            maxLength: widget.maxLenght,
            style: TextStyle(
              color: theme.colorDefaultText,
            ),
            decoration: new InputDecoration(
              counterText: "",
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: theme.colorDefaultText,
                  fontSize: 16.0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ]
        ),
      ),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
      if (text.isNotEmpty)
        Text(text, style: theme.text12bold,),                // Enter Dishes Name
    ],
  );
}


// numbers 0-100
formEditNumbers0100(String hint, TextEditingController controller, String text, int maxLenght, Function(String) _onChangeText){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 40,
        child: TextFormField(
            keyboardType: TextInputType.number,
            cursorColor: theme.colorDefaultText,
            controller: controller,
            onChanged: (String value) async {
              _onChangeText(value);
            },
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
//            maxLength: widget.maxLenght,
            style: TextStyle(
              color: theme.colorDefaultText,
            ),
            decoration: new InputDecoration(
              counterText: "",
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: theme.colorDefaultText,
                  fontSize: 16.0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CustomRangeTextInputFormatter(),
            ]
        ),
      ),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
      if (text.isNotEmpty)
        Text(text, style: theme.text12bold,),                // Enter Dishes Name
    ],
  );
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue,) {
    if(newValue.text == '')
      return TextEditingValue();
    else if(int.parse(newValue.text) < 0)
      return TextEditingValue(selection: TextSelection.collapsed(offset: 2)).copyWith(text: '0');
    return int.parse(newValue.text) > 100 ? TextEditingValue(selection: TextSelection.collapsed(offset: 3)).copyWith(text: '100') : newValue;
  }
}

// price
formEditPrice(String hint, TextEditingController controller, String text, int numberOfDigits){
  var regx = r'(^\d*[,.]?\d{0,2})';
  if (numberOfDigits == 0)
    regx = r'(^\d*)';
  if (numberOfDigits == 1)
    regx = r'(^\d*[,.]?\d{0,1})';
  if (numberOfDigits == 3)
    regx = r'(^\d*[,.]?\d{0,3})';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          height: 40,
          child: TextFormField(
            keyboardType: TextInputType.number,
            cursorColor: theme.colorDefaultText,
            controller: controller,
            onChanged: (String value) async {
            },
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
//            maxLength: widget.maxLenght,
            style: TextStyle(
              color: theme.colorDefaultText,
            ),
            decoration: new InputDecoration(
              counterText: "",
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: theme.colorDefaultText,
                  fontSize: 16.0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(regx)),
            ]
          ),
        ),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
      if (text.isNotEmpty)
        Text(text, style: theme.text12bold,),                // Enter Dishes Name
    ],
  );
}

// lat and lng
formEditLatitude(String hint, TextEditingController controller, String text){
  var regx = r'(^\d*[,.]?\d{0,12})';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 40,
        child: TextFormField(
            keyboardType: TextInputType.number,
            cursorColor: theme.colorDefaultText,
            controller: controller,
            onChanged: (String value) async {
            },
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
//            maxLength: widget.maxLenght,
            style: TextStyle(
              color: theme.colorDefaultText,
            ),
            decoration: new InputDecoration(
              counterText: "",
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: theme.colorDefaultText,
                  fontSize: 16.0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(regx)),
            ]
        ),
      ),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
      if (text.isNotEmpty)
        Text(text, style: theme.text12bold,),                // Enter Dishes Name
    ],
  );
}

formSearch(Function(String) callback){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //Container(height: 0.5, color: Colors.black.withAlpha(100),),
      Container(
          height: 40,
          child: IInputField2(
            maxLenght: 30,
            hint: strings.get(177),                                                   // Search
            type: TextInputType.text,
            colorDefaultText: theme.colorDefaultText,
            colorBackground: theme.colorBackground,
            onChangeText: callback,
          )),
      Container(height: 0.5, color: Colors.black.withAlpha(100),),
      SizedBox(height: 3,),
    ],
  );
}

selectImage(double windowWidth, Function callback){
  return Stack(
    children: [
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        height: 100,
        width: windowWidth,
        decoration: BoxDecoration(
          color: theme.colorGrey,
          borderRadius: new BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 10),
          child: Opacity(
              opacity: 0.6,
              child: Text(strings.get(125), style: theme.text12bold, ) // Click here for select Image
          ),
        ),                // "Enter description",
      ),
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10),
        child: UnconstrainedBox(
            child: Container(
                height: 60,
                width: 40,
                child: Image.asset("assets/selectimage.png",
                    fit: BoxFit.contain
                )
            )),
      ),

      Positioned.fill(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  callback();
                }, // needed
              )),
        ),
      )

    ],
  );
}

checkBox(String text, bool init, Function(bool) callback){
  return Row(
    children: <Widget>[
      Checkbox(
          value: init,
          activeColor: theme.colorPrimary,
          onChanged: callback
      ),
      Text(text, style: theme.text14)
    ],
  );
}

Widget drawImage(String image, String serverImage, double windowWidth){
  if (image.isNotEmpty)
    return Container(
        height: windowWidth*0.3,
        child: Image.file(File(image), fit: BoxFit.contain,
        ));
  else {
    if (serverImage.isNotEmpty)
      return Container(
        width: windowWidth,
        height: 100,
        child: Container(
          width: windowWidth,
          child: CachedNetworkImage(
            placeholder: (context, url) =>
                UnconstrainedBox(child:
                Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    backgroundColor: theme.colorPrimary,
                  ),
                )),
            imageUrl: serverImage,
            imageBuilder: (context, imageProvider) =>
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        ),
      );
  }
  return Container();
}

