
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class DeliveryView extends StatefulWidget {
  @override
  _DeliveryViewState createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  int checkDeli = 1;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body:  Container(
          color: Colors.grey.shade300,
          child: Column(
              children: [
                Container(
                    child: AppToobar(title: LocaleKeys.shipping_toobar.tr(),icon: "",header_type:  Header_Type.barNormal,)),
                Column(
                  children: [
                    _BuildDelivery(nameDeli: "DHL Domestic",index: 1),
                    Container(height: 1,color: Colors.grey.shade300,),
                    _BuildDelivery(nameDeli: "Kerry",index: 2),
                    Container(height: 1,color: Colors.grey.shade300,),
                    _BuildDelivery(nameDeli: "J&T Express",index: 3)
                  ],
                ),
              ],
            ),

        ),
      ),
    );
  }
Widget _BuildDelivery({String nameDeli,int index}){
    return Container(
      padding: EdgeInsets.all(2.0.h),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 2.0.w,right: 2.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(nameDeli,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500)),
            InkWell(
              onTap: (){
                setState(() {
                  checkDeli = index;
                });
              },
              child:
              checkDeli==index?
              SvgPicture.asset(
                'assets/images/svg/checkmark.svg',
                color: ThemeColor.primaryColor(),
                width: 8.0.w,
                height: 8.0.w,
              ):
              SvgPicture.asset(
                'assets/images/svg/uncheckmark.svg',
                width: 8.0.w,
                height: 8.0.w,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
}
}
