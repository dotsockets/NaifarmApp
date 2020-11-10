import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/recommend/widget/CategoryTab.dart';
import 'package:naifarm/app/ui/recommend/widget/FlashSale.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BannerSlide.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'widget/RecommendMenu.dart';
import 'widget/SearchHot.dart';

class RecommendView extends StatefulWidget {
  final Size size;
  final double paddingBottom;

  const RecommendView({Key key, this.size, this.paddingBottom})
      : super(key: key);

  @override
  _RecommendViewState createState() => _RecommendViewState();
}

class _RecommendViewState extends State<RecommendView> {
  final List<MenuModel> _menuViewModel = MenuViewModel().getMenustype();
  final _indicatorController = IndicatorController();
  final _scrollController = TrackingScrollController();
  int _categoryselectedIndex = 0;
  Offset _position;

  double _dxMax;
  double _dyMax;

  @override
  void initState() {
    _dxMax = widget.size.width - 100;
    _dyMax = widget.size.height - (160 + widget.paddingBottom);
    super.initState();
    // AppRoute.home(context);
  }

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
      child: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade300,
          child: StickyHeader(
            header: Column(
              children: [
                AppToobar(
                  header_type: Header_Type.barHome,
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
                RecommendMenu(),
                FlashSale(),
                SizedBox(height: 15),
                ProductLandscape(
                    titleInto: "สินค้าขายดี",
                    producViewModel: ProductViewModel().getBaseSaller(),
                    IconInto: 'assets/images/svg/product_hot.svg',
                    onSelectMore: () {},
                    onTapItem: (int index) {
                      AppRoute.ProductDetail(context,
                          productImage: "product_hot_${index}");
                    },
                    tagHero: "product_hot"),
                SizedBox(height: 15),
                _BannerAds(),
                ProductVertical(
                    titleInto: "ฟาร์มมาร์เก็ต",
                    producViewModel: ProductViewModel().getProductFarm(),
                    IconInto: 'assets/images/svg/menu_market.svg',
                    onSelectMore: () {},
                    onTapItem: (int index) {
                      AppRoute.ProductDetail(context,
                          productImage: "market_${index}");
                    },
                    borderRadius: false,
                    tagHero: "market"),
                SizedBox(height: 15),
                CategoryTab(),
                SizedBox(height: 15),
                SearchHot(onSelectChang: (){},onTapItem: (int index){ AppRoute.ProductDetail(context,
                    productImage: "search_${index}");},tagHero: "search"),
                SizedBox(height: 15),
                ProductVertical(
                    titleInto: "สินค้าสำหรับคุณ",
                    producViewModel: ProductViewModel().getProductForYou(),
                    IconInto: 'assets/images/svg/foryou.svg',
                    onSelectMore: () {},
                    onTapItem: (int index) {
                      AppRoute.ProductDetail(context,
                          productImage: "foryou_${index}");
                    },
                    borderRadius: false,
                    tagHero: "foryou")
              ],
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
