import 'package:flutter/cupertino.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:sizer/sizer.dart';

class SizeUtil {
  static double categoryBox() {
    return Device.get().isPhone ? 9 : 5;
  }

  static double appNameFontSize() {
    return Device.get().isPhone ? 20 : 16;
  }

  static double priceFontSize() {
    return Device.get().isPhone ? 13 : 9;
  }

  static double titleFontSize() {
    return Device.get().isPhone ? 10.5 : 7;
  }

  static double titleSmallFontSize() {
    return Device.get().isPhone ? 9.5 : 6;
  }

  static double detailFontSize() {
    return Device.get().isPhone ? 9 : 5;
  }

  static double detailSmallFontSize() {
    return Device.get().isPhone ? 9 : 5;
  }

  static double shopIconSize() {
    return Device.get().isPhone ? 6.0 : 5.0;
  }

  static double shopBadgeSize() {
    return Device.get().isPhone ? 6.0 : 5.0;
  }

  static double shopBadgePadding() {
    return Device.get().isPhone ? 0.6 : 0.3;
  }

  static double shopBadgeTop() {
    return Device.get().isPhone ? -0.5 : -0.5;
  }

  static double shopBadgeEnd() {
    return Device.get().isPhone ? 5 : 0;
  }

  static double custombarIconSize() {
    return Device.get().isPhone ? 6.0 : 4.0;
  }

  static EdgeInsets custombarIndicationPadding() {
    return EdgeInsets.fromLTRB(
        5.0.w, 0, 5.0.w, Device.get().isPhone ? 1.0.h : 0);
  }

  static double meBodyHeight(double h) {
    return Device.get().isPhone ? h : h + 100.0;
  }

  static EdgeInsets detailProfilePadding() {
    return EdgeInsets.only(top: Device.get().isPhone ? 0 : 20.0);
  }
}
