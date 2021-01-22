
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/CustomGridView.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class SearchHot extends StatelessWidget {
  final Function() onSelectChang;

  final String tagHero;
  final ProductRespone productRespone;

  SearchHot({Key key, this.onSelectChang, this.tagHero,this.productRespone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          _header_bar(),
          productRespone!=null?CustomGridView(
            tagHero: "search_",
            productRespone: productRespone,lengthRow: 2,
              onTapItem: (ProductData item,int index) { AppRoute.ProductDetail(context,
                 productImage: "search_${index}",productItem: ProductBloc.ConvertDataToProduct(data: item));}):SizedBox()
        ],
      ),
    );
  }

  Container _header_bar() => Container(
          child: Container(
        margin: EdgeInsets.all(1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/svg/search.svg',
                  width: 3.0.w,
                  height: 3.0.h,
                ),
                SizedBox(width: 2.0.w),
                Text(LocaleKeys.recommend_search_hot.tr(),
                    style: FunctionHelper.FontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
              child: Row(
                children: [
                  Text(LocaleKeys.recommend_change.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.black,
                          fontSize: SizeUtil.titleFontSize().sp)),
                  SizedBox(width: 2.0.w),
                  SvgPicture.asset(
                    'assets/images/svg/change.svg',
                    width: 3.0.w,
                    height: 3.0.h,
                  ),
                ],
              ),
              onTap: () => onSelectChang(),
            )
          ],
        ),
      ));
/*
  Widget _flashProduct({BuildContext context}){
    var _crossAxisSpacing = 100;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var cellHeight = 70;
    var _aspectRatio = _width /cellHeight;
    return Container(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _producViewModel.length,
        padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount,childAspectRatio: _aspectRatio),
        itemBuilder: (context,index){
          return InkWell(
            child: Container(
              child:_ProductImage(item: _producViewModel[index],index: index),
            ),
            onTap: ()=>onTapItem(index),
          );
        },
      ),
    );
  }
*/
}
