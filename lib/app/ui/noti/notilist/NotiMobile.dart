import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers.dart';

class NotiMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: StickyHeader(
              header: AppToobar(
                Title: "แจ้งเตือน",
                header_type: Header_Type.barNormal,
                icon: 'assets/images/svg/cart_top.svg',
                onClick: () {
                  AppRoute.MyCart(context);
                },
              ),
              content: Column(

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
      ),
    );
  }

  GestureDetector _BuildCardNoti({NotiModel item,BuildContext context,int index}) => GestureDetector(
    onTap: (){
      item.Status_Sell!=2?AppRoute.NotiDetail(context,"notiitem_${index}","notititle_${index}"):null;
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
                               Hero( tag: "notititle_${index}",child: Text(item.Title,style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.bold,color: item.Status_Sell!=2?Colors.black:Colors.red))),
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
