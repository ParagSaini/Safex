import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safex/constant.dart';

class AlertBoxes {
  Future<void> textFieldDialog(
      {BuildContext context, Function onPressed, String title}) async {
    String enteredText = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.white,
              width: 3.0,
            ),
          ),
          title: Text(
            title,
            style: kTextFontStyle.copyWith(fontSize: 20.0),
          ),
          content: TextField(
            autofocus: true,
            style: kTextFontStyle.copyWith(fontSize: 20.0),
            onChanged: (newVal) {
              enteredText = newVal;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Approve',
                style: kTextFontStyle.copyWith(
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                onPressed(enteredText.trim());
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> showBinaryDialog({BuildContext context, String title}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            title: Text(
              title,
              style: kTextFontStyle.copyWith(fontSize: 20.0),
            ),
            actions: <Widget>[
              Row(
                children: [
                  TextButton(
                    child: Text(
                      'Yes',
                      style: kTextFontStyle.copyWith(fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
                    child: Text(
                      'No',
                      style: kTextFontStyle.copyWith(fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> singleButtonDialog(
      {BuildContext context,
      String title,
      Widget content,
      String buttonText,
      Function onButtonPressed}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            title: Text(
              title,
              style: kTextFontStyle.copyWith(fontSize: 20.0),
            ),
            content: content,
            actions: <Widget>[
              TextButton(
                child: Text(
                  buttonText,
                  style: kTextFontStyle.copyWith(fontSize: 20.0),
                ),
                onPressed: () {
                  onButtonPressed();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
