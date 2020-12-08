
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomStarRating.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewView extends StatelessWidget {

  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        title: "รีวิว",
        header_type: Header_Type.barNormal,
        icon: '',
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [

              _Header(item: ProductViewModel().getHistorySuccess()[0],index: 0,context: context),
              SizedBox(height: 10,),
              _BuildForm(context),
              _buildBtnSend()
            ],
          ),
        ),
      ),
    );
  }

  Widget _Header({ProductModel item,int index,BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 15),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("หมายเลขคำสั่งซื้อ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.bold),),
              Text("09988203dergd4",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold),),

            ],
          ),
          SizedBox(height: 10,),
          Container(
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
                        FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.bold))
                  ],
                ),

              ],
            ),
          ),
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
                    SizedBox(height: 20,)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _BuildForm(BuildContext context){
    return Container(
      padding: EdgeInsets.only(bottom: 20,top: 30),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
        child: Column(
          children: [
            Text("ให้คะแนน",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            CustomStarRating(
                allowHalfRating: false,
                onRated: (v) {},
                starCount: 5,
                rating: 2.5,
                size: 45.0,
                isReadOnly: false,
                filledIconData: 'assets/images/svg/star_active.svg',
                halfFilledIconData: 'assets/images/svg/star_unactive.svg',
                color: Colors.amber,
                borderColor: Colors.amber,
                spacing: 0.0),
            SizedBox(height: 10,),
            Divider(color: Colors.black.withOpacity(0.5),),
            Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 20),
              child: BuildEditText(
                  head: "รีวิว * ",maxLength: 5000,
                  hint: "เขียนรีวิว",maxLine: 5,controller: reviewController,inputType: TextInputType.text),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BuildButtonreview(title: "ส่งไวมาก",onClick: ()=>reviewController.text = "ส่งไวมาก" ),
                SizedBox(width: 10,),
                _BuildButtonreview(title: "สินค้าดีมาก",onClick: ()=>reviewController.text = "สินค้าดีมาก"),
                SizedBox(width: 10,),
                _BuildButtonreview(title: "คุณภาพดี",onClick: ()=>reviewController.text = "คุณภาพดี"),
              ],
            )
          ],
        ),
    );
  }

  Widget _BuildButtonreview({String title="",Function() onClick}){
    return FlatButton(
      color: Colors.grey.shade300,
      textColor: Colors.black,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        onClick();
      },
      child: Text(
        title,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBtnSend({Function() onClick}){
    return Container(
      margin: EdgeInsets.only(top: 20,bottom: 20),
      child: FlatButton(
        color: ThemeColor.secondaryColor(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          onClick();
        },
        child: Text(
          "ยืนยัน",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
