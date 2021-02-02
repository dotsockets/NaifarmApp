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
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  List<String> listClone = List<String>();
  bool checkSeemore = false;
  TextEditingController txtController = TextEditingController();
  String SearchText = "";
  ProductBloc bloc;
  bool showMore = false;

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.loadProductTrending(page: "1",limit:  6);
      bloc.loadProductSearch(page: "1", query: SearchText, limit: showMore?6:4);
    }
  }



  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: StickyHeader(
              header: AppToobar(
                icon: "",
                isEnable_Search: false,
                header_type: Header_Type.barHome,
                hint: LocaleKeys.search_product_title.tr(),
                onSearch: (String text) {
                  setState(() {
                    SearchLike(text);
                  });
                },
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: bloc.SearchProduct.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.white,
                          child: Column(
                            children: (snapshot.data as SearchRespone).hits.asMap().map((key, value) => MapEntry(key, Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 1.0.w,top: 1.0.w,right: 3.0.w,left: 3.0.w),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child:  Text(
                                            (snapshot.data as SearchRespone)
                                                .hits[key]
                                                .name,
                                            style: FunctionHelper.FontTheme(
                                                color: Colors.black,
                                                fontSize: SizeUtil
                                                    .titleSmallFontSize()
                                                    .sp)),),
                                        Hero(
                                          tag:"search_${(snapshot.data as SearchRespone).hits[key].productId}",
                                          child: CachedNetworkImage(
                                            width: 13.0.w,
                                            height: 15.0.w,
                                            placeholder: (context, url) => Container(
                                              width: 13.0.w,
                                              height: 15.0.w,
                                              color: Colors.white,
                                              child: Lottie.asset(Env.value.loadingAnimaion,   width: 13.0.w,
                                                height: 13.5.w,),
                                            ),
                                            imageUrl: "${Env.value.baseUrl}/storage/images/${(snapshot.data as SearchRespone).hits[key].image.length!=0?(snapshot.data as SearchRespone).hits[key].image[0].path:""}",
                                            errorWidget: (context, url, error) => Container(
                                                width: 13.0.w,
                                                height: 15.0.w,
                                                child: Image.network("https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com",fit: BoxFit.cover)),
                                          ),
                                        )
                                      ],
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  onTap: () {
                                    var item = (snapshot.data as SearchRespone).hits[key];
                                    FocusScope.of(context).unfocus();
                                    AppRoute.ProductDetail(context,
                                        productImage: "search_${(snapshot.data as SearchRespone).hits[key].productId}",
                                        productItem: ProducItemRespone(
                                          id: item.productId,
                                          shopId: item.shopId,
                                          shop: ShopItem(id: item.shopId),
                                          name: item.name,
                                          salePrice: item.salePrice,offerPrice: item.offerPrice,saleCount: item.saleCount,
                                          image: item.image,));
                                  },
                                ),
                                _BuildLine()
                              ],
                            ))).values.toList(),
                          )
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  InkWell(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: StreamBuilder(
                          stream: bloc.SearchProduct.stream,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              var item = (snapshot.data as SearchRespone);
                              return Visibility(
                                child: Text(
                                    item.hits.length == 0
                                        ? LocaleKeys.search_product_not_found
                                        .tr()
                                        : showMore
                                        ? LocaleKeys.search_product_hide
                                        .tr()
                                        : LocaleKeys.search_product_show
                                        .tr(),
                                    style: FunctionHelper.FontTheme(
                                        color: Colors.grey,
                                        fontSize:
                                        SizeUtil.titleSmallFontSize().sp)),
                                visible: item.limit == 0 ? false : true,
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                    onTap: () {
                      // setState(() {
                      //   checkSeemore ? checkSeemore = false : checkSeemore = true;
                      // });
                      if(bloc.SearchProduct.value.hits.length>0){
                        showMore = !showMore;
                        bloc.loadProductSearch(
                            page: "1", query: SearchText, limit:  showMore?6:4);
                      }

                    },
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    height: 6,
                  ),
                  StreamBuilder(
                    stream: bloc.TrendingGroup.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if((snapshot.data as ProductRespone).data.isNotEmpty){
                          return SearchHot(
                              productRespone: snapshot.data,
                              onSelectChang: () {});
                        }else{
                          return SizedBox();
                        }

                      } else {
                        return  Column(
                          children: [
                            SizedBox(height: 40,),
                            Platform.isAndroid
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator()
                          ],
                        );
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

  Widget _BuildLine() {
    return Container(
      height: 2,
      color: Colors.grey.shade100,
    );
  }

  void SearchLike(String text) {
    // listClone.clear();
    // for(int i=0;i<searchList.length;i++){
    //   if(searchList[i].contains(text)){
    //     listClone.add(searchList[i]);
    //   }
    // }
    SearchText = text;
    bloc.loadProductSearch(page: "1", query: SearchText, limit:  showMore?6:4);
  }
}
