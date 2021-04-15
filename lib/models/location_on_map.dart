import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safex/main.dart';

class LocationOnMap extends ChangeNotifier {
  String _userName = '';
  String _selectedUserUid;
  double _lat = 0.0, _lon = 0.0;
  double _accuracy;
  Marker _marker;
  MapType _mapType = MapType.normal;
  Circle _circle;
  StreamSubscription _locationStream;
  final _firestore = FirebaseFirestore.instance;
  GoogleMapController _controller;
  CameraPosition _initialPos =
      CameraPosition(target: LatLng(25.2, 77.4), zoom: 4.0);

  GoogleMap getGoogleMap() {
    return GoogleMap(
      initialCameraPosition: _initialPos,
      mapType: _mapType,
      zoomControlsEnabled: false,
      markers: Set.of((_marker != null) ? [_marker] : []),
      circles: Set.of((_circle != null) ? [_circle] : []),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

  Future<void> updateMarkerAndCircle(
      {String uid, @required String userName}) async {
    // subscribing to the particular user location stream.
    await cancelStream();

    _selectedUserUid = uid;
    _userName = userName;
    try {
      _locationStream = _firestore
          .collection('locations')
          .doc(uid)
          .snapshots()
          .listen((location) {
        GeoPoint pos = location.data()['location'];
        _lat = pos.latitude;
        _lon = pos.longitude;
        _accuracy = location.data()['accuracy'];

        _marker = Marker(
            markerId: MarkerId('Current Location'),
            position: LatLng(pos.latitude, pos.longitude),
            icon: BitmapDescriptor.defaultMarker);

        _circle = Circle(
          circleId: CircleId('current loc circle'),
          radius: _accuracy,
          center: LatLng(pos.latitude, pos.longitude),
          strokeColor: Colors.blue,
          strokeWidth: 5,
          fillColor: Colors.blue.withAlpha(90),
        );

        if (_controller != null) {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(pos.latitude, pos.longitude), zoom: 17.0),
            ),
          );
        }
        notifyListeners();
      });
    } catch (e) {
      showNegativeError(e.toString());
    }
    _locationStream.onError((error) {
      showNegativeError(error.toString());
    });
  }

  void toggleMapType() {
    if (_mapType == MapType.normal) {
      _mapType = MapType.hybrid;
    } else {
      _mapType = MapType.normal;
    }
    notifyListeners();
  }

  void showNegativeError(String error) {
    Fluttertoast.showToast(
        msg: error,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG);
  }

  String getSelectedUserName() {
    if (_selectedUserUid == loggedInUser.getLoggedInUser().uid)
      return 'You';
    else
      return _userName;
  }

  String getCurrentUserLat() {
    return _lat.toString();
  }

  String getCurrentUserLon() {
    return _lon.toString();
  }

  bool markerNotNull() {
    return (_marker != null ? true : false);
  }

  void setMarkerToNull() {
    _marker = null;
    print('the marker set to null');
  }

  Future<void> cancelStream() async {
    if (_locationStream != null) {
      try {
        await _locationStream.cancel();
      } catch (e) {
        showNegativeError(e.toString());
      }
    }
  }
}
