
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';

import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../utility/widgets/BannerSlide.dart';

class MarketView extends StatefulWidget {

  @override
  _MarketViewState createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {

  final _scrollController = TrackingScrollController();
  final List<MenuModel> _menuViewModel = MenuViewModel().getMenustype();
  final _indicatorController = IndicatorController();
  int _categoryselectedIndex = 0;
  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      controller: _indicatorController,
      onRefresh: () => Future.delayed(const Duration(seconds: 2)),
      loadingToIdleDuration: const Duration(seconds: 1),
      armedToLoadingDuration: const Duration(seconds: 1),
      draggingToIdleDuration: const Duration(seconds: 1),
      leadingGlowVisible: false,
      trailingGlowVisible: false,
      offsetToArmed: 100.0,
      builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
          ) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                if (!controller.isIdle)
                  Positioned(
                    top: 60 * controller.value,
                    child: SpinKitThreeBounce(
                      color: ThemeColor.primaryColor(),
                      size: 30,
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0, 130.0 * controller.value),
                  child: child,
                ),
              ],
            );
          },
        );
      },

      child: SafeArea(
        top: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: Colors.grey.shade300,
              child: StickyHeader(
                header:  Column(
                  children: [
                    AppToobar(Title: "สินค้า Naifarm ฟาร์มมาร์เก็ต",header_type:  Header_Type.barcartShop,isEnable_Search: true,),
                    CategoryMenu(selectedIndex: _categoryselectedIndex,menuViewModel: _menuViewModel,onTap: (int val){
                      setState(() {
                        _categoryselectedIndex = val;
                      });
                    },),
                  ],
                ),
                content: Column(
                  children: [
                    BannerSlide(),
                    SizedBox(height: 15),
                    ProductVertical(titleInto: "ขายดี",
                        producViewModel: ProductViewModel().getProductFarm(),
                        IconInto: 'assets/images/svg/product_hot.svg',
                        onSelectMore: () {},
                        onTapItem: (int index) {
                          AppRoute.ProductDetail(context,
                              productImage: "sell_${index}");
                        },borderRadius: true,IconSize: 30,tagHero: "sell",),
                    SizedBox(height: 15),
                    ProductGrid(titleInto: "แนะนำ",
                      producViewModel: ProductViewModel().getMarketRecommend(),
                      IconInto: 'assets/images/svg/like.svg',
                      onSelectMore: () {
                      },
                      onTapItem: (int index) {
                        AppRoute.ProductDetail(context,
                            productImage: "market_farm_${index}");
                      },tagHero: 'market_farm' ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
