import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BannerSlide.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:sticky_headers/sticky_headers.dart';

class CategoryVegetableView extends StatefulWidget {
  final int index;
  CategoryVegetableView({Key key, this.index}) : super(key: key);
  @override
  _CategoryVegetableViewState createState() => _CategoryVegetableViewState();
}

class _CategoryVegetableViewState extends State<CategoryVegetableView> {
  final _scrollController = TrackingScrollController();
  final List<MenuModel> _menuViewModel = MenuViewModel().getMenusVegetable();
  final List<MenuModel> menuTypeViewModel = MenuViewModel().getMenustype();
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
                header: Column(
                  children: [
                    AppToobar(
                      Title: menuTypeViewModel[widget.index+1].label,
                      header_type: Header_Type.barcartShop,
                      isEnable_Search: true,
                    ),
                    CategoryMenu(
                      selectedIndex: _categoryselectedIndex,
                      menuViewModel: _menuViewModel,
                      onTap: (int val) {
                        setState(() {
                          _categoryselectedIndex = val;
                        });
                      },
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    BannerSlide(),
                    SizedBox(height: 15),
                    ProductGrid(
                        titleInto: "แนะนำ",
                        showBorder: true,
                        producViewModel:
                            ProductViewModel().getMarketRecommend(),
                        IconInto: 'assets/images/svg/like.svg',
                        onSelectMore: () {},
                        onTapItem: (int index) {
                          AppRoute.ProductDetail(context,
                              productImage: "market_farm_${index}");
                        },
                        tagHero: 'market_farm'),
                    SizedBox(height: 5),
                    _BannerAds(),
                    SizedBox(height: 5),
                    ProductVertical(
                      titleInto: "ขายดี",
                      producViewModel: ProductViewModel().getProductFarm(),
                      IconInto: 'assets/images/svg/product_hot.svg',
                      onSelectMore: () {},
                      onTapItem: (int index) {
                        AppRoute.ProductDetail(context,
                            productImage: "sell_${index}");
                      },
                      borderRadius: false,
                      IconSize: 30,
                      tagHero: "sell",
                    ),
                    SizedBox(height: 15),
                    ProductLandscape(
                        titleInto: "ผักบุ้ง",
                        producViewModel: ProductViewModel().getVegetable1(),
                        IconInto: 'assets/images/svg/product_hot.svg',
                        showIcon: false,
                        showPriceSale: false,
                        onSelectMore: () {},
                        onTapItem: (int index) {
                          AppRoute.ProductDetail(context,
                              productImage: "product_section1_${index}");
                        },
                        tagHero: "product_section1"),
                    SizedBox(height: 15),
                      ProductLandscape(
                        titleInto: "พริก",
                        showIcon: false,
                        showPriceSale: false,
                        producViewModel: ProductViewModel().getVegetableChilli(),
                        IconInto: 'assets/images/svg/product_hot.svg',
                        onSelectMore: () {},
                        onTapItem: (int index) {
                          AppRoute.ProductDetail(context,
                              productImage: "product_section2_${index}");
                        },
                        tagHero: "product_section2"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _BannerAds() {
    return Container(
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          color: Colors.white,
          child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
        ),
        fit: BoxFit.cover,
        imageUrl:
            'https://www.img.in.th/images/aa1d76fa9b9c502debba8123aeb20088.jpg',
        errorWidget: (context, url, error) => Container(
            height: 30,
            child: Icon(
              Icons.error,
              size: 30,
            )),
      ),
    );
  }
}
