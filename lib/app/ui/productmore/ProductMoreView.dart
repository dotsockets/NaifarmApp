import 'dart:io';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:rxdart/subjects.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

class ProductMoreView extends StatefulWidget {
  final String barTxt;

  final List<ProductModel> productList;
  final ProductRespone installData;
  final String apiLink;
  final int typeMore;

  ProductMoreView(
      {Key key,
      this.barTxt,
      this.productList,
      this.installData,
      this.apiLink,
      this.typeMore})
      : super(key: key);

  @override
  _ProductMoreViewState createState() => _ProductMoreViewState();
}

class _ProductMoreViewState extends State<ProductMoreView> {
  ProductBloc bloc;
  int page = 1;
  int limit = 10;
  ScrollController _scrollController = ScrollController();
  bool stepPage = false;
  final _indicatorController = IndicatorController();
  final positionScroll = BehaviorSubject<bool>();

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));

      if (widget.installData != null) {
        bloc.moreProduct.add(widget.installData);
      }
      NaiFarmLocalStorage.getProductMoreCache().then((value) {
        if (value != null) {
          for (var data in value.productRespone) {
            if (data.slag == widget.apiLink) {
              bloc.moreProduct.add(data.searchRespone);
              break;
            }
          }
        }
        bloc.loadMoreData(context,
            page: page.toString(),
            limit: 10,
            link: widget.apiLink,
            typeMore: widget.typeMore);
      });
      bloc.onError.stream.listen((event) {
        if (event.status == 0 || event.status >= 500) {
          Future.delayed(const Duration(milliseconds: 300), () {
            FunctionHelper.alertDialogRetry(context,
                cancalMessage: LocaleKeys.btn_exit.tr(),
                callCancle: () {
                  AppRoute.poppageCount(context: context, countpage:2);
                },
                title: LocaleKeys.btn_error.tr(),
                message: event.message,
                callBack: () {
                  bloc.loadMoreData(context,
                      page: page.toString(),
                      limit: 10,
                      link: widget.apiLink,
                      typeMore: widget.typeMore);
                });
          });
        }
      });
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
          page++;
          bloc.loadMoreData(context,
              page: page.toString(),
              limit: limit,
              link: widget.apiLink,
              typeMore: widget.typeMore);
        }
      }

      if (_scrollController.position.pixels > 500) {
        positionScroll.add(true);
      } else {
        positionScroll.add(false);
      }
    });
  }

  Widget androidRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: mainContent(),
    );
  }

  Widget iosRefreshIndicator() {
    return CustomRefreshIndicator(
        controller: _indicatorController,
        onRefresh: () => onRefresh(),
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
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        top: 25 * controller.value,
                        child: CupertinoActivityIndicator(),
                      )
                    ],
                  );
                },
              ),
              AnimatedBuilder(
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(
                        0.0, controller.value * SizeUtil.indicatorSize()),
                    child: child,
                  );
                },
                animation: controller,
              ),
            ],
          );
        },
        child: mainContent());
  }

  Future<Null> onRefresh() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
    }

    bloc.productMore.clear();

    page = 1;

    bloc.loadMoreData(context,
        page: page.toString(),
        limit: 10,
        link: widget.apiLink,
        typeMore: widget.typeMore);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
          page++;
          bloc.loadMoreData(context,
              page: page.toString(),
              limit: limit,
              link: widget.apiLink,
              typeMore: widget.typeMore);
        }
      }

      if (_scrollController.position.pixels > 500) {
        positionScroll.add(true);
      } else {
        positionScroll.add(false);
      }
    });
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
                title: widget.barTxt,
                headerType: Header_Type.barcartShop,
                icon: 'assets/images/png/search.png',
              ),
            ),
            backgroundColor: Colors.white,
            body: Platform.isAndroid
                ? androidRefreshIndicator()
                : iosRefreshIndicator()),
      ),
    );
  }

  Widget mainContent() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: StreamBuilder(
              stream: bloc.moreProduct.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                stepPage = true;
                if (snapshot.hasData) {
                  var item = (snapshot.data as ProductRespone);
                  if (item.data.length > 0) {
                    stepPage = true;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      // physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        // if ( i+1==((item.data.length) / 2).round()) {
                        //   return CupertinoActivityIndicator();
                        // }

                        return Container(
                          child: Column(
                            children: [
                              item.data.length - (i) * 2 > 1
                                  ? Row(
                                      children: [
                                        Expanded(
                                            child: _buildProduct(
                                                item: item.data[(i * 2)],
                                                index: (i * 2),
                                                context: context)),
                                        Expanded(
                                            child: _buildProduct(
                                                item: item.data[(i * 2) + 1],
                                                index: ((i * 2) + 1),
                                                context: context))
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: _buildProduct(
                                                item: item.data[(i * 2)],
                                                index: (i * 2),
                                                context: context)),
                                        Expanded(child: SizedBox()),
                                      ],
                                    ),
                              if (item.data.length != item.total &&
                                  item.data.length >= limit)
                                i + 1 == ((item.data.length) / 2).round()
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
                                                style: FunctionHelper.fontTheme(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        SizeUtil.titleFontSize()
                                                            .sp))
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                            ],
                          ),
                        );
                      },
                      itemCount: ((item.data.length) / 2).round(),
                    );
                  } else {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 15.0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                    );
                  }
                } else {
                  return Container(
                    margin: EdgeInsets.only(top: 40.0.h),
                    child: Center(
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          StreamBuilder(
              stream: positionScroll.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data
                      ? Container(
                          margin: EdgeInsets.only(right: 5.0.w, bottom: 5.0.w),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: SizeUtil.tabMenuSize().w,
                                height: SizeUtil.tabMenuSize().w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.4)),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_up_outlined,
                                    size: SizeUtil.largeIconSize().w,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.minScrollExtent,
                                        duration: Duration(milliseconds: 1000),
                                        curve: Curves.ease);
                                  },
                                ),
                              )),
                        )
                      : SizedBox();
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }

  Widget _intoProduct({ProductData item, int index}) {
    return Column(
      children: [
        SizedBox(height: 0.5.h),
        Container(
          height: SizeUtil.productNameHeight(SizeUtil.titleSmallFontSize().sp),
          child: Text(item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: FunctionHelper.fontTheme(
                  color: Colors.black,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            item.offerPrice != null
                ? Text(
                    "฿${item.salePrice.priceFormat()}",
                    style: FunctionHelper.fontTheme(
                        color: Colors.grey,
                        fontSize: SizeUtil.priceFontSize().sp - 2,
                        decoration: TextDecoration.lineThrough))
                : SizedBox(),
            SizedBox(width: item.offerPrice != null ? 1.0.w : 0),
            Text(
              item.offerPrice != null
                  ? "฿${item.offerPrice.priceFormat()}"
                  : "฿${item.salePrice!=null?item.salePrice.priceFormat():0}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.fontTheme(
                  color: ThemeColor.colorSale(),
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.priceFontSize().sp),
            ),
          ],
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 6),
              child: SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {},
                  starCount: 5,
                  rating: item.rating != null && item.rating != 0
                      ? item.rating.toDouble()
                      : 0.0,
                  size: SizeUtil.ratingSize().w,
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.orange,
                  borderColor: Colors.grey.shade300,
                  spacing: 0.0),
            ),
            Text(
                "${LocaleKeys.my_product_sold.tr()} ${item.saleCount != null ? item.saleCount.toString() : '0'} ${LocaleKeys.cart_piece.tr()}",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.detailSmallFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500))
          ],
        )
      ],
    );
  }

  Widget _buildProduct({ProductData item, int index, BuildContext context}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child:
                      /*Hero(
                    tag: "loadmore_${item.id}$index",
                    child:*/
                      ClipRRect(
                    borderRadius: BorderRadius.circular(1.0.h),
                    child: CachedNetworkImage(
                      width: 30.0.w,
                      height: 40.0.w,
                      placeholder: (context, url) => Container(
                        width: 30.0.w,
                        height: 40.0.w,
                        color: Colors.white,
                        child: Lottie.asset(
                          'assets/json/loading.json',
                          width: 30.0.w,
                          height: 40.0.w,
                        ),
                      ),
                      imageUrl:  item.image.length != 0?
                      "${item.image[0].path.imgUrl()}":"",
                      errorWidget: (context, url, error) => Container(
                          width: 30.0.w,
                          height: 40.0.w,
                          child: NaifarmErrorWidget()),
                    ),
                  ),
                ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.all(1.5.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1.0.w),
                          child: Container(
                            padding: EdgeInsets.only(
                                right: 1.5.w,
                                left: 1.5.w,
                                top: 1.0.w,
                                bottom: 1.0.w),
                            color: ThemeColor.colorSale(),
                            child: Text(
                              "${item.discountPercent}%",
                              style: FunctionHelper.fontTheme(
                                  color: Colors.white,
                                  fontSize: SizeUtil.titleSmallFontSize().sp),
                            ),
                          ),
                        ),
                      ),
                      visible: item.discountPercent > 0 ? true : false,
                    )
                  ],
                ),
                item.stockQuantity==null || item.stockQuantity==0?Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
                      child: Center(
                        child: Container(
                          width: 20.0.w,
                          height: 4.0.h,
                          padding: EdgeInsets.all(2.0.w),
                          decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius:
                              new BorderRadius.all(Radius.circular(10.0.w))),
                          child: Center(
                            child: Text(
                                LocaleKeys.search_product_out_of_stock.tr(),
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.detailFontSize().sp,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ):SizedBox()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _intoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: () {
        // widget.onTapItem(item,item.id)
        AppRoute.productDetail(context,
            productImage: "loadmore_${item.id}$index",
            productItem: ProductBloc.convertDataToProduct(data: item));
      },
    );
  }

  int check(int i) => i != bloc.productMore.length - 1 ? 2 : 1;
}
