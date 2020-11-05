

import 'package:flutter/material.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

import 'widget/ProductSlide.dart';

class ProductDetailMobile extends StatefulWidget {

  final String productImage;

  const ProductDetailMobile({Key key, this.productImage}) : super(key: key);
  @override
  _ProductDetailMobileState createState() => _ProductDetailMobileState();
}

class _ProductDetailMobileState extends State<ProductDetailMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppToobar(header_type: Header_Type.barNoSearchNoTitle),
              Hero(tag: widget.productImage,child: ProductSlide())
            ],
          ),
        ),
      ),
    );
  }
}
