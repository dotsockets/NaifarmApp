
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MyLikeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
              child: StickyHeader(
                header:  AppToobar(Title: "สิ่งที่ถูกใจ",header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',onClick: (){

                },),
                content: ProductGrid(
                  producViewModel: ProductViewModel().getMarketRecommend(),
                  IconInto: 'assets/images/svg/like.svg',
                  onSelectMore: () {

                  },
                  onTapItem: (int index) {
                    AppRoute.ProductDetail(context,
                        productImage: "mylike_${index}");
                  },EnableHeader: false,tagHero: "mylike",isLike: true,),
              ),
            ),
        ),
      ),
    );
  }
}
