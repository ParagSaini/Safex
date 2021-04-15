import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safex/alerts_box/alert_dialogs.dart';
import 'package:safex/constant.dart';

class AskForPermission {
  GeoPoint _pos;
  double _accuracy;

  GeoPoint get getGeoPoint {
    return _pos;
  }

  double get getAccuracy {
    return _accuracy;
  }

  void showError(String error) {
    Fluttertoast.showToast(
        msg: error,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG);
  }

  Future<bool> check(BuildContext context) async {
    try {
      if (await requestLocationPermission(context: context) &&
          await _gpsService(context)) return true;
    } catch (e) {
      showError(e.toString());
    }
    return false;
  }

/*Checking if your App has been Given Permission*/
  Future<bool> requestLocationPermission({BuildContext context}) async {
    LocationPermission status = await Geolocator.requestPermission();
    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        await AlertBoxes().singleButtonDialog(
            context: context,
            title: 'Permission not granted',
            content: Text(
              'Please make sure you enable location permission and try again.',
              style: kTextFontStyle,
            ),
            buttonText: 'Ok',
            onButtonPressed: () {
              Navigator.pop(context);
            });
      }
      return false;
    }
    return true;
  }

/*Show dialog if GPS not enabled and open settings location*/
  Future<bool> _checkGps(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      AlertBoxes().singleButtonDialog(
          context: context,
          title: "Can't get gurrent location",
          content: Text(
            'Please make sure you enable GPS and try again.',
            style: kTextFontStyle,
          ),
          buttonText: 'Ok',
          onButtonPressed: () {
            final AndroidIntent intent = AndroidIntent(
                action: 'android.settings.LOCATION_SOURCE_SETTINGS');
            intent.launch();
            Navigator.pop(context);
          });
    }
    return false;
  }

/*Check if gps service is enabled or not*/
  Future<bool> _gpsService(BuildContext context) async {
    bool serviceStatus = await Geolocator.isLocationServiceEnabled();
    print(serviceStatus);
    if (serviceStatus) {
      Position position =
          // Geolocator.getCurrentPosition(), will work only on high accuracy.
          await Geolocator.getCurrentPosition().catchError((error) async {
        print(error);
        await _checkGps(context);
      });
      if (position != null) {
        _pos = GeoPoint(position.latitude, position.longitude);
        _accuracy = position.accuracy;
        return true;
      }
      return false;
    }
    return (await _checkGps(context));
  }
}
