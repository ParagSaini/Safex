import 'package:flutter/material.dart';
import 'package:safex/constant.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.label, this.colour, @required this.onPressed});
  final String label;
  final Color colour;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(5.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 100.0,
          height: 65.0,
          child: Text(
            label,
            style: kTextFontStyle.copyWith(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
