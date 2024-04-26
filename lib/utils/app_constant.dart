import 'package:flutter/material.dart';

class Layout {
  static late double _width;
  static late double _height;

  Layout(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  static getScreenHeight() {
    return _height;
  }

  static getScreenWidth() {
    return _width;
  }

  static height(double pixels) {
    double y = _height / pixels;
    return getScreenHeight() / y;
  }

  static width(double pixels) {
    double x = _width / pixels;
    return getScreenWidth() / x;
  }
}
