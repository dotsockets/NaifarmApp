import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";


class ProductItemCard extends StatelessWidget {
  final String tagHero;
  final ProductData item;
  final int subFixId;
  final bool showSoldFlash;
  final Function onClick;

  ProductItemCard(
      {Key key,
      this.tagHero,
      this.subFixId = 1,
      this.item,
      this.showSoldFlash = false,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(tagHero != "flash" ? 0 : 1.0.w),
      child: Column(
        children: [productImage(context), _intoProduct(context)],
      ),
    );
  }

  Widget productImage(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.1.w),
        borderRadius: BorderRadius.all(Radius.circular(2.0.w)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(1.3.h),
            child: CachedNetworkImage(
              width: tagHero != "flash"
                  ? 30.0.w
                  : (MediaQuery.of(context).size.width / 2) - 4.0.w,
              height: tagHero != "flash" ? 30.0.w : 40.0.w,
              imageUrl: covertUrlImage(item.image),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Container(
                width: tagHero != "flash"
                    ? 30.0.w
                    : (MediaQuery.of(context).size.width / 2) - 4.0.w,
                height: tagHero != "flash" ? 30.0.w : 40.0.w,
                color: Colors.white,
                child: Lottie.asset(
                  'assets/json/loading.json',
                  width: 18.0.w,
                  height: 18.0.w,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                  width: tagHero != "flash"
                      ? 30.0.w
                      : (MediaQuery.of(context).size.width / 2) - 4.0.w,
                  height: tagHero != "flash" ? 30.0.w : 40.0.w,
                  child: Image.network(
                      Env.value.noItemUrl,
                      fit: BoxFit
                          .cover)),
            ),
          ),
          Visibility(
            child: Container(
              margin: EdgeInsets.all(1.5.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.0.w),
                child: Container(
                  padding: EdgeInsets.only(
                      right: 1.5.w, left: 1.5.w, top: 1.0.w, bottom: 1.0.w),
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
          ),
          item.stockQuantity != null
              ? item.stockQuantity == 0
                  ? Positioned.fill(
                      child: IgnorePointer(
                        ignoring: true,
                        child: Container(
                          color: Colors.white.withOpacity(0.7),
                          child: Center(
                            child: Container(
                              width: 20.0.w,
                              height: 4.0.h,
                              padding: EdgeInsets.all(2.0.w),
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(10.0.w))),
                              child: Center(
                                child: Text(
                                    LocaleKeys.search_product_out_of_stock.tr(),
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.detailFontSize().sp,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
              : SizedBox()
        ],
      ),
    );
  }

  static String covertUrlImage(List<ProductImage> image) {
    if (image.length != 0) {
      // Random random = new Random();
      // int randomNumber = random.nextInt(image.length); // from
      return "${Env.value.baseUrl}/storage/images/${image[0].path}";
    } else {
      return "";
    }
  }

  Widget _intoProduct(BuildContext context) {
    return Container(
      width: tagHero != "flash"
          ? 30.0.w
          : (MediaQuery.of(context).size.width / 2) - 4.0.w,
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Container(
            height: SizeUtil.productNameHeight(SizeUtil.titleFontSize().sp),
            child: Text(
              " " + item.name + " ",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: FunctionHelper.fontTheme(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.titleFontSize().sp),
            ),
          ),
          SizedBox(
            height: 0.8.h,
          ),
          salePrice(item: item),
          SizedBox(height: 1.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {},
                  starCount: 5,
                  rating: item.rating != null ? item.rating.toDouble() : 0.0,
                  size: SizeUtil.ratingSize().w,
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half_outlined,
                  color: Colors.amber,
                  borderColor: Colors.grey.shade300,
                  spacing: 0.0),
              SizedBox(
                width: 1.0.w,
              ),
              //  Text("${item.rating.toDouble()}",style: FunctionHelper.fontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
            ],
          ),
          showSoldFlash
              ? Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0.8.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0.h),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 2.0.w,
                              bottom: 1.0.w,
                              top: 1.0.w),
                          color: ThemeColor.colorSale(),
                          child: Text(
                            "${item.saleCount != null ? item.saleCount.toString() : '0'} ${LocaleKeys.my_product_sold_end.tr()}",
                            style: FunctionHelper.fontTheme(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: SizeUtil.detailFontSize().sp),
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/png/flash.png',
                      height: 8.0.w,
                    ),
                  ],
                )
              : Container(
                  padding: EdgeInsets.all(0.8.h),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 7, bottom: 3, top: 3),
                    child: Text(
                      LocaleKeys.my_product_sold.tr() +
                          " " +
                          item.saleCount.toString().replaceAll("null", "0") +
                          " " +
                          LocaleKeys.cart_piece.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeUtil.detailFontSize().sp),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Row salePrice({ProductData item}) {
    if (item.salePrice != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          item.offerPrice != null
              ? Text(
                  "฿${item.salePrice.priceFormat()}",
                  style: FunctionHelper.fontTheme(
                      color: Colors.grey,
                      fontSize: SizeUtil.priceFontSize().sp - 2,
                      decoration: TextDecoration.lineThrough))
              : SizedBox(),
          SizedBox(width: item.offerPrice != null ? 1.0.w : 0),
          Text(
            item.offerPrice != null
                ? "฿${item.offerPrice.priceFormat()}"
                : "฿${item.salePrice.priceFormat()}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FunctionHelper.fontTheme(
                color: ThemeColor.colorSale(),
                fontWeight: FontWeight.w500,
                fontSize: SizeUtil.priceFontSize().sp),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            item.minPrice != null
                ? "฿${item.minPrice.priceFormat()}"
                : "฿0",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FunctionHelper.fontTheme(
                color: ThemeColor.colorSale(),
                fontWeight: FontWeight.w500,
                fontSize: SizeUtil.priceFontSize().sp),
          ),
          Text(
            " - ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FunctionHelper.fontTheme(
                color: ThemeColor.colorSale(),
                fontWeight: FontWeight.w500,
                fontSize: SizeUtil.priceFontSize().sp),
          ),
          Text(
            item.maxPrice != null
                ? "฿${NumberFormat("#,##0", "en_US").format(item.maxPrice)}"
                : "฿0",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FunctionHelper.fontTheme(
                color: ThemeColor.colorSale(),
                fontWeight: FontWeight.w500,
                fontSize: SizeUtil.priceFontSize().sp),
          ),
        ],
      );
    }
  }
}
