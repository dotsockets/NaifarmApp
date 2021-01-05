
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/WithDrawModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class WithdrawMoneyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _BuildBar(context),
                Stack(
                  children: [
                    Container(
                      color: Colors.grey.shade300,
                      height: MediaQuery.of(context).size.height/1.9,
                    ),
                    _BuildHeader(context),
                    _BuildContent(context)
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildHeader(BuildContext context){
    return Container(
      padding: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: BorderRadius.only(bottomRight:  Radius.circular(40),bottomLeft: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Text(LocaleKeys.wallet_balance_title.tr(),style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Text("฿300.00",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: 28),)
        ],
      )
    );
  }
  Widget _BuildBar(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 20,top: 20),
      color: ThemeColor.primaryColor(),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          InkWell(child: Icon(Icons.arrow_back_ios,color: Colors.white,),onTap: ()=>Navigator.of(context).pop(),)
        ],
      ),
    );
  }

  Widget _BuildContent(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top:150),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top:60),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft: Radius.circular(40)),
                border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
            ),
            child: Container(
              padding: EdgeInsets.only(left: 15,right: 15,bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Text(LocaleKeys.wallet_balance_trans_history.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: Colors.black.withOpacity(0.7))),
                  Column(
                    children: CartViewModel().getWidthDrawMoney().asMap().map((key, value) => MapEntry(key, _ItemCard(item: CartViewModel().getWidthDrawMoney()[key]))).values.toList(),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _HeaderText(context),
          )
        ],
      ),
    );
  }
  Widget _HeaderText(BuildContext context){
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width/1.4,
        height: 60,
        margin: EdgeInsets.only(top: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: EdgeInsets.only(right: 13,left: 30,top: 5,bottom: 5),
            color: ThemeColor.ColorSale(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 6,
                  child: Align(alignment: Alignment.center,child: Text(LocaleKeys.wallet_balance_withdraw.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.priceFontSize().sp,color: Colors.white))),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(Icons.arrow_forward,color: Colors.white,),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: (){
        AppRoute.MoneyOut(context);
      },
    );
  }

  Widget _ItemCard({WithDrawModel item,int index}){
    return Container(
      child: Column(
        children: [
          Divider(color: Colors.black.withOpacity(0.5),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        color: item.price>0?ThemeColor.primaryColor():ThemeColor.ColorSale(),
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.Title,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,height: 1.8,fontWeight: FontWeight.bold),),
                      Text(item.Subtitle,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.8),),
                      Text(item.Text_date,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.8),),
                    ],
                  )
                ],
              ),
              Text("${item.price>0?"+":"-"}฿${item.price>0?item.price:item.price.abs()}.00",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,height: 1.8,fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
