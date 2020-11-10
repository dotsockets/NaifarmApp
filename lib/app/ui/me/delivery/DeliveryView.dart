

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';
import 'DeliveryMobile.dart';
import 'Deliverytablet.dart';


class DeliveryView extends StatelessWidget {
  DeliveryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: DeliverMobile(),
      tablet: Deliverytablet(),
    );
  }
}