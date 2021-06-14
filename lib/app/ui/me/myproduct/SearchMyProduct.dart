import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/ui/me/myproduct/MyProductView.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/InActive.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'filter/Available.dart';
import 'filter/Banned.dart';
import 'filter/SoldOut.dart';

class SearchMyProduct extends StatefulWidget {
  final int shopID;
  final int tabNum;

  const SearchMyProduct({Key key, this.shopID, this.tabNum = 0})
      : super(key: key);

  @override
  _SearchMyProductState createState() => _SearchMyProductState();
}

class _SearchMyProductState extends State<SearchMyProduct> {
  List<String> listClone = <String>[];
  bool checkSeemore = false;
  TextEditingController txtController = TextEditingController();

  // int limit = 10;
  String searchText = "";

  //String filter = "available";
  //ProductBloc blocProduct;
  //UploadProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //bool checkPop = false;
  final _searchText = BehaviorSubject<String>();

  void _init() {
    _searchText.add("");

    /*  if (null == blocProduct) {
      blocProduct = ProductBloc(AppProvider.getApplication(context));
      blocProduct.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      blocProduct.onSuccess.stream.listen((event) {
        _searchData();
      });

      blocProduct.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(
            scaffoldKey: _scaffoldKey, message: event.error);
      });
      _searchData();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppToobar(
            icon: "",
            isEnableSearch: false,
            headerType: Header_Type.barHome,
            showCartBtn: false,
            onClick: () {
              Navigator.pop(context, true);
            },
            hint: LocaleKeys.search_product_me.tr(),
            onSearch: (String text) {
              _searchText.add(text);
            },
            onTab: () {
              buttonDialog(context, shopId: widget.shopID);
            },
          ),
          body:
              // StreamBuilder(
              // stream: blocProduct.SearchProduct.stream,
              //builder: (BuildContext context, AsyncSnapshot snapshot) {
              //  var item = (snapshot.data as SearchRespone);
              //  if (snapshot.hasData) {
              //    if (item.hits.isNotEmpty) {
              //     return
              DefaultTabController(
            initialIndex: widget.tabNum,
            length: 4,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeUtil.paddingMenu().w,
                  ),
                  SizedBox(
                    height: SizeUtil.tabBarHeight().h,
                    child: Container(
                      child: TabBar(
                        indicatorColor: ThemeColor.colorSale(),
                        isScrollable: false,
                        tabs: [
                          _tab(
                              title: LocaleKeys.shop_available.tr(),
                              message: false),
                          _tab(
                              title: LocaleKeys.shop_sold_out.tr(),
                              message: false),
                          _tab(
                              title: LocaleKeys.shop_banned.tr(),
                              message: false),
                          _tab(
                              title: LocaleKeys.shop_inactive.tr(),
                              message: false)
                        ],
                        onTap: (value) {
                          NaiFarmLocalStorage.saveNowPage(value);
                          // FocusScope.of(context).unfocus();
                          /*  switch (value) {
                                    case 0:filter = "available"; break;
                                    case 1:filter = "sold_out"; break;
                                    case 2:filter = "banned"; break;
                                    case 3:filter = "inactive"; break;
                                  }*/
                        },
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: _searchText.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: TabBarView(
                              children: [
                                Available(
                                    scaffoldKey: _scaffoldKey,
                                    shopId: widget.shopID,
                                    searchTxt: snapshot.data),
                                SoldOut(
                                    scaffoldKey: _scaffoldKey,
                                    shopId: widget.shopID,
                                    searchTxt: snapshot.data),
                                Banned(
                                    scaffoldKey: _scaffoldKey,
                                    shopId: widget.shopID,
                                    searchTxt: snapshot.data),
                                InActive(
                                    scaffoldKey: _scaffoldKey,
                                    shopId: widget.shopID,
                                    searchTxt: snapshot.data),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                ],
              ),
            ),
            //  );
            /*SingleChildScrollView(
                    child: Column(
                      children: item.hits.asMap().map((key, value) => MapEntry(key, _BuildProduct(index: key,item: CovertDataMyShop(hits: value)))).values.toList(),
                    ),
                  );*/
            //    } else {
            /*     return Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/json/boxorder.json',
                              height: 70.0.w, width: 70.0.w, repeat: false),
                          Text(
                            LocaleKeys.cart_empty.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );
                      Center(
                          child: Text(
                    LocaleKeys.search_product_not_found.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ));
                }
              } else {
                return StreamBuilder(
                    stream: blocProduct.onError.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Text(LocaleKeys.search_product_not_found.tr(),
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              }
            },*/
          ),
        ),
      ),
    );
  }

  /*ProductMyShop CovertDataMyShop({Hits hits}) {
    return ProductMyShop(
        name: hits.name,
        active: 1,
        id: hits.productId,
        brand: hits.brand,
        discountPercent: hits.discountPercent,
        hasVariant: hits.hasVariant,
        image: hits.image,
        maxPrice: hits.maxPrice,
        minPrice: hits.minPrice,
        offerPrice: hits.offerPrice,
        rating: hits.rating,
        reviewCount: hits.reviewCount,
        saleCount: hits.saleCount,
        salePrice: hits.salePrice);
  }

  Widget _BuildProductCard(SearchRespone item) {
    return SingleChildScrollView(
      child: Column(
        children: item.hits
            .asMap()
            .map((key, value) => MapEntry(key,
                _BuildProduct(index: key, item: CovertDataMyShop(hits: value))))
            .values
            .toList(),
      ),
    );
  }

  Widget _BuildProduct({ProductMyShop item, int index}) {
    return InkWell(
      onTap: () {
        AppRoute.ProductDetailShop(context,
            productImage: "myproduct_search_${index}", productItem: item);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1),
                        margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Hero(
                          tag: "myproduct_search_${index}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.h),
                            child: CachedNetworkImage(
                              width: 30.0.w,
                              height: 35.0.w,
                              placeholder: (context, url) => Container(
                                width: 30.0.w,
                                height: 35.0.w,
                                color: Colors.white,
                                child: Lottie.asset(
                                  'assets/json/loading.json',
                                  width: 30.0.w,
                                  height: 35.0.w,
                                ),
                              ),
                              imageUrl: item.image != null
                                  ? "${Env.value.baseUrl}/storage/images/${item.image.isNotEmpty ? item.image[0].path : ''}"
                                  : '',
                              errorWidget: (context, url, error) => Container(
                                  width: 30.0.w,
                                  height: 35.0.w,
                                  child: Image.network(Env.value.noItemUrl,
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        child: Container(
                          margin: EdgeInsets.only(left: 2.5.w, top: 4.5.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.w),
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 1.5.w,
                                  left: 1.5.w,
                                  top: 1.0.w,
                                  bottom: 1.0.w),
                              color: ThemeColor.colorSale(),
                              child: Text(
                                "${item.discountPercent}%",
                                style: FunctionHelper.fontTheme(
                                    color: Colors.white,
                                    fontSize: SizeUtil.titleSmallFontSize().sp),
                              ),
                            ),
                          ),
                        ),
                        visible: item.discountPercent > 0 ? true : false,
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            item.offerPrice != null
                                ? "฿${item.offerPrice}"
                                : "฿${item.salePrice}",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.priceFontSize().sp,
                                color: ThemeColor.colorSale(),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      LocaleKeys.my_product_amount.tr() +
                                          " ${item.stockQuantity != null ? item.stockQuantity : 0}",
                                      style: FunctionHelper.fontTheme(
                                          fontSize:
                                              SizeUtil.detailFontSize().sp)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "${LocaleKeys.my_product_sold.tr() + " " + item.hasVariant.toString() + " " + LocaleKeys.cart_item.tr()}",
                                      style: FunctionHelper.fontTheme(
                                          fontSize:
                                              SizeUtil.detailFontSize().sp),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        LocaleKeys.my_product_like.tr() + " 10",
                                        style: FunctionHelper.fontTheme(
                                            fontSize:
                                                SizeUtil.detailFontSize().sp)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            LocaleKeys.my_product_visit.tr() +
                                                " 10",
                                            style: FunctionHelper.fontTheme(
                                                fontSize:
                                                    SizeUtil.detailFontSize()
                                                        .sp),
                                          )))
                                ]),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.active == 1
                              ? LocaleKeys.my_product_sell.tr()
                              : LocaleKeys.my_product_break.tr(),
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        height: 50,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        flex: 1,
                        child: FlutterSwitch(
                          height: 9.0.w,
                          toggleSize: 7.0.w,
                          activeColor: Colors.grey.shade200,
                          inactiveColor: Colors.grey.shade200,
                          toggleColor: item.active == 1
                              ? ThemeColor.primaryColor()
                              : Colors.grey.shade400,
                          value: item.active == 1 ? true : false,
                          onToggle: (val) {},
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            child: SvgPicture.asset(
                              'assets/images/svg/Edit.svg',
                              width: 6.0.w,
                              height: 6.0.w,
                              color: ThemeColor.colorSale(),
                            ),
                          ),
                          onTap: () async {
                            var product = ProductMyShopRequest(
                                name: item.name,
                                salePrice: item.salePrice,
                                stockQuantity: item.stockQuantity,
                                offerPrice: item.offerPrice,
                                active: item.active);
                            var onSelectItem = List<OnSelectItem>();
                            for (var value in item.image) {
                              onSelectItem.add(
                                  OnSelectItem(onEdit: false, url: value.path));
                            }
                            var result = await AppRoute.EditProduct(
                                context, item.id, widget.shopID,
                                uploadProductStorage: UploadProductStorage(
                                    productMyShopRequest: product,
                                    onSelectItem: onSelectItem));

                            /*if(result){
                             // Navigator.pop(context,true);
                              _reloadData();
                            }*/
                            /*if(result!=null){
                              Navigator.of(context).pop();
                            }*/
                          },
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: InkWell(
                          child: SvgPicture.asset(
                            'assets/images/svg/trash.svg',
                            width: 6.0.w,
                            height: 6.0.w,
                            color: ThemeColor.colorSale(),
                          ),
                          onTap: () {
                            FunctionHelper.ConfirmDialog(context,
                                message: LocaleKeys.dialog_message_del_product
                                    .tr(), onClick: () {
                              // bloc.ProductMyShop.value.data.removeAt(index);
                              // bloc.ProductMyShop.add(bloc.ProductMyShop.value);
                              Usermanager().getUser().then((value) =>
                                  blocProduct.DELETEProductMyShop(
                                      ProductId: item.id, token: value.token));
                              Navigator.of(context).pop();
                            }, onCancel: () {
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
*/
  Widget _tab({String title, bool message}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: FunctionHelper.fontTheme(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: Colors.black)),
          message
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 10,
                    height: 20,
                    color: ThemeColor.colorSale(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

/*_searchData() {
    Usermanager().getUser().then((value) => blocProduct.loadSearchMyshop(
        shopId: widget.shopID,
        page: "1",
        query: searchText,
        limit: limit,
        filter: filter,
        token: value.token));
  }*/
}
