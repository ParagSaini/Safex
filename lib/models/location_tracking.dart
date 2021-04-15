import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safex/main.dart';

class LocationTracking {
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<Position> _positionStream;

  void _showError(String error) {
    Fluttertoast.showToast(
        msg: error,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG);
  }

  Future<void> subscribeToUserLocation() async {
    String userUid = loggedInUser.getLoggedInUser().uid;
    GeoPoint pos;
    double accuracy;
    try {
      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 10)
          .listen((Position position) async {
        print(position);
        pos = GeoPoint(position.latitude, position.longitude);
        accuracy = position.accuracy;
        await _firestore.collection('locations').doc(userUid).update({
          'location': pos,
          'accuracy': accuracy,
        });
        print('subscription successful');
      });
    } on FirebaseException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError(e.toString());
    }
    _positionStream.onError((error) {
      _showError(error.toString());
    });
  }

  Future<bool> cancelSubscription() async {
    if (_positionStream != null) {
      try {
        await _positionStream.cancel();
        print('Unsubscribed succesfully');
        return true;
      } catch (e) {
        _showError(e.toString());
      }
      return false;
    }
    return true;
  }
}
