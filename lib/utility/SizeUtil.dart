import 'package:flutter_device_type/flutter_device_type.dart';

class SizeUtil {
  static double categoryBox() {
    return Device.get().isPhone ? 75 : 100;
  }

  static double priceFontSize() {
    return Device.get().isPhone ? 17 : 70;
  }

  static double titleFontSize() {
    return Device.get().isPhone ? 15 : 50;
  }

  static double titleSmallFontSize() {
    return Device.get().isPhone ? 14 : 40;
  }

  static double detailFontSize() {
    return Device.get().isPhone ? 12 : 30;
  }

  static double detailSmallFontSize() {
    return Device.get().isPhone ? 11 : 20;
  }
}
