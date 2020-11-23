import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class BankSettingView extends StatefulWidget {
  @override
  _BankSettingViewState createState() => _BankSettingViewState();
}

class _BankSettingViewState extends State<BankSettingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            Title: "ข้อมูลบัญชีธนาคาร/บัตร",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "บัตรเครดิต",
                  style: FunctionHelper.FontTheme(fontSize: 14),
                ),
                SizedBox(height: 5,),
                Column(
                  children: CartViewModel().getBankCartType1().asMap().map((index, value){
                    return MapEntry(index, _buildCardBank(item: CartViewModel().getBankCartType1()[index],index: index));
                  }).values.toList(),
                ),
                SizedBox(height: 10,),
                _buildAddBtn(txtBtn: "เพิ่มบัตรเครดิต/บัตรเดบิต",indexBtn: 0),
                SizedBox(height: 20,),
                Text(
                  "บัญชีธนาคารเพื่อรับเงิน",
                  style: FunctionHelper.FontTheme(fontSize: 14),
                ),SizedBox(height: 5,),
                Column(
                  children: CartViewModel().getBankCartType2().asMap().map((index, value){
                    return MapEntry(index, _buildCardBank(item: CartViewModel().getBankCartType2()[index],index: index));
                  }).values.toList(),
                ),
                SizedBox(height: 10,),
                _buildAddBtn(txtBtn: "เพิ่มบัญชีธนาคาร",indexBtn: 1),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBank({BankModel item,int index}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(item.NameBank,style: FunctionHelper.FontTheme(fontSize: 16)),
          Text(item.NumberCard,style: FunctionHelper.FontTheme(fontSize: 16))],)
        ],
      ),
    );
  }

  Widget _buildAddBtn({String txtBtn,int indexBtn}){
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: DottedBorder(
        dashPattern: [5, 5],
        color: Colors.grey.withOpacity(0.5),
        strokeWidth: 5,
        child: InkWell(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Row(
              children: [
                Text("+",style: FunctionHelper.FontTheme(fontSize: 20,fontWeight: FontWeight.w200),),
                SizedBox(width: 15,),
                Text(txtBtn,style: FunctionHelper.FontTheme(color: ThemeColor.primaryColor(),fontSize: 16),),
              ],
            ),
          ),
          onTap: (){
            indexBtn ==0? AppRoute.SettingCreditAdd(context):AppRoute.SettingBankAdd(context);
          },
        ),
      ),
    );
  }
}
