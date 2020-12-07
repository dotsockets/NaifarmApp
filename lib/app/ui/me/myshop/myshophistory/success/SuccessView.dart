
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';

class SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
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
            SizedBox(height: 10,)
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
      padding: EdgeInsets.all(15),
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
                    width: 80,
                    height: 80,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                    ),
                    fit: BoxFit.cover,
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
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(item.product_name,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("x ${item.amoutProduct}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize(), color: Colors.black)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            item.ProductDicount != 0
                                ? Text("฿${item.ProductDicount}",
                                style: FunctionHelper.FontTheme(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: SizeUtil.titleFontSize(),
                                    decoration: TextDecoration.lineThrough))
                                : SizedBox(),
                            SizedBox(width: 10),
                            Text("฿${item.product_price}",
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize(), color: ThemeColor.ColorSale()))
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
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("รวมการสั่งซื้อ : ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize(), color: Colors.black)),
                  SizedBox(width: 8),
                  Text("฿${item.product_price*int.parse(item.amoutProduct)}.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize(), color: ThemeColor.ColorSale())),
                  SizedBox(width: 8),
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
                              fontSize: SizeUtil.titleSmallFontSize(), color: ThemeColor.primaryColor())),
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
                  Text("วันที่ซื้อ 28-06-2563",style: FunctionHelper.FontTheme(fontSize:SizeUtil.titleSmallFontSize(),color: Colors.black.withOpacity(0.6)),),
                  Row(
                    children: [
                      index==1?FlatButton(
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
                          "รอให้คะแนน",
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
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
                          "ซื้ออีกครั้ง",
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
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
                  FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(), fontWeight: FontWeight.bold))
            ],
          ),
          Text(item.product_status,style: FunctionHelper.FontTheme(color: ThemeColor.primaryColor(),fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }
}
