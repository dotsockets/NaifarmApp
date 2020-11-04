

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'RecommendMobile.dart';
import 'Recommendtablet.dart';



class RecommendView extends StatelessWidget {
  RecommendView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: RecommendMobile(),
      tablet: Recommendtablet(),
    );
  }
}