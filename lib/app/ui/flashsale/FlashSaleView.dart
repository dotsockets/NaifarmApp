
import 'package:flutter/material.dart';

import '../ScreenTypeLayout.dart';
import 'FlashSaleMobile.dart';
import 'FlashSaletablet.dart';

class FlashSaleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: FlashSaleMobile(),
      tablet: FlashSaletablet(),
    );
  }
}
