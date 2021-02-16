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
import 'package:smooth_star_rating/smooth_star_rating.dart';


class FlashSale extends StatefulWidget {
  final FlashsaleRespone flashsaleRespone;

  FlashSale({Key key, this.flashsaleRespone}) : super(key: key);

  @override
  _FlashSaleState createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
  bool OnFlashSale = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OnFlashSale = widget.flashsaleRespone.total > 0 ? true : false;
  }

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
                  topRight: Radius.circular(10.0.w),
                  topLeft: Radius.circular(10.0.w)),
              border: Border.all(
                  width: 3, color: Colors.white, style: BorderStyle.solid)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.5.h),
              Center(child: _textSale(context: context)),
              SizedBox(height: 2.5.h),
              OnFlashSale ? _flashProduct(context) : SizedBox(),
              SizedBox(height: 2.5.h),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FlashSaleBar(flashTime: widget.flashsaleRespone.data[0].end,),
        )
      ],
    );
  }

  Widget _textSale({BuildContext context}) {
    return InkWell(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.recommend_select_all.tr(),
              style: FunctionHelper.FontTheme(fontWeight: FontWeight.bold,
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
        AppRoute.FlashSaleAll(context);
      },
    );
  }

  Widget _flashProduct(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
            widget.flashsaleRespone.data.length != 0
                ? widget.flashsaleRespone.data[0].items.length
                : 0, (index) {
          return InkWell(
            child: Container(
              margin: EdgeInsets.all(1.0.h),
              child: Column(
                children: [
                  _ProductImage(
                      item:
                          widget.flashsaleRespone.data[0].items[index].product,
                      index: index),
                  _intoProduct(
                      item:
                          widget.flashsaleRespone.data[0].items[index].product,
                      index: index)
                ],
              ),
            ),
            onTap: () {
              AppRoute.ProductDetail(context,
                  productImage: "productImage_${index}",
                  productItem: ProductBloc.ConvertDataToProduct(
                      data: widget
                          .flashsaleRespone.data[0].items[index].product));
            },
          );
        }),
      ),
    );
  }

  Widget _ProductImage({ProductData item, int index}) {
    return Container(

      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade400),
          borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Stack(
        children: [
          Hero(
            tag: "productImage_${index}",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.3.h),
              child: CachedNetworkImage(
                width: 28.0.w,
                height: 28.0.w,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Lottie.asset('assets/json/loading.json',  width: 28.0.w,
                    height: 28.0.w,),
                ),
                imageUrl: ProductLandscape.CovertUrlImage(item.image),
                errorWidget: (context, url, error) => Container(
                    width: 28.0.w,
                    height: 28.0.w,
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
    );
  }

  Widget _intoProduct({ProductData item, int index}) {
    return Container(
      width: 30.0.w,
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Container(
            height: SizeUtil.titleSmallFontSize().sp*2.7,
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: FunctionHelper.FontTheme(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeUtil.titleSmallFontSize().sp),
            ),
          ),
          SizedBox(
            height: 0.8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              item.offerPrice != null
                  ? Text("${item.salePrice}",
                      style: FunctionHelper.FontTheme(
                          color: Colors.grey,
                          fontSize: SizeUtil.priceFontSize().sp,
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
          ),
          SizedBox(height: 1.0.h),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SmoothStarRating(
          //         allowHalfRating: false,
          //         onRated: (v) {},
          //         starCount: 5,
          //         rating: item.rating.toDouble(),
          //         size: 4.0.w,
          //         isReadOnly: true,
          //         filledIconData: Icons.star,
          //         halfFilledIconData: Icons.star_half_outlined,
          //         color: Colors.amber,
          //         borderColor: Colors.amber,
          //         spacing: 0.0),
          //     SizedBox(width: 1.0.w,),
          //     Text("${item.rating.toDouble()}",style: FunctionHelper.FontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
          //   ],
          // ),
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
                    child: Text("${item.saleCount!=null?item.saleCount.toString():'0'} ${LocaleKeys.my_product_sold_end.tr()}" ,
                      style: FunctionHelper.FontTheme(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtil.detailSmallFontSize().sp),
                    ),
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
