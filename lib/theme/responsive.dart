import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.width * ratio;
  }

  static double height(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.height * ratio;
  }

  static double font(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.width * ratio;
  }
}
