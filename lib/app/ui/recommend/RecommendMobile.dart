import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/recommend/widget/CategoryTab.dart';
import 'package:naifarm/app/ui/recommend/widget/FarmMarket.dart';
import 'package:naifarm/app/ui/recommend/widget/FlashSale.dart';
import 'package:naifarm/app/ui/recommend/widget/ProductForMe.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'widget/Best_Selling_Products.dart';
import '../../../utility/widgets/BannerSlide.dart';
import 'widget/RecommendMenu.dart';
import 'widget/SearchHot.dart';

class RecommendMobile extends StatefulWidget {

  final Size size;
  final double paddingBottom;

  const RecommendMobile({Key key, this.size, this.paddingBottom}) : super(key: key);
  @override
  _RecommendMobileState createState() => _RecommendMobileState();
}

class _RecommendMobileState extends State<RecommendMobile> {

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
                    top:  60 * controller.value,
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
            header:  Column(
              children: [
                AppToobar(),
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
                RecommendMenu(),
                FlashSale(),
                SizedBox(height: 15),
                Best_Selling_Products(),
                SizedBox(height: 15),
                _BannerAds(),
                FarmMarket(),
                SizedBox(height: 15),
                CategoryTab(),
                SizedBox(height: 15),
                SearchHot(),
                SizedBox(height: 15),
                ProductForMe()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _BannerAds(){
    return Container(
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          color: Colors.white,
          child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
        ),
        fit: BoxFit.cover,
        imageUrl: 'https://www.img.in.th/images/aa1d76fa9b9c502debba8123aeb20088.jpg',
        errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
      ),
    );
  }
}
