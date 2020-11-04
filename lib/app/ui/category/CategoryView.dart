

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'CategoryMobile.dart';
import 'Categorytablet.dart';


class CategoryView extends StatelessWidget {
  CategoryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CategoryMobile(),
      tablet: Categorytablet(),
    );
  }
}