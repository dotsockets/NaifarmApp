import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:rxdart/subjects.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ProductMoreView extends StatefulWidget {
  final String barTxt;

  final List<ProductModel> productList;
  final ProductRespone installData;
  final String api_link;
  final int type_more;

  ProductMoreView(
      {Key key,
      this.barTxt,
      this.productList,
      this.installData,
      this.api_link,
      this.type_more})
      : super(key: key);

  @override
  _ProductMoreViewState createState() => _ProductMoreViewState();
}

class _ProductMoreViewState extends State<ProductMoreView> {
  ProductBloc bloc;
  int page = 1;
  int limit = 10;
  ScrollController _scrollController = ScrollController();
  bool step_page = false;

  final position_scroll = BehaviorSubject<bool>();

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));

      if (widget.installData != null) {
        bloc.MoreProduct.add(widget.installData);
      }
      NaiFarmLocalStorage.getProductMoreCache().then((value){

         if(value!=null){
           for(var data in value.productRespone){
               if(data.slag == widget.api_link){
                 bloc.MoreProduct.add(data.searchRespone);
                 break;
               }
           }
           bloc.loadMoreData(context,
               page: page.toString(),
               limit: 10,
               link: widget.api_link,
               type_more: widget.type_more);

         }else{
           bloc.loadMoreData(context,
               page: page.toString(),
               limit: 10,
               link: widget.api_link,
               type_more: widget.type_more);
         }
      });

    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (step_page) {
          step_page = false;
          page++;
          bloc.loadMoreData(context,
              page: page.toString(),
              limit: limit,
              link: widget.api_link,
              type_more: widget.type_more);
        }
      }

      if (_scrollController.position.pixels > 500) {
        position_scroll.add(true);
      } else {
        position_scroll.add(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: widget.barTxt,
              header_type: Header_Type.barcartShop,
              icon: 'assets/images/svg/search.svg',
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: StreamBuilder(
                  stream: bloc.MoreProduct.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    step_page = true;
                    if (snapshot.hasData) {
                      var item = (snapshot.data as ProductRespone);
                      if (item.data.length > 0) {
                        step_page = true;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            // if ( i+1==((item.data.length) / 2).round()) {
                            //   return CupertinoActivityIndicator();
                            // }

                            return Container(
                              child: Column(
                                children: [
                                  item.data.length - (i) * 2 > 1
                                      ? Row(
                                          children: [
                                            Expanded(
                                                child: _buildProduct(
                                                    item: item.data[(i * 2)],
                                                    index: (i * 2),
                                                    context: context)),
                                            Expanded(
                                                child: _buildProduct(
                                                    item:
                                                        item.data[(i * 2) + 1],
                                                    index: ((i * 2) + 1),
                                                    context: context))
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                                child: _buildProduct(
                                                    item: item.data[(i * 2)],
                                                    index: (i * 2),
                                                    context: context)),
                                            Expanded(child: SizedBox()),
                                          ],
                                        ),
                                  if (item.data.length != item.total &&
                                      item.data.length >= limit)
                                    i + 1 == ((item.data.length) / 2).round()
                                        ? Container(
                                            padding: EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Platform.isAndroid
                                                    ? SizedBox(
                                                        width: 5.0.w,
                                                        height: 5.0.w,
                                                        child:
                                                            CircularProgressIndicator())
                                                    : CupertinoActivityIndicator(),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(LocaleKeys.dialog_message_loading.tr(),
                                                    style: FunctionHelper.FontTheme(
                                                        color: Colors.grey,
                                                        fontSize: SizeUtil
                                                                .priceFontSize()
                                                            .sp))
                                              ],
                                            ),
                                          )
                                        : SizedBox()
                                ],
                              ),
                            );
                          },
                          itemCount: ((item.data.length) / 2).round(),
                        );
                      } else {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 15.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/json/boxorder.json',
                                    height: 70.0.w,
                                    width: 70.0.w,
                                    repeat: false),
                                Text(
                                  LocaleKeys.search_product_not_found.tr(),
                                  style: FunctionHelper.FontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 40.0.h),
                        child: Center(
                          child: Platform.isAndroid
                              ? CircularProgressIndicator()
                              : CupertinoActivityIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
              StreamBuilder(
                  stream: position_scroll.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data
                          ? Container(
                              margin:
                                  EdgeInsets.only(right: 5.0.w, bottom: 5.0.w),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 13.0.w,
                                    height: 13.0.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black.withOpacity(0.4)),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_up_outlined,
                                        size: 8.0.w,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.minScrollExtent,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve: Curves.ease);
                                      },
                                    ),
                                  )),
                            )
                          : SizedBox();
                    } else {
                      return SizedBox();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _intoProduct({ProductData item, int index}) {
    return Column(
      children: [
        SizedBox(height: 0.5.h),
        Container(
          height: SizeUtil.productNameHeight(SizeUtil.titleSmallFontSize().sp),
          child: Text(item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: FunctionHelper.FontTheme(
                  color: Colors.black,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            item.offerPrice != null
                ? Text("฿${NumberFormat("#,##0", "en_US").format(item.salePrice)}",
                style: FunctionHelper.FontTheme(
                    color: Colors.grey,
                    fontSize: SizeUtil.priceFontSize().sp - 1,
                    decoration: TextDecoration.lineThrough))
                : SizedBox(),
            SizedBox(width: item.offerPrice != null ? 1.0.w : 0),
            Text(
              item.offerPrice != null
                  ? "฿${NumberFormat("#,##0", "en_US").format(item.offerPrice)}"
                  : "฿${NumberFormat("#,##0", "en_US").format(item.salePrice)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.FontTheme(
                  color: ThemeColor.ColorSale(),
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.priceFontSize().sp),
            ),
          ],
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 6),
              child: SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {},
                  starCount: 5,
                  rating: item.rating != null && item.rating != 0
                      ? item.rating.toDouble()
                      : 0.0,
                  size: 4.0.w,
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.orange,
                  borderColor: Colors.grey.shade300,
                  spacing: 0.0),
            ),
            Text(
                "${LocaleKeys.my_product_sold.tr()} ${item.saleCount != null ? item.saleCount.toString() : '0'} ${LocaleKeys.cart_piece.tr()}",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.detailSmallFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500))
          ],
        )
      ],
    );
  }

  Widget _buildProduct({ProductData item, int index, BuildContext context}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Hero(
                    tag: "loadmore_${item.id}${index}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1.0.h),
                      child: CachedNetworkImage(
                        width: 30.0.w,
                        height: 40.0.w,
                        placeholder: (context, url) => Container(
                          width: 30.0.w,
                          height: 40.0.w,
                          color: Colors.white,
                          child: Lottie.asset(
                            'assets/json/loading.json',
                            width: 30.0.w,
                            height: 40.0.w,
                          ),
                        ),
                        imageUrl: ProductLandscape.CovertUrlImage(item.image),
                        errorWidget: (context, url, error) => Container(
                            width: 30.0.w,
                            height: 40.0.w,
                            child: Image.network(Env.value.noItemUrl,
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.all(1.5.w),
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
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _intoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: () {
        // widget.onTapItem(item,item.id)
        AppRoute.ProductDetail(context,
            productImage: "loadmore_${item.id}${index}",
            productItem: ProductBloc.ConvertDataToProduct(data: item));
      },
    );
  }

  int Check(int i) => i != bloc.product_more.length - 1 ? 2 : 1;
}
