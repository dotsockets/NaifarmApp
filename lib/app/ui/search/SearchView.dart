import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/ui/recommend/widget/SearchHot.dart';
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
  int limit = 3;
  String SearchText = "";
  ProductBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.loadProductTrending("1");
      bloc.loadProductSearch(page: "1", query: SearchText, limit: limit);
    }
  }



  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
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
                                        padding: EdgeInsets.only(
                                            left: 10, top: 10, bottom: 10),
                                        child: Text(
                                            (snapshot.data as SearchRespone)
                                                .hits[index]
                                                .name,
                                            style: FunctionHelper.FontTheme(
                                                color: Colors.black,
                                                fontSize: SizeUtil
                                                        .titleSmallFontSize()
                                                    .sp)),
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
                      padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h),
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
                                    item.limit == 0
                                        ? LocaleKeys.search_product_not_found
                                            .tr()
                                        : limit == 6
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
                      limit = limit == 6 ? 3 : 6;
                      bloc.loadProductSearch(
                          page: "1", query: SearchText, limit: limit);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                    stream: bloc.TrendingGroup.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return SearchHot(
                            productRespone: snapshot.data,
                            onSelectChang: () {});
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildLine() {
    return Container(
      height: 2,
      color: Colors.grey.shade50,
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
    bloc.loadProductSearch(page: "1", query: SearchText, limit: limit);
  }
}
