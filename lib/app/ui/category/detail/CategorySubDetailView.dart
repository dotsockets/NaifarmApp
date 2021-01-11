import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:easy_localization/easy_localization.dart';

class CategorySubDetailView extends StatefulWidget {
  final int index;
  final String title;
  CategorySubDetailView({Key key, this.index, this.title}) : super(key: key);
  @override
  _CategorySubDetailViewState createState() => _CategorySubDetailViewState();
}

class _CategorySubDetailViewState extends State<CategorySubDetailView> {
  final _scrollController = TrackingScrollController();
  final _indicatorController = IndicatorController();

  ProductBloc bloc;

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _init(){
    if(null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.loadProductTrending("1");
      bloc.loadProductPopular("1");
    }

  }



  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade300,
            child: StickyHeader(
              header: Column(
                children: [
                  AppToobar(
                    title: widget.title+" : "+widget.index.toString(),
                    header_type: Header_Type.barcartShop,
                    isEnable_Search: true,
                  ),
                ],
              ),
              content: Column(
                children: [

                  StreamBuilder(
                    stream: bloc.TrendingGroup.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return Column(
                          children: [
                            ProductLandscape(
                              showSeeMore: false,
                                productRespone: snapshot.data,
                                titleInto: LocaleKeys.tab_bar_recommend.tr(),
                              //  showBorder: true,
                                IconInto: 'assets/images/svg/like.svg',
                              //  api_link: 'products',
                               /* onSelectMore: () {
                                  AppRoute.ProductMore(context:context,barTxt:LocaleKeys.tab_bar_recommend.tr(),productList:ProductViewModel().getMarketRecommend());
                                },*/
                                onTapItem: (ProductData item,int index) {
                                  AppRoute.ProductDetail(context,
                                      productImage: "recommend_sub_${item.id}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                                },
                                tagHero: 'recommend_sub'),
                            _BannerAds(),
                          ],
                        );
                      }else{
                        return Skeleton.LoaderLandscape(context);
                      }
                    },
                  ),
                  SizedBox(height: 1.0.h),
                  StreamBuilder(
                    stream: bloc.ProductPopular.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return ProductVertical(
                          titleInto: LocaleKeys.recommend_best_seller.tr(),
                          productRespone: snapshot.data,
                          IconInto: 'assets/images/svg/product_hot.svg',
                          onSelectMore: () {
                            AppRoute.ProductMore(context:context,barTxt:LocaleKeys.recommend_best_seller.tr());
                          },
                          onTapItem: (ProductData item,int index) {
                            AppRoute.ProductDetail(context,
                                productImage: "sell_${index}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                          },
                          borderRadius: false,
                          IconSize: 25,
                          tagHero: "sell",
                        );
                      }else{
                        return Skeleton.LoaderListTite(context);
                      }
                    },
                  )

                ],
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
