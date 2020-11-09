
import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/ScreenTypeLayout.dart';

import 'NotiMobile.dart';
import 'Notitablet.dart';

class NotiView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: NotiMobile(),
      tablet: Notitablet(),
    );
  }
}