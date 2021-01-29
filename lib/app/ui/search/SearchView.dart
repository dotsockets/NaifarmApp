import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
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
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppToobar(
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: bloc.SearchProduct.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            color: Colors.white,
                            child: ListView.builder(
                                shrinkWrap: true,
                                // itemCount: !checkSeemore&&listClone.length!=0&&listClone.length>3?3:listClone.length,
                                itemCount:
                                    (snapshot.data as SearchRespone).hits.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                             Expanded(child:  Text(
                                                 (snapshot.data as SearchRespone)
                                                     .hits[index]
                                                     .name,
                                                 style: FunctionHelper.FontTheme(
                                                     color: Colors.black,
                                                     fontSize: SizeUtil
                                                         .titleSmallFontSize()
                                                         .sp)),),
                                              CachedNetworkImage(
                                                width: 10.0.w,
                                                height: 10.0.w,
                                                placeholder: (context, url) => Container(
                                                  width: 10.0.w,
                                                  height: 10.0.w,
                                                  color: Colors.white,
                                                  child: Lottie.asset(Env.value.loadingAnimaion,   width: 10.0.w,
                                  height: 10.0.w),
                                                ),
                                                fit: BoxFit.cover,
                                                imageUrl: "${Env.value.baseUrl}/storage/images/${(snapshot.data as SearchRespone).hits[index].image.length!=0?(snapshot.data as SearchRespone).hits[index].image[0].path:""}",
                                                errorWidget: (context, url, error) => Container(
                                                    width: 10.0.w,
                                                    height: 10.0.w,
                                                    child: Image.network("https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com",fit: BoxFit.cover)),
                                              )
                                            ],
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                        onTap: () {
                                          var item = (snapshot.data as SearchRespone).hits[index];
                                          AppRoute.ProductDetail(context,
                                              productImage: "",
                                              productItem: ProducItemRespone(
                                                  id: item.productId,
                                                  shopId: item.shopId,
                                                  shop: ShopItem(id: item.shopId),
                                                  name: item.inventories[0].title,
                                                  salePrice: item.inventories[0].salePrice,offerPrice: item.inventories[0].offerPrice,saleCount: item.saleCount,
                                              image: item.image));
                                        },
                                      ),
                                      _BuildLine()
                                    ],
                                  );
                                }),
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
              ],
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
