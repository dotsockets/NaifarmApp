import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BannerSlide.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryDetailView extends StatefulWidget {
  final int index;
  final String title;
  CategoryDetailView({Key key, this.index, this.title}) : super(key: key);
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
    if(null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      // bloc.onLoad.stream.listen((event) {
      //   if(event){
      //         FunctionHelper.showDialogProcess(context);
      //       }else{
      //         Navigator.of(context).pop();
      //       }
      // });
      bloc.loadCategoryPage(GroupId: widget.index);
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
                    title: widget.title,
                    header_type: Header_Type.barcartShop,
                    isEnable_Search: true,
                  ),
                  StreamBuilder(
                    stream: bloc.ZipCategoryObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return CategoryMenu(
                          featuredRespone: (snapshot.data as CategoryObjectCombin).supGroup,
                          selectedIndex:_categoryselectedIndex,
                          onTap: (int val) {
                             AppRoute.CategorySubDetail(context, (snapshot.data as CategoryObjectCombin).supGroup.data[val].id,title:(snapshot.data as CategoryObjectCombin).supGroup.data[val].name );
                            // setState(() {
                            //   _categoryselectedIndex = val;
                            //   _categoryselectedIndex!=0?AppRoute.CategoryDetail(context,_categoryselectedIndex-1):print(_categoryselectedIndex);
                            // });
                          },
                        );
                      }else{
                        return SizedBox();
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
                  StreamBuilder(
                    stream: bloc.ZipCategoryObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return BannerSlide();
                      }else{
                        return Skeleton.LoaderSlider(context);
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  StreamBuilder(
                    stream: bloc.ZipCategoryObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return ProductGrid(
                            productRespone: (snapshot.data as CategoryObjectCombin).hotProduct,
                            titleInto: LocaleKeys.tab_bar_recommend.tr(),
                            showBorder: true,
                            IconInto: 'assets/images/svg/like.svg',
                            api_link: 'products',
                            onSelectMore: () {
                              AppRoute.ProductMore(context:context,barTxt:LocaleKeys.tab_bar_recommend.tr());
                            },
                            onTapItem: (ProductData item,int index) {
                              AppRoute.ProductDetail(context,
                                  productImage: "recommend_${item.id}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                            },
                            tagHero: 'recommend');
                      }else{
                        return Skeleton.LoaderGridV(context);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  _BannerAds(),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: bloc.ZipCategoryObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        return ProductVertical(
                          titleInto: LocaleKeys.recommend_best_seller.tr(),
                          productRespone: (snapshot.data as CategoryObjectCombin).recommend,
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
