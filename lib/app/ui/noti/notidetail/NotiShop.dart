
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
//'assets/images/svg/cart_top.svg'
class NotiShop extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool btnBack;
  const NotiShop({Key key, this.btnBack=false, this.scaffoldKey}) : super(key: key);
  @override
  _NotiShopState createState() => _NotiShopState();
}

class _NotiShopState extends State<NotiShop> with AutomaticKeepAliveClientMixin<NotiShop>{
  NotiBloc bloc;
  init(){
    NaiFarmLocalStorage.getNowPage().then((value) {
      if(value==2){
        Usermanager().getUser().then((value) => bloc.GetNotificationByGroup(group: "shop",page: 1,limit: 20,sort: "notification.createdAt:desc",token: value.token));

      }
    });
    if(bloc==null){
      bloc = NotiBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: widget.scaffoldKey,message: event);
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    init();
    return StreamBuilder(
      stream: bloc.feedList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var item = (snapshot.data as NotiRespone);
        if(snapshot.hasData && item.data.isNotEmpty){
          var item = (snapshot.data as NotiRespone);
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(

                children: item.data
                    .asMap()
                    .map((index, value) {
                  return MapEntry(
                      index,
                      _BuildCardNoti(
                          item: value,context: context,index: index));
                })
                    .values
                    .toList(),
              ),
            ),
          );
        }else{
          return Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 15.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/json/boxorder.json',
                      height: 70.0.w, width: 70.0.w, repeat: false),
                  Text(
                    LocaleKeys.cart_empty.tr(),
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  GestureDetector _BuildCardNoti({NotiData item,BuildContext context,int index}) => GestureDetector(
    onTap: (){
      // if(item.Status_Sell==1)
      //   AppRoute.NotiDetail(context,"notiitem_${index}","notititle_${index}");
      // else
      //   item.Status_Sell!=2?AppRoute.OrderDetail(context,item.Status_Sell):print("press 2");

    },
    child: Container(
        padding: EdgeInsets.only(top: 10,right: 10,left: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                    imageUrl: "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.meta.status.toString(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
                          SizedBox(height: 5),
                          //NotiViewModel().GetStatusMessage(status: item)
                          Text("คุณได้ทำรายการสั่งซื้อสินค้า หมายเลขคำสั่งซื้อ ${item.meta.order}  ")
                        ],
                      ),
                    )),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black.withOpacity(0.4),
                )
              ],
            ),
            SizedBox(height: 5,),
            Divider(color: Colors.black.withOpacity(0.4),)
          ],
        )
    ),
  );
  @override
  bool get wantKeepAlive => true;
}

