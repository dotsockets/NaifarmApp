

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'ProductDetailMobile.dart';
import 'ProductDetailtablet.dart';




class ProductDetailView extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productStatus;
  final String productPrice;

  ProductDetailView({Key key, this.productImage, this.productName, this.productStatus, this.productPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ProductDetailMobile(productImage: productImage,productName: productName,productPrice: productPrice,productStatus: productStatus),
      tablet: ProductDetailtablet(),
    );
  }
}