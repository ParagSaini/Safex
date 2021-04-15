import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation {
  static const String id = 'loading_screen';
  static Widget progressIndicator = SpinKitRipple(
    color: Color(0xFFDBC9B4),
    size: 80,
    borderWidth: 25,
  );
}
