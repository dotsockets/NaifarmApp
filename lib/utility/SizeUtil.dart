import 'package:flutter_device_type/flutter_device_type.dart';

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
    return Device.get().isPhone ? 11 : 7;
  }

  static double titleSmallFontSize() {
    return Device.get().isPhone ? 10 : 6;
  }

  static double detailFontSize() {
    return Device.get().isPhone ? 9 : 5;
  }

  static double detailSmallFontSize() {
    return Device.get().isPhone ? 9 : 5;
  }
}
