import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/HomeDataBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  ProductBloc bloc;


  Future<void> _init(BuildContext context) async {
    if (bloc == null) {
      bloc = ProductBloc(AppProvider.of(context).application);
      bloc.loadCategoryGroup(context);


      FunctionHelper.translatorText(name: "หมา",from: 'th',to: 'en').then((value){
        print("wsefcer  ${value}");
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(7.0.h),
          child: AppToobar(
              showBackBtn: false,
              headerType: Header_Type.barcartShop,
              icon: 'assets/images/png/cart_top.png',
              title: LocaleKeys.recommend_category_product.tr())),
      body: SingleChildScrollView(
        child:
            Container(color: Colors.white, child: _content(context: context)),
      ),
    );
  }

  Widget _content({BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(2.0.h),
      child: StreamBuilder(
        stream: bloc.categoryGroup.stream,
        builder: (BuildContext context,
            AsyncSnapshot<CategoryGroupRespone> snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 30.0.h),
              child: Center(
                child: Platform.isAndroid
                    ? SizedBox(
                        width: 5.0.w,
                        height: 5.0.w,
                        child: CircularProgressIndicator())
                    : CupertinoActivityIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 30.0.h),
              child: Center(
                child: Platform.isAndroid
                    ? SizedBox(
                        width: 5.0.w,
                        height: 5.0.w,
                        child: CircularProgressIndicator())
                    : CupertinoActivityIndicator(),
              ),
            );
          } else {
            return Column(
              children: [
                Column(
                  children: item((snapshot.data.data.length / 4).floor(), 4,
                      context, snapshot.data),
                ),
                Column(
                  children: item(1, (snapshot.data.data.length / 4).floor() * 4,
                      context, snapshot.data),
                )
              ],
            );
          }
        },
      ),
    );
  }

  List<Widget> item(
      int con, int count, BuildContext context, CategoryGroupRespone item) {
    var data = <Widget>[];
    var j = 0;
    int n = ((item.data.length / 4).floor() * 4) + 4 - item.data.length;
    for (int i = 0; i < (con); i++) {
      j += 4;
      data.add(Container(
        margin: EdgeInsets.only(bottom: 2.0.h),
        child: con != 1
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                for (int i = count; i >= 1; i--)
                  _productImage(
                      item: item.data[j - i], index: j - 1, context: context)
              ])
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                for (int i = count; i < item.data.length; i++)
                  _productImage(item: item.data[i], index: i, context: context),
                if (item.data.length % 4 != 0)
                  for (int i = 0; i < n; i++)
                    SizedBox(
                      width: 17.0.w,
                      height: 17.0.w,
                    )
              ]),
      ));
    }
    return data;
  }

  Widget _productImage(
      {CategoryGroupData item, int index, BuildContext context}) {
    return InkWell(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.all(Radius.circular(3.0.w))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(0.7.w),
                  child: CachedNetworkImage(
                    width: SizeUtil.categoryTabSize().w,
                    height: SizeUtil.categoryTabSize().w,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: Lottie.asset('assets/json/loading.json',
                          height: SizeUtil.categoryTabSize().w,
                          width: SizeUtil.categoryTabSize().w),
                    ),
                    fit: BoxFit.cover,
                    imageUrl:
                        "${Env.value.baseUrlWeb}/category-icon/${item.icon}.png",
                    errorWidget: (context, url, error) => Container(
                        height: SizeUtil.categoryTabSize().w,
                        width: SizeUtil.categoryTabSize().w,
                        child: Icon(
                          Icons.error,
                          size: 6.0.w,
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.0.h),
            Container(
                height: SizeUtil.titleSmallFontSize().sp * 0.4.h,
                width: 16.0.w,
                child: EasyLocalization.of(context).locale ==
                        EasyLocalization.of(context).supportedLocales[0]
                    ? FutureBuilder(
                        future: FunctionHelper.translatorText(name: item.name,from: 'th',to: 'en'),
                        builder:
                            (BuildContext context, AsyncSnapshot<String> text) {

                          return Text(
                            "${text.data ?? "${item.name}"}",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: FunctionHelper.fontTheme(
                                color: Colors.black,
                                fontSize: SizeUtil.titleSmallFontSize().sp,
                                fontWeight: FontWeight.bold),
                          );
                        })
                    : Text(
                        "${item.name}",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: FunctionHelper.fontTheme(
                            color: Colors.black,
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.bold),
                      ))
          ],
        ),
      ),
      onTap: () {
        //  for (int i=0;i<item.length;i++){
        //     if(_menuViewModel[i].type==item.type){
        //       AppRoute.CategoryDetail(context,i);
        //       break;
        //     }
        //
        //  }

        AppRoute.categoryDetail(context, item.id,
            title: LocaleKeys.recommend_category_product.tr());
      },
    );
  }


}

