import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  ProductBloc bloc;

  Future<void> _init() async {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getHomeDataCache().then((value) {
        bloc.categoryGroup.add(value.categoryGroupRespone);
      });
      // bloc.loadCategoryGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(6.5.h),
          child: AppToobar(
              showBackBtn: false,
              headerType: Header_Type.barcartShop,
              icon: 'assets/images/svg/cart_top.svg',
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
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Column(
                  children: item(
                      ((snapshot.data as CategoryGroupRespone).data.length / 4)
                          .floor(),
                      4,
                      context,
                      snapshot.data),
                ),
                Column(
                  children: item(
                      1,
                      ((snapshot.data as CategoryGroupRespone).data.length / 4)
                              .floor() *
                          4,
                      context,
                      snapshot.data),
                )
              ],
            );
          } else {
            return SizedBox();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: CachedNetworkImage(
                    width: 12.0.w,
                    height: 12.0.w,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child:
                          Lottie.asset('assets/json/loading.json', height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://dev2-test.naifarm.com/category-icon/${item.icon}.png",
                    errorWidget: (context, url, error) => Container(
                        height: 12.0.w,
                        width: 12.0.w,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.0.h),
            Container(
                height: SizeUtil.titleSmallFontSize().sp * 2.7,
                width: 16.0.w,
                child: Text(
                  item.name,
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
