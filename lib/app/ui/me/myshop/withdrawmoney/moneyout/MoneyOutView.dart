import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class MoneyOutView extends StatefulWidget {
  @override
  _MoneyOutViewState createState() => _MoneyOutViewState();
}

class _MoneyOutViewState extends State<MoneyOutView> {
  TextEditingController inputController = TextEditingController();
  bool CheckBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppToobar(
        title: LocaleKeys.wallet_balance_withdraw.tr(),
        header_type: Header_Type.barNormal,
        icon: "",
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _BuildContent(),
              ),
              _BuildButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildContent() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildCardBank(),
            SizedBox(
              height: 10,
            ),
            _BuildForm()
          ],
        ),
      ),
    );
  }

  Widget _BuildCardBank() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.wallet_balance_withdraw_to.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp),),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    height: 30,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child:
                          Lottie.asset('assets/json/loading.json', height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://img.utdstc.com/icons/scb-easy-android.png:225",
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("ธนาคารไทยพาณิช",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp)),
                ],
              ),
              Row(
                children: [
                  Text("* 9803",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp)),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade500,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _BuildForm() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(child: SvgPicture.asset(CheckBox?'assets/images/svg/Check_CheckBox.svg':'assets/images/svg/Uncheck_CheckBox.svg',width: 20,height: 20,),onTap: (){
                setState(() {
                  CheckBox = CheckBox?false:true;
                });
              },),
              SizedBox(width: 10,),
              Text(LocaleKeys.wallet_balance_withdraw_all.tr()+" (฿300.00)",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp))
            ],
          ),
          SizedBox(height: 10,),
          Text(LocaleKeys.wallet_balance_withdraw_amount.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp)),
          BuildEditText(
              head: "",maxLength: 16,
              hint: "0.00",maxLine: 1,controller: inputController,inputType: TextInputType.number),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.wallet_balance_withdraw_fee.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp)),
              Text(LocaleKeys.cart_free.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp))
            ],
          )
        ],
      ),
    );
  }

  Widget _BuildButton(BuildContext context) {
    return Container(
      child: FlatButton(
        minWidth: MediaQuery.of(context).size.width,
        color: ThemeColor.secondaryColor(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        onPressed: () {
          /*...*/
        },
        child: Text(
          LocaleKeys.btn_confirm.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
