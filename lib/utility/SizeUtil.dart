import 'package:flutter_device_type/flutter_device_type.dart';

class SizeUtil {
  static double categoryBox() {
    return Device.get().isPhone ? 9 : 40;
  }
  static double appNameFontSize() {
    return Device.get().isPhone ? 20 : 80;
  }
  static double priceFontSize() {
    return Device.get().isPhone ? 13 : 70;
  }

  static double titleFontSize() {
    return Device.get().isPhone ? 11 : 50;
  }

  static double titleSmallFontSize() {
    return Device.get().isPhone ? 10 : 40;
  }

  static double detailFontSize() {
    return Device.get().isPhone ? 9 : 30;
  }

  static double detailSmallFontSize() {
    return Device.get().isPhone ? 9 : 20;
  }
}
