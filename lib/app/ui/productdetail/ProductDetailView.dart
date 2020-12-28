import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widget/BuildChoosesize.dart';
import 'widget/ProductDetail.dart';
import 'widget/ProductInto.dart';
import 'widget/ProductSlide.dart';
import 'widget/Reviewscore.dart';
import '../../../utility/widgets/ShopOwn.dart';

class ProductDetailView extends StatefulWidget {
  final String productImage;

  const ProductDetailView({Key key, this.productImage}) : super(key: key);

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  ProductModel _productDetail = ProductViewModel().getFlashSaleProduct()[0];
   int IndexTypes1=1;
   int IndexTypes2=1;

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
                      AppToobar(header_type: Header_Type.barNoBackground),
                      Hero(tag: widget.productImage, child: ProductSlide()),
                      ProductInto(productDetail: _productDetail),
                      _Divider(),
                      BuildChoosesize(IndexType1: IndexTypes1,IndexType2: IndexTypes2,onclick1: (int index)=>setState(() =>IndexTypes1 = index),onclick2: (int index)=>setState(() =>IndexTypes2 = index)),
                      _Divider(),
                      InkWell(
                        child: ShopOwn(productDetail: _productDetail),
                        onTap: (){
                          AppRoute.ShopMain(context);
                          },
                      ),
                      _Divider(),
                      ProductDetail(productDetail: _productDetail),
                      _Divider(),
                      ProductLandscape(
                        titleInto: LocaleKeys.recommend_you_like.tr(),
                        producViewModel: ProductViewModel().getBestSaller(),
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
              width: 35,
              height: 35,
            )),
            Container(
              color: Colors.grey.withOpacity(0.4),
              height: 60,
              width: 1,
            ),
            Expanded(child: SvgPicture.asset(
              'assets/images/svg/like_line_null.svg',
              width: 35,
              height: 35,
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
                    child: Text(LocaleKeys.buy_product_btn.tr(),
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize(),
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
