import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/recommend/widget/CategoryTab.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/FlashSale.dart';
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
  int _categoryselectedIndex = 0;
  ProductBloc bloc;



  void _init(){
    if(null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getHomeDataCache().then((value){
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
              appBar: AppToobar(
                header_type: Header_Type.barHome,
                isEnable_Search: true,
              ),
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  color: Colors.grey.shade300,
                  child: StickyHeader(
                    header: Column(
                      children: [
                        // BlocBuilder<CustomerCountBloc, CustomerCountRespone>(
                        //   builder: (_, count) {
                        //     return Center(
                        //       child: Text('${count.like}', style: Theme.of(context).textTheme.headline1),
                        //     );
                        //   },
                        // ),
                        StreamBuilder(
                          stream: bloc.ZipHomeObject.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData ) {
                              return CategoryMenu(
                                featuredRespone: (snapshot.data as HomeObjectCombine).featuredRespone,
                                selectedIndex: _categoryselectedIndex,
                                onTap: (int val) {
                                  var data = (snapshot.data as HomeObjectCombine).featuredRespone.data[val];
                                  AppRoute.CategoryDetail(context,data.id , title: data.name);
                                  // setState(() {
                                  //   _categoryselectedIndex = val;
                                  //   _categoryselectedIndex!=0?AppRoute.CategoryDetail(context,_categoryselectedIndex-1):print(_categoryselectedIndex);
                                  // });
                                //  Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));

                                },
                              );
                            }else{
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                    content: Column(
                      children: [

                        StreamBuilder(
                          stream: bloc.ZipHomeObject.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData ) {
                              return Column(
                                children: [
                                  BannerSlide(),
                                  RecommendMenu(homeObjectCombine:(snapshot.data as HomeObjectCombine)),
                                  FlashSale(flashsaleRespone: (snapshot.data as HomeObjectCombine).flashsaleRespone)
                                ],
                              );
                            }else{
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(height: 2.0.h),
                        StreamBuilder(
                          stream: bloc.ZipHomeObject.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if(snapshot.hasData ) {
                                return ProductLandscape(
                                  productRespone: (snapshot.data as HomeObjectCombine).productRespone,
                                    titleInto: LocaleKeys.recommend_best_seller.tr(),
                                    producViewModel: ProductViewModel().getBestSaller(),
                                    IconInto: 'assets/images/svg/product_hot.svg',
                                    onSelectMore: () {
                                      AppRoute.ProductMore(context: context,barTxt: LocaleKeys.recommend_best_seller.tr(),installData: (snapshot.data as HomeObjectCombine).productRespone);
                                    },
                                    onTapItem: (ProductData item,int index) {
                                      AppRoute.ProductDetail(context,
                                          productImage: "product_hot_${index}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                                    },
                                    tagHero: "product_hot");
                              }else{
                                return SizedBox();
                              }
                          },
                        ),
                        SizedBox(height: 2.0.h),
                        _BannerAds(),
                        StreamBuilder(
                          stream: bloc.ZipHomeObject.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData ) {
                              return  ProductVertical(
                                productRespone:  (snapshot.data as HomeObjectCombine).martket,
                                  titleInto: LocaleKeys.recommend_market.tr(),
                                  IconInto: 'assets/images/svg/menu_market.svg',
                                  onSelectMore: () {
                                     AppRoute.ShopMain(context);
                                  },
                                  onTapItem: (ProductData item,int index) {
                                    AppRoute.ProductDetail(context,
                                        productImage: "market_${index}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                                  },
                                  borderRadius: false,
                                  tagHero: "market");
                            }else{
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(height: 2.0.h),
                        StreamBuilder(
                          stream: bloc.ZipHomeObject.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData ) {
                              return CategoryTab(categoryGroupRespone: (snapshot.data as HomeObjectCombine).categoryGroupRespone);
                            }else{
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(height: 2.0.h),
                        StreamBuilder(
                          stream: bloc.ZipHomeObject.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData ) {
                              return  SearchHot(productRespone: (snapshot.data as HomeObjectCombine).trendingRespone,onSelectChang: () {});
                            }else{
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(height: 2.0.h),
                        StreamBuilder(
                          stream: bloc.ZipHomeObject.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData ) {
                              return  ProductVertical(
                                productRespone: (snapshot.data as HomeObjectCombine).trendingRespone,
                                  titleInto: LocaleKeys.recommend_product_for_you.tr(),
                                  IconInto: 'assets/images/svg/foryou.svg',
                                  onSelectMore: () {
                                    AppRoute.ProductMore(context: context,barTxt: LocaleKeys.recommend_product_for_you.tr(),installData: (snapshot.data as HomeObjectCombine).trendingRespone);
                                  },
                                  onTapItem: (ProductData item,int index) {
                                    AppRoute.ProductDetail(context,
                                        productImage: "foryou_${index}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                                  },
                                  borderRadius: false,
                                  tagHero: "foryou");
                            }else{
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
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
