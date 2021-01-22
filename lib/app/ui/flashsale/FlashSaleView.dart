import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/FlashSaleBar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:sizer/sizer.dart';


class FlashSale extends StatelessWidget {
  final FlashsaleRespone flashsaleRespone;

  FlashSale({Key key, this.flashsaleRespone}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 5.0.h),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0.h),
                  topLeft: Radius.circular(5.0.h)),
              border: Border.all(
                  width: 3, color: Colors.white, style: BorderStyle.solid)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.0.h),
              Center(child: _textSale(context: context)),
              flashsaleRespone.data!=null ? _flashProduct(context) : SizedBox()
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FlashSaleBar(timeFlash: flashsaleRespone.data!=null?flashsaleRespone.data[0].end:"${DateTime.now().toString()}"),
        )
      ],
    );
  }

  Widget _textSale({BuildContext context}) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 1.0.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.recommend_select_all.tr(),
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize().sp),
            ),
            SvgPicture.asset(
              'assets/images/svg/next.svg',
              height: 3.0.h,
              width: 3.0.w,
            )
          ],
        ),
      ),
      onTap: () {
        AppRoute.FlashSaleAll(context, instalData: flashsaleRespone);
      },
    );
  }

  Widget _flashProduct(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
            flashsaleRespone.data.length != 0
                ? flashsaleRespone.data[0].items.length
                : 0, (index) {
          return InkWell(
            child: Container(
              margin: EdgeInsets.all(1.0.h),
              child: Column(
                children: [
                  _ProductImage(
                      item:
                          flashsaleRespone.data[0].items[index].product,
                      index: index),
                  _intoProduct(
                      item:
                          flashsaleRespone.data[0].items[index].product,
                      index: index)
                ],
              ),
            ),
            onTap: () {
              AppRoute.ProductDetail(context,
                  productImage: "productImage_${index}",
                  productItem: ProductBloc.ConvertDataToProduct(
                      data: flashsaleRespone.data[0].items[index].product));
            },
          );
        }),
      ),
    );
  }

  Widget _ProductImage({ProductData item, int index}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1.0.h),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey.shade200)),
        child: Stack(
          children: [
            Hero(
              tag: "productImage_${index}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.5.h),
                child: CachedNetworkImage(
                  width: 30.0.w,
                  height: 30.0.w,
                  placeholder: (context, url) => Container(
                    color: Colors.white,
                    child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                  ),
                  fit: BoxFit.cover,
                  imageUrl: ProductLandscape.CovertUrlImage(item.image),
                  errorWidget: (context, url, error) => Container(
                      height: 30,
                      child: Icon(
                        Icons.error,
                        size: SizeUtil.titleSmallFontSize().sp,
                      )),
                ),
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
      ),
    );
  }

  Widget _intoProduct({ProductData item, int index}) {
    return Container(
      width: 30.0.w,
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Hero(
              tag: "productName_${index}",
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FunctionHelper.FontTheme(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeUtil.titleSmallFontSize().sp),
              )),
          SizedBox(height: 0.8.h),
          Hero(
              tag: "productPrice_${index}",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  item.offerPrice != null
                      ? Text("${item.salePrice}",
                          style: FunctionHelper.FontTheme(
                              color: Colors.grey,
                              fontSize: SizeUtil.priceFontSize().sp - 2,
                              decoration: TextDecoration.lineThrough))
                      : SizedBox(),
                  SizedBox(width: item.offerPrice != null ? 1.0.w : 0),
                  Text(
                    item.offerPrice != null
                        ? "฿${item.offerPrice}"
                        : "฿${item.salePrice}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.FontTheme(
                        color: ThemeColor.ColorSale(),
                        fontWeight: FontWeight.w500,
                        fontSize: SizeUtil.priceFontSize().sp),
                  ),
                ],
              )),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(0.8.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0.h),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 3.0.w, right: 2.0.w, bottom: 1.0.w, top: 1.0.w),
                    color: ThemeColor.ColorSale(),
                    child: Hero(
                        tag: "productStatus_${index}",
                        child: Text(
                          item.saleCount.toString() +
                              " " +
                              LocaleKeys.my_product_sold_end.tr(),
                          style: FunctionHelper.FontTheme(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeUtil.detailSmallFontSize().sp),
                        )),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/svg/flash.svg',
                width: 8.0.w,
                height: 8.0.w,
              )
            ],
          )
        ],
      ),
    );
  }

}
