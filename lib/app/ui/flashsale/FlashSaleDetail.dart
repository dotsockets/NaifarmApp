import 'dart:io';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/FlashSaleBar.dart';
import 'package:naifarm/utility/widgets/LifecycleWatcherState.dart';
import 'package:naifarm/utility/widgets/ProductItemCard.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class FlashSaleView extends StatefulWidget {
  final FlashsaleRespone flashsaleRespone;
  const FlashSaleView({Key key, this.flashsaleRespone}) : super(key: key);

  @override
  _FlashSaleViewState createState() => _FlashSaleViewState();
}

class _FlashSaleViewState extends LifecycleWatcherState<FlashSaleView> {
  ProductBloc bloc;
  int page = 1;
  int limit = 10;
  ScrollController _scrollController = ScrollController();
  bool stepPage = false;
  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;
  final positionScroll = BehaviorSubject<bool>();

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.flashsale.add(widget.flashsaleRespone);
      bloc.loadFlashsaleData(context, page: page.toString(), limit: limit);
    }
    _scrollControl();
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.0.h),
              child: AppToobar(
                  headerType: Header_Type.barcartShop,
                  icon: 'assets/images/png/cart_top.png',
                  title: "Flash Sale")),

          backgroundColor: Colors.grey.shade300,
          // appBar: AppToobar(title: "Flash Sale",header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
          body: Platform.isAndroid
              ? androidRefreshIndicator()
              : Container(
                  color: Colors.grey.shade200,
                  child: SafeArea(
                    child: iosRefreshIndicator(),
                  )),
        ),
      ),
    );
  }

  Widget androidRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: content,
    );
  }

  Widget iosRefreshIndicator() {
    return CustomRefreshIndicator(
        controller: _indicatorController,
        onRefresh: () => _refreshProducts(),
        armedToLoadingDuration: const Duration(seconds: 1),
        draggingToIdleDuration: const Duration(seconds: 1),
        completeStateDuration: const Duration(seconds: 1),
        offsetToArmed: 50.0,
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget _) {
                  if (controller.state == IndicatorState.complete) {
                    // AudioCache().play("sound/Click.mp3");
                    //
                    // Vibration.vibrate(duration: 500);
                  }
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 2.0.h),
                      width: 5.0.w,
                      height: 5.0.w,
                      child: controller.state == IndicatorState.loading ||
                              controller.state == IndicatorState.dragging ||
                              controller.state == IndicatorState.armed ||
                              controller.state == IndicatorState.complete
                          ? CupertinoActivityIndicator()
                          : SizedBox(),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0.0, controller.value * _indicatorSize),
                    child: child,
                  );
                },
                animation: controller,
              ),
            ],
          );
        },
        child: content);
  }

  Widget get content => SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 1.0.h),
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
              stream: bloc.flashsale.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                stepPage = true;
                if (snapshot.hasData && snapshot.data != null) {
                  var item = (snapshot.data as FlashsaleRespone);
                  stepPage = true;
                  if (item.data.isNotEmpty) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 6.0.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                      SizeUtil.paddingBorderHome().w),
                                  topLeft: Radius.circular(
                                      SizeUtil.paddingBorderHome().w),
                                  bottomLeft: Radius.circular(
                                      item.data.length != 0 ? 0 : 40),
                                  bottomRight: Radius.circular(
                                      item.data.length != 0 ? 0 : 40)),
                              border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                  style: BorderStyle.solid)),
                          child: Container(
                            margin: EdgeInsets.only(top: 5.0.h),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemBuilder: (context, i) {
                                // if ( i+1==((item.data.length) / 2).round()) {
                                //   return CupertinoActivityIndicator();
                                // }

                                return Container(
                                  child: Column(
                                    children: [
                                      item.data[0].items.length - (i) * 2 > 1
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  child: ProductItemCard(
                                                    item: item.data[0]
                                                        .items[(i * 2)].product,
                                                    showSoldFlash: true,
                                                    tagHero: "flash",
                                                  ),
                                                  onTap: () {
                                                    AppRoute.productDetail(
                                                        context,
                                                        productImage:
                                                            "flash_${item.data[0].items[(i * 2)].product.id}1",
                                                        productItem: ProductBloc
                                                            .convertDataToProduct(
                                                                data: item
                                                                    .data[0]
                                                                    .items[
                                                                        (i * 2)]
                                                                    .product));
                                                  },
                                                ),
                                                /*_buildProduct(
                                              item: item.data[0].items[(i * 2)+1].product,
                                              index: (i * 2),
                                              context: context)),*/
                                                InkWell(
                                                  child: ProductItemCard(
                                                    item: item
                                                        .data[0]
                                                        .items[(i * 2) + 1]
                                                        .product,
                                                    showSoldFlash: true,
                                                    tagHero: "flash",
                                                  ),
                                                  onTap: () {
                                                    AppRoute.productDetail(
                                                        context,
                                                        productImage:
                                                            "flash_${item.data[0].items[(i * 2) + 1].product.id}1",
                                                        productItem: ProductBloc
                                                            .convertDataToProduct(
                                                                data: item
                                                                    .data[0]
                                                                    .items[(i *
                                                                            2) +
                                                                        1]
                                                                    .product));
                                                  },
                                                )

                                                /*_buildProduct(
                                              item: item.data[0].items[(i * 2) + 1].product,
                                              index: ((i * 2) + 1),
                                              context: context))*/
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: ProductItemCard(
                                                    item: item.data[0]
                                                        .items[(i * 2)].product,
                                                    showSoldFlash: true,
                                                    tagHero: "flash",
                                                  ),
                                                ),

                                                /*_buildProduct(
                                              item: item.data[0].items[(i * 2)].product,
                                              index: (i * 2),
                                              context: context)),*/
                                                Expanded(child: SizedBox()),
                                              ],
                                            ),
                                      if (item.loadmore)
                                        i + 1 ==
                                                ((item.data[0].items.length) /
                                                        2)
                                                    .round()
                                            ? Container(
                                                padding: EdgeInsets.all(20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Platform.isAndroid
                                                        ? SizedBox(
                                                            width: 5.0.w,
                                                            height: 5.0.w,
                                                            child:
                                                                CircularProgressIndicator())
                                                        : CupertinoActivityIndicator(),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        LocaleKeys
                                                            .dialog_message_loading
                                                            .tr(),
                                                        style: FunctionHelper
                                                            .fontTheme(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: SizeUtil
                                                                        .titleFontSize()
                                                                    .sp))
                                                  ],
                                                ),
                                              )
                                            : SizedBox()
                                    ],
                                  ),
                                );
                              },
                              itemCount:
                                  ((item.data[0].items.length) / 2).round(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FlashSaleBar(),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.only(top: 12.0.h),
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Lottie.asset('assets/json/boxorder.json',
                              height: 70.0.w, width: 70.0.w, repeat: false),
                          Text(
                            LocaleKeys.search_product_not_found.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 15.0.h, bottom: 15.0.h),
                      child: Platform.isAndroid
                          ? SizedBox(
                              width: 5.0.w,
                              height: 5.0.w,
                              child: CircularProgressIndicator())
                          : CupertinoActivityIndicator(),
                    ),
                  );
                }
              },
            )),
      );

  Widget flashintoProduct({ProductData item, int index}) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Container(
            height: SizeUtil.titleSmallFontSize().sp * 2.7,
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: FunctionHelper.fontTheme(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeUtil.titleSmallFontSize().sp),
            ),
          ),
          SizedBox(
            height: 0.8.h,
          ),
          Text(
            "฿${item.salePrice}",
            style: FunctionHelper.fontTheme(
                color: ThemeColor.colorSale(),
                fontWeight: FontWeight.bold,
                fontSize: SizeUtil.priceFontSize().sp),
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 7, bottom: 3, top: 3),
                    color: ThemeColor.colorSale(),
                    child: Text(
                      "${item.saleCount != null ? item.saleCount.toString() : '0'} ${LocaleKeys.my_product_sold_end.tr()}",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.detailSmallFontSize().sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/png/flash.png',
                height: 8.0.w,
              )
            ],
          )
        ],
      ),
    );
  }

