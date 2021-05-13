import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';

class SearchHot extends StatelessWidget {
  final Function() onSelectChang;

  final String tagHero;
  final ProductRespone productRespone;

  SearchHot({Key key, this.onSelectChang, this.tagHero, this.productRespone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          _headerBar(),
          productRespone != null ? _buildGridView(context: context) : SizedBox()
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
                  'assets/images/png/search.png',
                  width: 5.0.w,
                  height: 5.0.w,
                ),
                SizedBox(width: 2.0.w),
                Text(LocaleKeys.recommend_search_hot.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            // GestureDetector(
            //   child: Row(
            //     children: [
            //       Text(LocaleKeys.recommend_change.tr(),
            //           style: FunctionHelper.fontTheme(
            //               color: Colors.black,
            //               fontSize: SizeUtil.titleFontSize().sp)),
            //       SizedBox(width: 2.0.w),
            //       SvgPicture.asset(
            //         'assets/images/svg/change.svg',
            //         width: 3.0.w,
            //         height: 3.0.h,
            //       ),
            //     ],
            //   ),
            //   onTap: () => onSelectChang(),
            // )
          ],
        ),
      ));

  Widget _buildGridView({BuildContext context}) {
    return Container(
      child: Column(
        children: [
          for (int i = 0; i < productRespone.data.length; i += 2)
            Container(
              child: productRespone.data.length - i > 1
                  ? Row(
                      children: [
                        productImage(
                            index: i,
                            item: productRespone.data[i],
                            context: context),
                        productImage(
                            index: i + 1,
                            item: productRespone.data[i + 1],
                            context: context)
                      ],
                    )
                  : Row(
                      children: [
                        productImage(
                            index: i,
                            item: productRespone.data[i],
                            context: context),
                      ],
                    ),
            )
        ],
      ),
    );
  }

  Widget productImage({ProductData item, int index, BuildContext context}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(right: 1.0.w),
        width: (MediaQuery.of(context).size.width / 2),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: index < 2 ? 1 : 0, color: Colors.grey.shade200),
                bottom: BorderSide(width: 1, color: Colors.grey.shade200),
                right: BorderSide(width: 1, color: Colors.grey.shade200),
                left: BorderSide(
                    width: index == 0 ? 1 : 0, color: Colors.grey.shade200))),
        child: Row(
          children: [
            Hero(
              tag: "${tagHero}_${item.id}",
              child: CachedNetworkImage(
                width: 20.0.w,
                height: 20.0.w,
                placeholder: (context, url) => Container(
                  width: 20.0.w,
                  height: 20.0.w,
                  color: Colors.white,
                  child:
                      Lottie.asset('assets/json/loading.json', height: 20.0.w),
                ),
                imageUrl: item.image.length != 0
                    ? "${Env.value.baseUrl}/storage/images/${item.image[0].path}"
                    : Env.value.noItemUrl,
                errorWidget: (context, url, error) => Container(
                    width: 20.0.w,
                    height: 20.0.w,
                    // child: Image.network(
                    //     "https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com",
                    //     fit: BoxFit.cover)),
                    child: NaifarmErrorWidget()),
              ),
            ),
            SizedBox(width: 2.0.w),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeUtil.titleSmallFontSize().sp + 1.0.h,
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: FunctionHelper.fontTheme(
                          color: Colors.black,
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    LocaleKeys.my_product_sold.tr() +
                        " " +
                        item.saleCount.toString().replaceAll("null", "0") +
                        " " +
                        LocaleKeys.cart_piece.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {},
                          starCount: 5,
                          rating: item.rating.toDouble(),
                          size: 3.0.w,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half_outlined,
                          color: Colors.amber,
                          borderColor: Colors.grey.shade300,
                          spacing: 0.0),
                      SizedBox(
                        width: 1.0.w,
                      ),
                      Text(
                        "${item.rating.toDouble()}",
                        style: FunctionHelper.fontTheme(
                            color: Colors.grey.shade400,
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        AppRoute.productDetail(context,
            productImage: "${tagHero}_${item.id}",
            productItem: ProductBloc.convertDataToProduct(data: item));
      },
    );
  }
}
