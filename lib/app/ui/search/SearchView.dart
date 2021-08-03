import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/ui/recommend/widget/SearchHot.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

class SearchView extends StatelessWidget {

  List<String> listClone = <String>[];
  bool checkSeemore = false;
  TextEditingController txtController = TextEditingController();

  ProductBloc bloc;
  bool showMore = false;
  final searchText = BehaviorSubject<String>();

  void _init(BuildContext context) {
    if (null == bloc) {
      searchText.add("");
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.loadMoreData(context,
          page: "1", limit: 6, link: "products/types/random");
      bloc.loadProductSearch(context,
          page: "1", query: searchText.value, limit: showMore ? 6 : 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppToobar(
            icon: "",
            isEnableSearch: false,
            headerType: Header_Type.barHome,
            hint: LocaleKeys.search_product_title.tr(),
            onSearch: (String text) {
              searchLike(context,text);
            },
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: SizeUtil.paddingTitle()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: bloc.searchProduct.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            color: Colors.white,
                            child: (snapshot.data as SearchRespone)
                                .hits.length!=0?Column(
                              children: (snapshot.data as SearchRespone)
                                  .hits
                                  .asMap()
                                  .map((key, value) => MapEntry(
                                      key,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 1.0.w,
                                                  top: 1.0.w,
                                                  right: 3.0.w,
                                                  left: 3.0.w),
                                              child: Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            (snapshot.data
                                                                    as SearchRespone)
                                                                .hits[key]
                                                                .name,
                                                            style: FunctionHelper.fontTheme(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: SizeUtil
                                                                        .titleSmallFontSize()
                                                                    .sp)),
                                                        Text(
                                                            (snapshot.data
                                                                    as SearchRespone)
                                                                .hits[key]
                                                                .categories[0]
                                                                .name,
                                                            style: FunctionHelper
                                                                .fontTheme(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        SizeUtil.titleSmallFontSize()
                                                                            .sp))
                                                      ],
                                                    ),
                                                  ),
                                                  /*Hero(
                                                    tag:
                                                        "search_${(snapshot.data as SearchRespone).hits[key].productId}",
                                                    child:*/
                                                  CachedNetworkImage(
                                                    width: 13.0.w,
                                                    height: 15.0.w,
                                                    imageUrl: "${(snapshot.data as SearchRespone).hits[key].image.length != 0 ? (snapshot.data as SearchRespone).hits[key].image[0].path.imgUrl() : ""}",
                                                    imageBuilder: (context, imageProvider) => Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: imageProvider),
                                                      ),
                                                    ),
                                                    placeholder: (context, url) =>Container(
                                                      width: 13.0.w,
                                                      height: 15.0.w,
                                                      color: Colors.white,
                                                      child: Lottie.asset(
                                                        'assets/json/loading.json',
                                                        width: 13.0.w,
                                                        height: 15.0.w,
                                                      ),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                        width: 13.0.w,
                                                        height: 15.0.w,
                                                        child: Image.network(
                                                            Env.value.noItemUrl,
                                                            fit: BoxFit
                                                                .cover)),
                                                  ),
                                                  //)
                                                ],
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                            onTap: () {
                                              var item = (snapshot.data
                                                      as SearchRespone)
                                                  .hits[key];
                                              FocusScope.of(context).unfocus();
                                              AppRoute.productDetail(context,
                                                  productImage:
                                                      "search_${(snapshot.data as SearchRespone).hits[key].productId}",
                                                  productItem:
                                                      ProducItemRespone(
                                                    id: item.productId,
                                                    shopId: item.shopId,
                                                    shop: ShopItem(
                                                        id: item.shopId),
                                                    name: item.name,
                                                    salePrice: item.salePrice,
                                                    offerPrice: item.offerPrice,
                                                    saleCount: item.saleCount,
                                                    image: item.image,
                                                  ));
                                            },
                                          ),
                                          buildLine()
                                        ],
                                      )))
                                  .values
                                  .toList(),
                            ):Container(height: 6.0.h,
                              child: Center(
                                child: Text("${LocaleKeys.search_product_not_found.tr()}" ,style: FunctionHelper.fontTheme(
                                color: Colors.grey,
                                    fontSize:
                                    SizeUtil.titleSmallFontSize().sp)),
                              ),
                            ));
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  InkWell(
                    child: StreamBuilder(
                      stream: bloc.searchProduct.stream,
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          var item = (snapshot.data as SearchRespone);
                          return Visibility(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                    item.hits.length == 0
                                        ? LocaleKeys.search_product_not_found
                                            .tr()
                                        : showMore
                                            ? LocaleKeys.search_product_hide
                                                .tr()
                                            : LocaleKeys.search_product_show
                                                .tr(),
                                    style: FunctionHelper.fontTheme(
                                        color: Colors.grey,
                                        fontSize:
                                            SizeUtil.titleSmallFontSize().sp)),
                              ),
                            ),
                            visible: item.limit == 0 || item.nbHits <= 4
                                ? false
                                : true,
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    onTap: () {
                      // setState(() {
                      //   checkSeemore ? checkSeemore = false : checkSeemore = true;
                      // });
                      if (bloc.searchProduct.value.hits.length > 0) {
                        showMore = !showMore;
                        bloc.loadProductSearch(context,
                            page: "1",
                            query: searchText.value,
                            limit: showMore ? 6 : 4);
                      }
                    },
                  ),
                  Container(),
                  StreamBuilder(
                    stream: bloc.moreProduct.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data as ProductRespone).data.isNotEmpty) {
                          return Column(
                            children: [
                              Container(
                                color: Colors.grey.shade200,
                                height: 6,
                              ),
                              SearchHot(
                                  productRespone: snapshot.data,
                                  onSelectChang: () {}),

                            ],
                          );
                        } else {
                          return SizedBox();
                        }
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Platform.isAndroid
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator()
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 1.0.h,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLine() {
    return Container(
      height: 2,
      color: Colors.grey.shade100,
    );
  }

  void searchLike(BuildContext context,String text) {
    // listClone.clear();
    // for(int i=0;i<searchList.length;i++){
    //   if(searchList[i].contains(text)){
    //     listClone.add(searchList[i]);
    //   }
    // }
   // searchText = text;
    searchText.add(text);
    bloc.loadProductSearch(context,
        page: "1", query: searchText.value, limit: showMore ? 6 : 4);
  }
}
