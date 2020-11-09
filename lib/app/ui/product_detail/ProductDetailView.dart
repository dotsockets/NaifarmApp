

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'ProductDetailMobile.dart';
import 'ProductDetailtablet.dart';




class ProductDetailView extends StatelessWidget {
  final String productImage;

  ProductDetailView({Key key, this.productImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ProductDetailMobile(productImage: productImage),
      tablet: ProductDetailtablet(),
    );
  }
}