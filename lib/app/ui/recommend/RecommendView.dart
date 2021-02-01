
import 'package:audioplayers/audio_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
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

  const RecommendView({Key key, this.size, this.paddingBottom})
      : super(key: key);

  @override
  _RecommendViewState createState() => _RecommendViewState();
}

class _RecommendViewState extends State<RecommendView> {
  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;
  int _categoryselectedIndex = 0;
  ProductBloc bloc;
  final _selectedIndex = BehaviorSubject<int>();

  void _init() {
    _selectedIndex.add(0);
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onSuccess.stream.listen((event) {
        NaiFarmLocalStorage.getHomeDataCache().then((value) {
          bloc.ZipHomeObject.add(value);
        });
      });
      NaiFarmLocalStorage.getHomeDataCache().then((value) {
        bloc.ZipHomeObject.add(value);
      });
      // bloc.loadHomeData();
    }
  }



  @override
  Widget build(BuildContext context) {
    _init();
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
                    AudioCache().play("sound/Click.mp3");

                    Vibration.vibrate(duration: 500);
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
        child: Scaffold(
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
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      BannerSlide(),
                                      RecommendMenu(
                                          homeObjectCombine: (snapshot.data
                                              as HomeObjectCombine)),
                                      SizedBox(height: 1.0.h,),
                                      FlashSale(
                                          flashsaleRespone: (snapshot.data
                                                  as HomeObjectCombine)
                                              .flashsaleRespone)
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
                                            barTxt: LocaleKeys
                                                .recommend_best_seller
                                                .tr(),
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
                            SizedBox(height: 1.5.h),
                            _BannerAds(),
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
                            SizedBox(height: 2.0.h),
                            StreamBuilder(
                              stream: bloc.ZipHomeObject.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return SearchHot(
                                      tagHero: "searchHot",
                                      productRespone:
                                          (snapshot.data as HomeObjectCombine)
                                              .trendingRespone,
                                      onSelectChang: () {});
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
                                  return ProductVertical(
                                      productRespone:
                                          (snapshot.data as HomeObjectCombine)
                                              .product_foryou,
                                      titleInto: LocaleKeys
                                          .recommend_product_for_you
                                          .tr(),
                                      IconInto: 'assets/images/svg/foryou.svg',
                                      onSelectMore: () {
                                        AppRoute.ProductMore(
                                            context: context,
                                            api_link: "products/types/random",
                                            barTxt: LocaleKeys
                                                .recommend_product_for_you
                                                .tr(),
                                            installData: (snapshot.data
                                                    as HomeObjectCombine)
                                                .product_foryou);
                                      },
                                      onTapItem: (ProductData item, int index) {
                                        AppRoute.ProductDetail(context,
                                            productImage: "foryou_${index}",
                                            productItem: ProductBloc
                                                .ConvertDataToProduct(
                                                    data: item));
                                      },
                                      borderRadius: false,
                                      tagHero: "foryou");
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ));
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

  _refreshProducts() {
    bloc.loadHomeData(callback: true);
  }
}
