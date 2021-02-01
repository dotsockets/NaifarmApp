import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BannerSlide.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

import 'CategoryHeader.dart';

class CategoryDetailView extends StatefulWidget {
  final int index;
  final String title;
  final HomeObjectCombine snapshot;
  CategoryDetailView({Key key, this.index, this.title, this.snapshot}) : super(key: key);
  @override
  _CategoryDetailViewState createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<CategoryDetailView> {
  final _scrollController = TrackingScrollController();
  final _indicatorController = IndicatorController();
  int _categoryselectedIndex = 0;
  ProductBloc bloc;

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _init(){
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        // if(event){
        //       FunctionHelper.showDialogProcess(context);
        //     }else{
        //       Navigator.of(context).pop();
        //     }
      });
      bloc.loadCategoryPage(GroupId: widget.index);


  }




  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade300,
            child: StickyHeader(
              header: Column(
                children: [
                  StreamBuilder(
                    stream: bloc.ZipCategoryObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return CategoryHeader(title: widget.title,snapshot: (snapshot.data as CategoryObjectCombin));
                      }else{
                        return CategoryHeader(title: widget.title);
                      }
                    },
                  ),
                  // CategoryMenu(
                  //   selectedIndex: _categoryselectedIndex,
                  //   menuViewModel: _menuViewModel,
                  //   onTap: (int val) {
                  //     setState(() {
                  //       _categoryselectedIndex = val;
                  //     });
                  //   },
                  // ),
                ],
              ),
              content: Column(
                children: [

                  SizedBox(height: 1.5.h),
                  StreamBuilder(
                    stream: bloc.ZipCategoryObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData ) {
                        return ProductLandscape(
                            showSeeMore: true,
                            IsborderRadius: true,
                            productRespone: (snapshot.data as CategoryObjectCombin).goupProduct,
                            titleInto: LocaleKeys.tab_bar_recommend.tr(),
                            //  showBorder: true,
                            IconInto: 'assets/images/svg/like.svg',
                             // api_link: 'products',
                             onSelectMore: () {
                                  AppRoute.ProductMore(installData: (snapshot.data as CategoryObjectCombin).goupProduct,context:context,barTxt:LocaleKeys.tab_bar_recommend.tr(),api_link: 'products/types/trending?categoryGroupId=${widget.index}');
                                },
                            onTapItem: (ProductData item,int index) {
                              AppRoute.ProductDetail(context,
                                  productImage: "recommend_cate_${item.id}${1}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                            },
                            tagHero: 'recommend_cate');
                      }else{

                        return Skeleton.LoaderLandscape(context);
                      }
                    },
                  ),
                  SizedBox(height: 1.2.h),
                  StreamBuilder(
                    stream: bloc.TrendingGroup.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return Column(
                          children: [
                            _BannerAds(),
                            SizedBox(height: 1.2.h),
                          ],
                        );
                      }else{
                        return Column(
                          children: [
                            _BannerAds(),
                            SizedBox(height: 1.2.h),
                          ],
                        );
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: bloc.ZipCategoryObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData ) {
                        return ProductVertical(
                          titleInto: LocaleKeys.recommend_best_seller.tr(),
                          productRespone: (snapshot.data as CategoryObjectCombin).hotProduct,
                          IconInto: 'assets/images/svg/product_hot.svg',
                          onSelectMore: () {
                            AppRoute.ProductMore(api_link: "products/types/popular?categoryGroupId=${widget.index}",context:context,barTxt:LocaleKeys.recommend_best_seller.tr(),installData: (snapshot.data as CategoryObjectCombin).hotProduct);
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
                  ),

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
