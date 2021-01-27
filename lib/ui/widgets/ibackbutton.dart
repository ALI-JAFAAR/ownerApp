import 'package:flutter/material.dart';

class IBackButton extends StatelessWidget {
  @required final Function() onBackClick;
  final Color color;
  final Color iconColor;
  IBackButton({this.onBackClick, this.color = Colors.grey, this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
        child: Container(
            margin: EdgeInsets.only(left: 10, top: 10+MediaQuery.of(context).padding.top),
            child: Stack(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: _backButton2()
                ),
                Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.grey[400],
                        onTap: (){
                          onBackClick();
                        }, // needed
                      )),
                )
              ],
            )));
  }

  _backButton2(){
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back_ios, color: iconColor,),
      ),
    );
  }
}