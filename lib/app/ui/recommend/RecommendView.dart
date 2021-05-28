import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/HomeDataBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SliderRespone.dart';
import 'package:naifarm/app/ui/flashsale/FlashSaleView.dart';
import 'package:naifarm/app/ui/home/HomeHeader.dart';
import 'package:naifarm/app/ui/recommend/widget/CategoryTab.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/utility/OneSignalCall.dart';
import 'package:naifarm/utility/widgets/BannerSlide.dart';
import 'package:naifarm/utility/widgets/LifecycleWatcherState.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:rxdart/subjects.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'widget/RecommendMenu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class RecommendView extends StatefulWidget {
  final Size size;
  final double paddingBottom;
  final Function(int) onClick;
  const RecommendView({Key key, this.size, this.paddingBottom, this.onClick})
      : super(key: key);

  @override
  _RecommendViewState createState() => _RecommendViewState();
}

class _RecommendViewState extends LifecycleWatcherState<RecommendView> {
  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;
  bool onReLoad = true;
  bool onDialog = true;
  ProductBloc bloc;
  HomeObjectCombine tempData;
  final _selectedIndex = BehaviorSubject<int>();

  void _init() {
    _selectedIndex.add(0);
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onSuccess.stream.listen((event) {
        if (event is bool) {
          OneSignalCall.cancelNotification("", 0);
          context.read<HomeDataBloc>().loadHomeData(context);
          // _refreshProducts();
        } else {
          NaiFarmLocalStorage.getHomeDataCache().then((value) {
            onReLoad = true;
            bloc.zipHomeObject.add(value);
          });
        }
      });
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        onDialog = false;
        if (event.status == 0 || event.status >= 500) {
          Future.delayed(const Duration(milliseconds: 300), () {
            FunctionHelper.alertDialogRetry(context,
                cancalMessage: LocaleKeys.btn_exit.tr(),
                callCancle: () {
                  Navigator.of(context).pop();
                },
                title: LocaleKeys.btn_error.tr(),
                message: event.message,
                callBack: () {
                  onDialog = true;
                  // _refreshProducts();
                  onResumed();
                });
          });
        }
      });
      // bloc.loadHomeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Platform.isAndroid
        ? androidRefreshIndicator()
        : iosRefreshIndicator();
  }

  Widget androidRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: contentMain,
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
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        top: 25 * controller.value,
                        child: SpinKitThreeBounce(
                          color: ThemeColor.primaryColor(),
                          size: 30,
                        ),
                      )
                    ],
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
        child: contentMain);
  }

  Widget get contentMain => Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: _selectedIndex.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return IndexedStack(
              index: snapshot.data,
              children: [
                BlocBuilder<HomeDataBloc, HomeDataState>(
                  builder: (_, item) {
                    if (item is HomeDataLoaded) {
                      return SingleChildScrollView(
                        child: Container(
                          child: StickyHeader(
                            header: Column(
                              children: [
                                HomeHeader(
                                    snapshot: item.homeObjectCombine,
                                    onTap: (CategoryGroupData val) {
                                      AppRoute.categoryDetail(context, val.id,
                                          title: val.name);
                                    }),
                              ],
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  content(item: item.homeObjectCombine),
                                ]),
                          ),
                        ),
                      );
                    } else {
                      // if (onDialog) {
                      //   onDialog = false;
                      //   bloc.onError.add(ThrowIfNoSuccess(
                      //       status: 500,
                      //       message:
                      //           item.homeObjectCombine.httpCallBack.message));
                      // }

                      return SingleChildScrollView(
                        child: Container(
                          child: StickyHeader(
                            header: Column(
                              children: [
                                HomeHeader(
                                    snapshot: HomeObjectCombine(),
                                    onTap: (CategoryGroupData val) {
                                      AppRoute.categoryDetail(context, val.id,
                                          title: val.name);
                                    }),
                              ],
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  content(item: HomeObjectCombine()),
                                ]),
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            );
          },
        ),
      );

  Widget content({HomeObjectCombine item}) {
    return Column(
      children: [
        item != null &&
                item.sliderRespone != null &&
                item.sliderRespone.data.isNotEmpty
            ? BannerSlide(
                image: item.sliderRespone.data
                    .map((e) =>
                        "${Env.value.baseUrl}/storage/images/${e.image[0].path}")
                    .toList())
            : SizedBox(),
        SizedBox(height: 1.0.h),
        RecommendMenu(
          homeObjectCombine: item,
          onClick: (int index) {
            widget.onClick(index);
          },
        ),

        item != null && item.flashsaleRespone != null
            ? FlashSale(flashsaleRespone: item.flashsaleRespone)
            : SizedBox(),
        Container(
          height: 1.0.h,
          color: Colors.grey.withOpacity(0.5),
        ),
        ProductLandscape(
          productRespone: item != null ? item.productRespone : null,
          titleInto: LocaleKeys.recommend_best_seller.tr(),
          producViewModel: ProductViewModel().getBestSaller(),
          imageIcon: 'assets/images/png/product_hot.png',
          iconSize: 7.0.w,
          onSelectMore: () {
            AppRoute.productMore(
                apiLink: "products/types/popular",
                context: context,
                barTxt: LocaleKeys.recommend_best_seller.tr());
          },
          onTapItem: (ProductData item, int index) {
            AppRoute.productDetail(context,
                productImage: "product_hot_${item.id}1",
                productItem: ProductBloc.convertDataToProduct(data: item));
          },
          tagHero: "product_hot",
        ),
        Container(
          height: 1.0.h,
          color: Colors.grey.withOpacity(0.5),
        ),
        // SizedBox(height: 1.5.h),
        // _BannerAds(),

        ProductVertical(
            productRespone: item != null ? item.martket : null,
            titleInto: LocaleKeys.recommend_market.tr(),
            imageIcon: 'assets/images/png/menu_market.png',
            onSelectMore: () {
              AppRoute.shopMain(
                  context: context, myShopRespone: MyShopRespone(id: 1));
            },
            onTapItem: (ProductData item, int index) {
              AppRoute.productDetail(context,
                  productImage: "market_$index",
                  productItem: ProductBloc.convertDataToProduct(data: item));
            },
            borderRadius: false,
            tagHero: "market"),
        Container(
          height: 1.0.h,
          color: Colors.grey.withOpacity(0.5),
        ),
        CategoryTab(
            categoryGroupRespone:
                item != null ? item.categoryGroupRespone : null),
        Container(
          height: 1.0.h,
          color: Colors.grey.withOpacity(0.5),
        ),
        ProductVertical(
            productRespone: item != null ? item.productForyou : null,
            titleInto: LocaleKeys.tab_bar_recommend.tr(),
            imageIcon: 'assets/images/png/like.png',
            iconSize: 6.0.w,
            onSelectMore: () {
              AppRoute.productMore(
                  context: context,
                  apiLink: "products/types/trending",
                  barTxt: LocaleKeys.tab_bar_recommend.tr());
            },
            onTapItem: (ProductData item, int index) {
              AppRoute.productDetail(context,
                  productImage: "recommend_$index",
                  productItem: ProductBloc.convertDataToProduct(data: item));
            },
            borderRadius: false,
            tagHero: "recommend"),
        SizedBox(height: 10.0.h),
      ],
    );
  }

  bannerAds() {
    return Container(
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          color: Colors.white,
          child: Lottie.asset('assets/json/loading.json', height: 30),
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

  Future<Null> _refreshProducts() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
      // AudioCache().play("sound/Click.mp3");
      // Vibration.vibrate(duration: 500);
    }
    Usermanager().getUser().then(
          (value) => bloc.loadCustomerCount(context, token: value.token),
        );
    /*context.read<HomeDataBloc>().loadHomeData(context);
    Usermanager().getUser().then((value) => context
        .read<CustomerCountBloc>()
        .loadCustomerCount(context, token: value.token));
    Usermanager().getUser().then((value) => context
        .read<InfoCustomerBloc>()
        .loadCustomInfo(context, token: value.token));*/
    // bloc.loadHomeData(context: context,callback: true);
  }

  List<String> convertSliderImage({SliderRespone sliderRespone}) {
    List<String> image = <String>[];
    if (sliderRespone.data.isNotEmpty) {
      for (var item in sliderRespone.data[0].image) {
        image.add(item.path);
      }
    }

    return image;
  }

  @override
  void onDetached() {
    // print("wefc onDetached");
  }

  @override
  void onInactive() {
    //  print("wefc onInactive");
  }

  @override
  void onPaused() {
    //  print("wefc onPaused");
  }

  @override
  void onResumed() {
    NaiFarmLocalStorage.getNowPage().then((value) {
      if (value == 0) {
        Usermanager().getUser().then(
              (value) => bloc.loadCustomerCount(context, token: value.token),
            );
        // OneSignalCall.cancelNotification("", 0);
        // _refreshProducts();
      }
    });
  }
}
