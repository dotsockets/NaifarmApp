


import 'package:flutter_device_type/flutter_device_type.dart';

class SizeUtil{
  static double categoryBox(){
    return Device.get().isPhone?75:100;
  }

}