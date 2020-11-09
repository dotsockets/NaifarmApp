import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'widget/ProductDetail.dart';
import 'widget/ProductInto.dart';
import 'widget/ProductSlide.dart';
import 'widget/Reviewscore.dart';
import 'widget/ShopOwn.dart';

class ProductDetailMobile extends StatefulWidget {
  final String productImage;

  const ProductDetailMobile({Key key, this.productImage}) : super(key: key);

  @override
  _ProductDetailMobileState createState() => _ProductDetailMobileState();
}

class _ProductDetailMobileState extends State<ProductDetailMobile> {
  ProductModel _productDetail = ProductViewModel().getFlashSaleProduct()[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppToobar(header_type: Header_Type.barNoSearchNoTitle),
                      Hero(tag: widget.productImage, child: ProductSlide()),
                      ProductInto(productDetail: _productDetail),
                      _Divider(),
                      ShopOwn(productDetail: _productDetail),
                      _Divider(),
                      ProductDetail(productDetail: _productDetail),
                      _Divider(),
                      ProductLandscape(
                        titleInto: "คุณอาจจะชอบสิ่งนี้",
                        producViewModel: ProductViewModel().getBaseSaller(),
                        IconInto: 'assets/images/svg/like.svg',
                        onSelectMore: () {

                        },
                        onTapItem: (int index) {

                        },
                      ),
                      _Divider(),
                      Reviewscore()
                    ],
                  ),
                ),

              ),
              _BuildFooterTotal()
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildFooterTotal() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0),bottom: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0))
      ),
        child: Row(
          children: [
            Expanded(child: SvgPicture.asset(
              'assets/images/svg/share.svg',
              width: 40,
              height: 40,
            )),
            Container(
              color: Colors.grey.withOpacity(0.4),
              height: 60,
              width: 1,
            ),
            Expanded(child: SvgPicture.asset(
              'assets/images/svg/like_line_null.svg',
              width: 40,
              height: 40,
              color: Colors.black.withOpacity(0.7),
            )),
            Expanded(
                flex: 2,
                child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    color: ThemeColor.ColorSale(),
                    child: Text("ซื้อสินค้า",
                        style: GoogleFonts.sarabun(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))))
          ],
        ),
    );
  }



  Widget _Divider() {
    return Container(
      color: Colors.black.withOpacity(0.2),
      height: 10,
    );
  }
}
