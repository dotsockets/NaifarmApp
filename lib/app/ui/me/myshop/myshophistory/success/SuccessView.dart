
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:naifarm/utility/SizeUtil.dart';

class SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 2.0.w),
        child: Column(
          children: ProductViewModel().getHistorySuccess().asMap().map((key, value) => MapEntry(key, _BuildCard(item: ProductViewModel().getHistorySuccess()[key],context: context,index: key))).values.toList(),
        ),
      ),
    );
  }

  Widget _BuildCard({ProductModel item,BuildContext context,int index}){
    return InkWell(
      child: Container(
        child: Column(
          children: [
            _OwnShop(item: item),
            _ProductDetail(item: item,index: index,context: context),
            SizedBox(height: 2.0.w,)
          ],
        ),
      ),
      onTap: (){
        AppRoute.ProductDetail(context,productImage: "history_${index}");
      },
    );
  }


  Widget _ProductDetail({ProductModel item, int index,BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(3.0.w),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag:"history_${index}",
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: CachedNetworkImage(
                    width: 22.0.w,
                    height: 22.0.w,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                    ),
                    fit: BoxFit.contain,
                    imageUrl: item.product_image,
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                ),
              ),
              SizedBox(width: 2.0.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.0.w),
                    Text(item.product_name,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500)),
                    SizedBox(height:6.0.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("x ${item.amoutProduct}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp, color: Colors.black)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            item.ProductDicount != 0
                                ? Text("฿${item.ProductDicount}",
                                style: FunctionHelper.FontTheme(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    decoration: TextDecoration.lineThrough))
                                : SizedBox(),
                            SizedBox(width: 3.0.w),
                            Text("฿${item.product_price}",
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp, color: ThemeColor.ColorSale()))
                          ],
                        )
                      ],
                    ),

                    Divider(color: Colors.black.withOpacity(0.4),)
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 3.0.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(LocaleKeys.history_order_price.tr()+" : ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp, color: Colors.black)),
                  SizedBox(width: 2.0.w),
                  Text("฿${item.product_price*int.parse(item.amoutProduct)}.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp, color: ThemeColor.ColorSale())),
                  SizedBox(width: 2.0.w),
                ],
              ),

              Divider(color: Colors.grey.shade500,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/svg/delivery.svg',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 8),
                      Text("[ฺBangkok] วีระชัย",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.primaryColor())),
                      SizedBox(width: 8),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,color: Colors.black.withOpacity(0.5),)
                ],
              ),
              Divider(color: Colors.grey.shade400,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(LocaleKeys.history_order_time.tr()+" 28-06-2563",style: FunctionHelper.FontTheme(fontSize:SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.6)),),
                  Row(
                    children: [
                      index==1?FlatButton(
                        minWidth: 10,
                        color: ThemeColor.ColorSale(),
                        textColor: Colors.white,
                        splashColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {
                         AppRoute.Review(context);
                        },
                        child: Text(
                          LocaleKeys.history_wait_rate.tr(),
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                        ),
                      ):SizedBox(),
                      SizedBox(width: 5,),
                      FlatButton(
                        color: ThemeColor.ColorSale(),
                        textColor: Colors.white,
                        splashColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {
                          /*...*/
                        },
                        child: Text(
                          LocaleKeys.me_title_again.tr(),
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )

                ],
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget _OwnShop({ProductModel item}) {
    return Container(
      padding: EdgeInsets.only(left: 15,top: 15,bottom: 5,right: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: CachedNetworkImage(
                  width: 25,
                  height: 25,
                  placeholder: (context, url) => Container(
                    color: Colors.white,
                    child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                  ),
                  fit: BoxFit.cover,
                  imageUrl: item.ProfiletImage,
                  errorWidget: (context, url, error) => Container(
                      height: 30,
                      child: Icon(
                        Icons.error,
                        size: 30,
                      )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(item.shopName,
                  style:
                  FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp, fontWeight: FontWeight.bold))
            ],
          ),
          Text(item.product_status,style: FunctionHelper.FontTheme(color: ThemeColor.primaryColor(),fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }
}
