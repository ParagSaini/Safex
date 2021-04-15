import 'package:flutter/material.dart';
import 'package:safex/constant.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField({
    this.leadingIcon,
    this.keyboardType,
    this.hintText,
    this.validator,
    this.onSaved,
    this.obscureText,
  });
  final keyboardType, hintText;
  final obscureText;
  final leadingIcon;
  final Function validator, onSaved;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              leadingIcon,
              size: 30.0,
              color: Color(0xFFDBC9B4),
            ),
            SizedBox(
              width: 25.0,
            ),
            Flexible(
              child: TextFormField(
                keyboardType: keyboardType ?? TextInputType.text,
                textAlign: TextAlign.start,
                obscureText: obscureText ?? false,
                style: kTextFontStyle.copyWith(fontSize: 18.0),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: hintText,
                  errorStyle: TextStyle(
                    fontFamily: 'Karla',
                    fontSize: 15.0,
                  ),
                  errorMaxLines: 2,
                ),
                validator: validator,
                onSaved: onSaved,
              ),
            ),
          ],
        ),
        Divider(
          height: 25.0,
          thickness: 1.5,
          color: Color(0xFFDBC9B4),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
