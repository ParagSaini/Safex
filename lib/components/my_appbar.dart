import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safex/constant.dart';

class MyAppBar extends StatelessWidget {
  MyAppBar({@required this.title, this.trailingIcon, this.iconPressed});
  final title;
  final trailingIcon;
  final Function iconPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 58,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/appbarImage.PNG'),
          fit: BoxFit.fill,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0.5,
          ),
        ],
        shape: BoxShape.rectangle,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              title,
              style: kTextFontStyle.copyWith(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          trailingIcon == null
              ? Container()
              : RawMaterialButton(
                  constraints: BoxConstraints(),
                  onPressed: iconPressed,
                  child: trailingIcon,
                ),
        ],
      ),
    );
  }
}