/*
  Widget _buildProduct({ProductData item, int index, BuildContext context}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: (MediaQuery.of(context).size.width / 2) - 15,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Hero(
                  tag: "flash_${index}",
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(1.0.h),
                      child: CachedNetworkImage(
                        width: 30.0.w,
                        height: 40.0.w,
                        placeholder: (context, url) => Container(
                          width: 30.0.w,
                          height: 40.0.w,
                          color: Colors.white,
                          child:
                          Lottie.asset('assets/json/loading.json',   width: 30.0.w,
                            height: 40.0.w,),
                        ),
                        imageUrl: ProductLandscape.CovertUrlImage(item.image),
                        errorWidget: (context, url, error) => Container(
                            width: 30.0.w,
                            height: 40.0.w,
                            child: Icon(
                              Icons.error,
                              size: 30,
                            )),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.all(1.5.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1.0.w),
                          child: Container(
                            padding: EdgeInsets.only(right: 1.5.w,left: 1.5.w,top: 1.0.w,bottom: 1.0.w),
                            color: ThemeColor.colorSale(),
                            child: Text("${item.discountPercent}%",style: FunctionHelper.fontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
                          ),
                        ),
                      ),
                      visible: item.discountPercent>0?true:false,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _FlashintoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: (){

        AppRoute.ProductDetail(context,
            productImage: "flash_${item.id}1",
            productItem: ProductBloc.ConvertDataToProduct(data: item));
      },
    );
  }

*/

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    _refreshProducts();
  }

  Future<Null> _refreshProducts() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
      // AudioCache().play("sound/Click.mp3");
      // Vibration.vibrate(duration: 500);
    }
    page = 1;
    stepPage = true;
    bloc.productMore.clear();
    bloc.loadFlashsaleData(context, page: page.toString(), limit: limit);
  }
  _scrollControl(){
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
          _scrollController.position.pixels <=
          200) {
        // if (step_page) {
        //   step_page = false;
        //   page++;
        //   bloc.loadFlashsaleData(
        //       page: page.toString(), limit: limit);
        // }
      }

      if (_scrollController.position.pixels > 500) {
        positionScroll.add(true);
      } else {
        positionScroll.add(false);
      }
    });
  }
}
