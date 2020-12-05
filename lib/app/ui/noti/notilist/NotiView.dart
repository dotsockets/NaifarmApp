import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers.dart';
//'assets/images/svg/cart_top.svg'
class NotiView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar:  AppToobar(header_type: Header_Type.barNormal,icon: 'assets/images/svg/cart_top.svg',title: "แจ้งเตือน",),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(

              children: NotiViewModel()
                  .getNoti()
                  .asMap()
                  .map((index, value) {
                return MapEntry(
                    index,
                    _BuildCardNoti(
                        item: NotiViewModel().getNoti()[index],context: context,index: index));
              })
                  .values
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _BuildCardNoti({NotiModel item,BuildContext context,int index}) => GestureDetector(
    onTap: (){
      if(item.Status_Sell==1)
        AppRoute.NotiDetail(context,"notiitem_${index}","notititle_${index}");
      else
        AppRoute.OrderDetail(context,item.Status_Sell);

    },
         child: Container(
             padding: EdgeInsets.only(top: 10,right: 10,left: 10),
             child: Column(
               children: [
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Hero(
                       tag: "notiitem_${index}",
                       child: Container(
                         padding: EdgeInsets.all(8),
                         decoration: BoxDecoration(
                             border: Border.all(
                                 color: Colors.black.withOpacity(0.2), width: 1),
                             borderRadius: BorderRadius.all(Radius.circular(6))),
                         child: CachedNetworkImage(
                           width: 35,
                           height: 35,
                           placeholder: (context, url) => Container(
                             color: Colors.white,
                             child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                           ),
                           fit: BoxFit.cover,
                           imageUrl: item.ImageShop,
                           errorWidget: (context, url, error) => Container(
                               height: 30,
                               child: Icon(
                                 Icons.error,
                                 size: 30,
                               )),
                         ),
                       ),
                     ),
                     Expanded(
                         child: Container(
                           padding: EdgeInsets.only(left: 10,right: 5),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Hero( tag: "notititle_${index}",child: Text(item.Title,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.bold,color: item.Status_Sell!=2?Colors.black:Colors.red))),
                               SizedBox(height: 5),
                               NotiViewModel().GetStatusMessage(status: item)
                             ],
                           ),
                         )),
                     item.Status_Sell!=2?Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.black.withOpacity(0.4),
                     ):SizedBox()
                   ],
                 ),
                 SizedBox(height: 5,),
                 Divider(color: Colors.black.withOpacity(0.4),),
                 SizedBox(height: 5,),
               ],
             )
         ),
    );
}
