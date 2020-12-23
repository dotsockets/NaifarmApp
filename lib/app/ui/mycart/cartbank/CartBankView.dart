import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class CartBankView extends StatefulWidget {
  @override
  _CartBankViewState createState() => _CartBankViewState();
}

class _CartBankViewState extends State<CartBankView> {
  List<CartModel> _data_aar = List<CartModel>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int select = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data_aar.addAll(CartViewModel().getMyCart());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            _data_aar.length != 0 ? Colors.grey.shade300 : Colors.white,
        appBar: AppToobar(title: LocaleKeys.select.tr()+LocaleKeys.me_title_payment.tr(),header_type: Header_Type.barNormal),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(right: 20,left: 20,top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.card_title.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                  Column(
                    children: CartViewModel().getBankCartType1().asMap().map((index, value){
                          return MapEntry(index, _BuildCard(item: CartViewModel().getBankCartType1()[index],index: index));
                    }).values.toList(),
                  ), SizedBox(height: 20,),
                _BuildBtnAddBack(txt: LocaleKeys.add.tr()+LocaleKeys.card_title.tr(),index: 0),
                SizedBox(height: 20,),
                Text(LocaleKeys.bank_title.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Column(
                  children: CartViewModel().getBankCartType2().asMap().map((index, value){
                    return MapEntry(index, _BuildCard(item: CartViewModel().getBankCartType2()[index],index: index));
                  }).values.toList(),
                ),
                SizedBox(height: 20,),
                _BuildBtnAddBack(txt: LocaleKeys.bank_add_toobar.tr(),index: 1)
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _BuildCard({BankModel item,int index}){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  child: select==index
                      ? SvgPicture.asset(
                    'assets/images/svg/checkmark.svg',
                    width: 35,
                    height: 35,
                    color: ThemeColor.primaryColor(),
                  )
                      : SvgPicture.asset(
                    'assets/images/svg/uncheckmark.svg',
                    width: 35,
                    height: 35,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onTap: () {
                    setState(() {
                      select = select!=index ? index : 0;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      height: 30,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child:
                        Lottie.asset(Env.value.loadingAnimaion, height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: item.BackIcon,
                      errorWidget: (context, url, error) => Container(
                          height: 30,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                    SizedBox(height: 0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.NameBank,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.titleFontSize(),height: 1.6,color: Colors.black),),
                        Row(
                          children: [
                            Text(item.NumberCard,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.titleFontSize(),height: 1.6,color: Colors.black),),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,)
                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }

  Widget _BuildBtnAddBack({String txt,int index}){
    return InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: DottedBorder(
          dashPattern: [8, 4],
          color: Colors.black.withOpacity(0.3),
          strokeWidth: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/images/svg/plus.svg',
                  width: 35,
                  height: 35,
                  color: Colors.black.withOpacity(0.5),
                ),
                SizedBox(width: 15),
                Text(txt,style: FunctionHelper.FontTheme(color: ThemeColor.primaryColor(),fontSize: SizeUtil.titleFontSize()),),
              ],
            ),
          ),
        ),
      ),
      onTap: (){
        index==0? AppRoute.SettingCreditAdd(context):AppRoute.SettingBankAdd(context);
      },
    );
  }


}
