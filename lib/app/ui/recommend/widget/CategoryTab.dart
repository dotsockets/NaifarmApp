import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class CategoryTab extends StatelessWidget {
  final CategoryGroupRespone categoryGroupRespone;

  CategoryTab({Key key, this.categoryGroupRespone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _headerBar(),
          categoryGroupRespone != null ? _flashProduct(context) : SizedBox()
        ],
      ),
    );
  }

  Container _headerBar() => Container(
          child: Container(
        margin: EdgeInsets.all(1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/png/boxes.png',
                  width: 5.0.w,
                  height: 5.0.w,
                ),
                SizedBox(width: 2.0.w),
                Text(LocaleKeys.recommend_category_product.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            /*Row(
              children: [
                Text(LocaleKeys.recommend_change.tr(),style: FunctionHelper.fontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp)),
                SizedBox(width: 2.0.w),
                SvgPicture.asset('assets/images/svg/change.svg',width: 3.0.w,height: 3.0.h,),

              ],
                  )*/
          ],
        ),
      ));

  Widget _flashProduct(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categoryGroupRespone.data.length, (index) {
          return Container(
            margin: EdgeInsets.only(top: 0.5.h),
            child: Column(
              children: [
                productImage(context,
                    item: categoryGroupRespone.data[index], index: index)
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget productImage(BuildContext context,
      {CategoryGroupData item, int index}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(2.0.h),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 2, color: Colors.grey.shade200),
                bottom: BorderSide(width: 2, color: Colors.grey.shade200),
                right: BorderSide(width: 2, color: Colors.grey.shade200),
                left: BorderSide(
                    width: index == 0 ? 2 : 0, color: Colors.grey.shade200))),
        child: Column(
          children: [
            CachedNetworkImage(
              width: 18.0.w,
              height: 18.0.w,
              imageUrl: "${Env.value.baseUrlWeb}/category-icon/${item.icon}.png",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) =>Container(
                width: 18.0.w,
                height: 18.0.w,
                color: Colors.white,
                child: Lottie.asset(
                  'assets/json/loading.json',
                  width: 18.0.w,
                  height: 18.0.w,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                  width: 18.0.w,
                  height: 18.0.w,
                  child: Icon(
                    Icons.error,
                    size: 6.0.w,
                  )),
            ),
            SizedBox(height: 2.0.h),
            EasyLocalization.of(context).locale ==
                EasyLocalization.of(context).supportedLocales[0]?FutureBuilder(
                future: FunctionHelper.translatorText(name: item.name,from: 'th',to: 'en'),
                builder:
                    (BuildContext context, AsyncSnapshot<String> text) {

                  return Text(
                    "${text.data ?? "${item.name}"}",
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.bold),
                  );
                }):Text(
              item.name,
              style: FunctionHelper.fontTheme(
                  color: Colors.black,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.0.h),
          ],
        ),
      ),
      onTap: () {
        AppRoute.categoryDetail(context, item.id, title: item.name);
      },
    );
  }
}
