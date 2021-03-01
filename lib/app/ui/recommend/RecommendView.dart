
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SliderRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/detail/CategoryDetailView.dart';
import 'package:naifarm/app/ui/flashsale/FlashSaleView.dart';
import 'package:naifarm/app/ui/home/HomeHeader.dart';
import 'package:naifarm/app/ui/recommend/widget/CategoryTab.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/FlashSaleBar.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BannerSlide.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:naifarm/utility/widgets/LifecycleWatcherState.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:rxdart/subjects.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:vibration/vibration.dart';
import 'widget/RecommendMenu.dart';
import 'widget/SearchHot.dart';
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
  ProductBloc bloc;
  HomeObjectCombine temp_data;
  final _selectedIndex = BehaviorSubject<int>();

  void _init() {
    _selectedIndex.add(0);
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onSuccess.stream.listen((event) {
        NaiFarmLocalStorage.getHomeDataCache().then((value) {
          onReLoad = true;
          bloc.ZipHomeObject.add(value);
        });
      });
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      NaiFarmLocalStorage.getHomeDataCache().then((value) {
        temp_data = value;
        bloc.ZipHomeObject.add(value);
      });
      // bloc.loadHomeData();
    }
  }



  @override
  Widget build(BuildContext context) {
    _init();
    return Platform.isAndroid?AndroidRefreshIndicator():IOSRefreshIndicator();
  }

  Widget AndroidRefreshIndicator(){
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: Content_Main,
    );
  }

  Widget IOSRefreshIndicator(){
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
                builder: (BuildContext context, Widget _)  {
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
        child: Content_Main
    );
  }

  Widget get Content_Main => Scaffold(
    body: StreamBuilder(
      stream: _selectedIndex.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return IndexedStack(
          index: snapshot.data,
          children: [
            SingleChildScrollView(
              child: Container(
                color: Colors.grey.shade300,
                child: StickyHeader(
                  header: Column(
                    children: [
                      StreamBuilder(
                        stream: bloc.ZipHomeObject.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return HomeHeader(
                                snapshot:
                                (snapshot.data as HomeObjectCombine),
                                onTap: (CategoryGroupData val) {
                                  AppRoute.CategoryDetail(context, val.id,
                                      title: val.name);
                                });
                          } else {
                            return HomeHeader(
                                snapshot: HomeObjectCombine());
                          }
                        },
                      ),
                    ],
                  ),
                  content: Column(
                    children: [
                      StreamBuilder(
                        stream: bloc.ZipHomeObject.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          var item = (snapshot.data as HomeObjectCombine);
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                item.sliderRespone!=null?item.sliderRespone.data.isNotEmpty?BannerSlide(image: ConvertSliderImage(sliderRespone: item.sliderRespone)):SizedBox():SizedBox(),
                                RecommendMenu(
                                  homeObjectCombine: (snapshot.data
                                  as HomeObjectCombine),
                                  onClick: (int index){
                                    widget.onClick(index);
                                  },),
                                SizedBox(height: 1.0.h,),
                                item
                                    .flashsaleRespone!=null?FlashSale(
                                    flashsaleRespone: item
                                        .flashsaleRespone):SizedBox()
                              ],
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      SizedBox(height: 1.5.h),
                      StreamBuilder(
                        stream: bloc.ZipHomeObject.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ProductLandscape(
                                productRespone:
                                (snapshot.data as HomeObjectCombine)
                                    .productRespone,
                                titleInto:
                                LocaleKeys.recommend_best_seller.tr(),
                                producViewModel:
                                ProductViewModel().getBestSaller(),
                                IconInto:
                                'assets/images/svg/product_hot.svg',
                                onSelectMore: () {
                                  AppRoute.ProductMore(
                                      api_link: "products/types/popular",
                                      context: context,
                                      barTxt: LocaleKeys.recommend_best_seller.tr(),
                                      installData: (snapshot.data
                                      as HomeObjectCombine)
                                          .productRespone);
                                },
                                onTapItem: (ProductData item, int index) {
                                  AppRoute.ProductDetail(context,
                                      productImage:
                                      "product_hot_${item.id}1",
                                      productItem: ProductBloc
                                          .ConvertDataToProduct(
                                          data: item));
                                },
                                tagHero: "product_hot");
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                     // SizedBox(height: 1.5.h),
                     // _BannerAds(),
                      SizedBox(height: 1.5.h),
                      StreamBuilder(
                        stream: bloc.ZipHomeObject.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ProductVertical(
                                productRespone:
                                (snapshot.data as HomeObjectCombine)
                                    .martket,
                                titleInto:
                                LocaleKeys.recommend_market.tr(),
                                IconInto:
                                'assets/images/svg/menu_market.svg',
                                onSelectMore: () {
                                  AppRoute.ShopMain(
                                      context: context,
                                      myShopRespone:
                                      MyShopRespone(id: 1));
                                },
                                onTapItem: (ProductData item, int index) {
                                  AppRoute.ProductDetail(context,
                                      productImage: "market_${index}",
                                      productItem: ProductBloc
                                          .ConvertDataToProduct(
                                          data: item));
                                },
                                borderRadius: false,
                                tagHero: "market");
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      SizedBox(height: 2.0.h),
                      StreamBuilder(
                        stream: bloc.ZipHomeObject.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return CategoryTab(
                                categoryGroupRespone:
                                (snapshot.data as HomeObjectCombine)
                                    .categoryGroupRespone);
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      // SizedBox(height: 2.0.h),
                      // StreamBuilder(
                      //   stream: bloc.ZipHomeObject.stream,
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot snapshot) {
                      //     if (snapshot.hasData) {
                      //       return SearchHot(
                      //           tagHero: "searchHot",
                      //           productRespone:
                      //           (snapshot.data as HomeObjectCombine)
                      //               .trendingRespone,
                      //           onSelectChang: () {});
                      //     } else {
                      //       return SizedBox();
                      //     }
                      //   },
                      // ),
                      SizedBox(height: 2.0.h),
                      StreamBuilder(
                        stream: bloc.ZipHomeObject.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ProductVertical(
                                productRespone:
                                (snapshot.data as HomeObjectCombine)
                                    .product_foryou,
                                titleInto: LocaleKeys
                                    .tab_bar_recommend
                                    .tr(),
                                IconInto: 'assets/images/svg/like.svg',
                                IconSize: 6.0.w,
                                onSelectMore: () {
                                  AppRoute.ProductMore(
                                      context: context,
                                      api_link: "products/types/trending",
                                      barTxt: LocaleKeys
                                          .tab_bar_recommend
                                          .tr());
                                },
                                onTapItem: (ProductData item, int index) {
                                  AppRoute.ProductDetail(context,
                                      productImage: "recommend_${index}",
                                      productItem: ProductBloc
                                          .ConvertDataToProduct(
                                          data: item));
                                },
                                borderRadius: false,
                                tagHero: "recommend");
                          } else {
                            return SizedBox();
                          }
                        },
                      ),SizedBox(height: 10.0.h,)
                    ]
                  ),
                ),
              ),
            )
          ],
        );
      },
    ),
  );

  _BannerAds() {
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


  Future<Null>  _refreshProducts() async{
    if(Platform.isAndroid){
      await Future.delayed(Duration(seconds: 2));
      // AudioCache().play("sound/Click.mp3");
      // Vibration.vibrate(duration: 500);
    }
    Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
    Usermanager().getUser().then((value) =>  context.read<InfoCustomerBloc>().loadCustomInfo(token:value.token));
    Future.delayed(const Duration(milliseconds: 500), () {
      bloc.loadHomeData(context: context,callback: true);
    });

  }

  List<String> ConvertSliderImage({SliderRespone sliderRespone}){
    List<String> image = List<String>();
    if(sliderRespone.data.isNotEmpty){
      for(var item in sliderRespone.data[0].image){
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
    NaiFarmLocalStorage.getNowPage().then((value){
      if(value==0 && onReLoad){
       onReLoad = false;
       _refreshProducts();
      }
    });

  }
}
