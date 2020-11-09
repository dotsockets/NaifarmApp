
import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/ScreenTypeLayout.dart';

import 'MyLikeMobile.dart';
import 'MyLiketablet.dart';

class MyLikeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MyLikeMobile(),
      tablet: MyLiketablet(),
    );
  }

}
