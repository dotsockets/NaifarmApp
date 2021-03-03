import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class Banned extends StatefulWidget {
  final int shopId;
  final GlobalKey<ScaffoldState>  scaffoldKey;
  final String searchTxt;

  const Banned({Key key, this.shopId, this.scaffoldKey,this.searchTxt=""}) : super(key: key);

  @override
  _BannedState createState() => _BannedState();
}

class _BannedState extends State<Banned> {
  ScrollController _scrollController = ScrollController();
  ProductBloc bloc;
  int page = 1;
  int count = 0;
  bool step_page = false;
  final _searchText = BehaviorSubject<String>();
  int total = 0;

  init() {
    count=0;
    _searchText.add(widget.searchTxt);

    _searchText.stream.listen((event) {
      NaiFarmLocalStorage.getNowPage().then((value) {

        if (value == 2 && count==0) {
          widget.searchTxt.length!=0?_reloadFirstSearch():_reloadFirstPage();

          count++;
        }
      });
    });


    if (bloc == null) {
      bloc = ProductBloc(AppProvider.getApplication(context));

      bloc.onSuccess.stream.listen((event) {
        widget.searchTxt.length!=0?_reloadFirstSearch():_reloadFirstPage();

        if (event is bool) {
          // bloc.ProductMyShopRes.add(bloc.ProductMyShopRes.value);
        }
      });

      bloc.onError.stream.listen((event) {
        /*   Future.delayed(const Duration(milliseconds: 1000), () {
          page=1;
          _reloadData();
        });*/
        FunctionHelper.SnackBarShow(scaffoldKey: widget.scaffoldKey, message: event.error.message);
        widget.searchTxt.length!=0?_reloadFirstSearch():_reloadFirstPage();

      });
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      widget.searchTxt.length != 0
          ? _reloadFirstSearch()
          : _reloadFirstPage();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
          _scrollController.position.pixels <=
          200) {
        if (step_page&&bloc.productList.length<total) {
          step_page = false;
          page++;
          widget.searchTxt.length!=0?_searchData():_reloadData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return StreamBuilder(
      stream: bloc.ProductMyShopRes.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            (snapshot.data as ProductMyShopListRespone).data.length > 0) {
          step_page = true;

          var item = (snapshot.data as ProductMyShopListRespone);
          total = item.total;
          return Container(
            color: Colors.grey.shade300,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: 0.8.h,),
                  Column(
                    children: List.generate(
                      item.data.length,
                          (index) =>
                          _BuildProduct(item: item.data[index], index: index),
                    ),
                  ),
                  if (item.data.length != item.total)
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Platform.isAndroid
                              ? SizedBox(
                              width: 5.0.w,
                              height: 5.0.w,
                              child: CircularProgressIndicator())
                              : CupertinoActivityIndicator(),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Loading",
                              style: FunctionHelper.FontTheme(
                                  color: Colors.grey,
                                  fontSize: SizeUtil.priceFontSize().sp))
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Skeleton.LoaderListTite(context)],
              ),
            ),
          );
        } else {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(bottom: 15.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/json/boxorder.json',
                        height: 70.0.w, width: 70.0.w, repeat: false),
                    Text(
                      LocaleKeys.search_product_not_found.tr(),
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _BuildProduct({ProductMyShop item, int index}) {
    return InkWell(
      onTap: () {
        AppRoute.ProductDetailShop(context,
            productImage: "myproduct_${index}_1", productItem: item);
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
                          tag: "myproduct_${index}_1",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.h),
                            child: CachedNetworkImage(
                              width: 30.0.w,
                              height: 30.0.w,
                              placeholder: (context, url) => Container(
                                width: 30.0.w,
                                height: 30.0.w,
                                color: Colors.white,
                                child: Lottie.asset(
                                  'assets/json/loading.json',
                                  width: 30.0.w,
                                  height: 30.0.w,
                                ),
                              ),
                              imageUrl: item.image.isNotEmpty
                                  ? "${Env.value.baseUrl}/storage/images/${item.image[0].path}"
                                  : '',
                              errorWidget: (context, url, error) => Container(
                                  width: 30.0.w,
                                  height: 30.0.w,
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
                              color: ThemeColor.ColorSale(),
                              child: Text(
                                "${item.discountPercent}%",
                                style: FunctionHelper.FontTheme(
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
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              item.offerPrice!=null?Text("${item.salePrice}",style: FunctionHelper.FontTheme(
                                  color: Colors.grey,
                                  fontSize: SizeUtil.priceFontSize().sp-2, decoration: TextDecoration.lineThrough)):SizedBox(),
                              SizedBox(width: item.offerPrice!=null?1.0.w:0),
                              Text(item.offerPrice!=null?"฿${item.offerPrice}":"฿${item.salePrice}",maxLines: 1,
                                overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(item.stockQuantity!=null?
                                  LocaleKeys.my_product_amount.tr() +
                                      " ${item.stockQuantity}":LocaleKeys.my_product_amount.tr() +" 0",
                                      style: FunctionHelper.FontTheme(
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
                                      "${LocaleKeys.my_product_sold.tr()} ${item.saleCount!=null?item.saleCount.toString():"0"} ${LocaleKeys.cart_piece.tr()}",
                                      style: FunctionHelper.FontTheme(
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
                                        LocaleKeys.my_product_like.tr() + " ${item.likeCount!=null?item.likeCount.toString():"0"}",
                                        style: FunctionHelper.FontTheme(
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
                                            "ตัวเลือกสินค้า" +
                                                " ไม่มี",
                                            style: FunctionHelper.FontTheme(
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
                          style: FunctionHelper.FontTheme(
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
                          onToggle: (val) {
                            FocusScope.of(context).unfocus();
                            bloc.ProductMyShopRes.value.data[index].active = val ? 1 : 0;
                            bloc.ProductMyShopRes.add(bloc.ProductMyShopRes.value);

                            Usermanager().getUser().then((value) =>
                                bloc.UpdateProductMyShop(
                                    isActive: IsActive.ReplacemenView,
                                    shopRequest: ProductMyShopRequest(name: item.name, active: val ? 1:0),
                                    token: value.token,
                                    productId: item.id));
                          },
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
                              color: ThemeColor.ColorSale(),
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
                              onSelectItem.add(OnSelectItem(onEdit: false, url: value.path));
                            }
                            var result = await AppRoute.EditProduct(context, item.id, widget.shopId,
                                uploadProductStorage: UploadProductStorage(
                                    productMyShopRequest: product,
                                    onSelectItem: onSelectItem),
                                indexTab: 0);
                            if (result!=null && result) {
                              _reloadFirstPage();
                            }
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
                            color: ThemeColor.ColorSale(),
                          ),
                          onTap: () {
                            FunctionHelper.ConfirmDialog(context,
                                message: LocaleKeys.dialog_message_del_product
                                    .tr(), onClick: () {
                                  bloc.ProductMyShopRes.value.data.removeAt(index);
                                  bloc.ProductMyShopRes.add(
                                      bloc.ProductMyShopRes.value);
                                  //count++;
                                  Usermanager().getUser().then((value) =>
                                      bloc.DELETEProductMyShop(
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

  Widget ButtonDialog(BuildContext context,
      {Function() onClick, List<String> message}) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: InkWell(
            onTap: () {
              onClick();
            },
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        message.length,
                            (index) => Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            message[index],
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        )))),
          ),
        );
      },
    );
  }

  _reloadData() {
    Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: page.toString(),limit: 5,token: value.token,filter:"banned"));

  }

  _reloadFirstPage(){
    bloc.productList.clear();
    page = 1;
    _reloadData();
  }

  _searchData() {
    Usermanager().getUser().then((value) => bloc.loadSearchMyshop(
        shopId: widget.shopId,
        page: page.toString(),
        query: widget.searchTxt,
        limit: 5,
        filter: "banned",
        token: value.token));
  }

  _reloadFirstSearch(){
    page = 1;
    _searchData();
  }

/* @override
  bool get wantKeepAlive => true;*/
}
