import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/utility/widgets/ProductItemCard.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/FlashSaleBar.dart';
import 'package:sizer/sizer.dart';

class FlashSale extends StatefulWidget {
  final FlashsaleRespone flashsaleRespone;

  FlashSale({Key key, this.flashsaleRespone}) : super(key: key);

  @override
  _FlashSaleState createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
  bool onFlashSale = false;

  @override
  void initState() {
    onFlashSale = widget.flashsaleRespone.total > 0 ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 3.0.h),
          decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //     topRight: Radius.circular(SizeUtil.paddingBorderHome().w),
              //     topLeft: Radius.circular(SizeUtil.paddingBorderHome().w)),
              border: Border.all(
                  width: 3, color: Colors.white, style: BorderStyle.solid)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeUtil.sizedBoxHeight().h),
             // Center(child: _textSale(context: context)),
              SizedBox(height: SizeUtil.paddingBox().h),
              onFlashSale ? _flashProduct(context) : SizedBox(),
              SizedBox(height: SizeUtil.paddingBox().h),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FlashSaleBar(),
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
              style: FunctionHelper.fontTheme(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.titleFontSize().sp + 3.0),
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
        AppRoute.flashSaleAll(context,
            flashsaleRespone: widget.flashsaleRespone);
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
                  ProductItemCard(
                    item: widget.flashsaleRespone.data[0].items[index].product,
                    tagHero: "productImage_$index",
                    showSoldFlash: true,
                  )
                  //   //_ProductImage(
                  //   //    item:
                  //           widget.flashsaleRespone.data[0].items[index].product,
                  //       index: index),
                  //   _intoProduct(
                  //       item:
                  //           widget.flashsaleRespone.data[0].items[index].product,
                  //       index: index)
                ],
              ),
            ),
            onTap: () {
              AppRoute.productDetail(context,
                  productImage:
                      "productImage_${index}_${widget.flashsaleRespone.data[0].items[index].product.id}1",
                  productItem: ProductBloc.convertDataToProduct(
                      data: widget
                          .flashsaleRespone.data[0].items[index].product));
            },
          );
        }),
      ),
    );
  }
/*
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
                height: 30.0.w,
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
              style: FunctionHelper.fontTheme(
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
                      style: FunctionHelper.fontTheme(
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
                style: FunctionHelper.fontTheme(
                    color: ThemeColor.colorSale(),
                    fontWeight: FontWeight.w500,
                    fontSize: SizeUtil.priceFontSize().sp),
              ),
            ],
          ),
          SizedBox(height: 1.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {},
                  starCount: 5,
                  rating: item.rating.toDouble(),
                  size: 4.0.w,
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half_outlined,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  spacing: 0.0),
              SizedBox(width: 1.0.w,),
              Text("${item.rating.toDouble()}",style: FunctionHelper.fontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
            ],
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(0.8.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0.h),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 3.0.w, right: 2.0.w, bottom: 1.0.w, top: 1.0.w),
                    color: ThemeColor.colorSale(),
                    child: Text("${item.saleCount!=null?item.saleCount.toString():'0'} ${LocaleKeys.my_product_sold_end.tr()}" ,
                      style: FunctionHelper.fontTheme(
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
*/
}
