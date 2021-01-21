import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class RecommendMenu extends StatelessWidget {

  final HomeObjectCombine homeObjectCombine;

  final List<MenuModel> _menuViewModel = MenuViewModel().getRecommendmenu();

   RecommendMenu({Key key, this.homeObjectCombine}) : super(key: key);
  NotiBloc bloc;

  init(BuildContext context){
    bloc = NotiBloc(AppProvider.getApplication(context));

  }


  @override
  Widget build(BuildContext context) {
    init(context);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 2.0.h),
          child: BlocBuilder<CustomerCountBloc, CustomerCountState>(
            builder: (_, count) {
              if(count is CustomerCountLoaded){
                return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _menuViewModel.asMap().map((key, value){
                    return MapEntry(key, _menuBox(item: value,index: key,notification: count.countLoaded.notification.unreadShop+count.countLoaded.notification.unreadCustomer,context: context));
                  }).values.toList(),
                );
              }else if(count is CustomerCountLoading){
                return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _menuViewModel.asMap().map((key, value){
                    return MapEntry(key, _menuBox(item: value,index: key,notification: count.countLoaded!=null?count.countLoaded.notification.unreadCustomer+count.countLoaded.notification.unreadShop:0,context: context));
                  }).values.toList(),
                );
              }else{
                return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _menuViewModel.asMap().map((key, value){
                    return MapEntry(key, _menuBox(item: value,index: key,notification: 0,context: context));
                  }).values.toList(),
                );
              }

            },
          ),
      ),
    );
  }


  Widget getMessageRead({ int index,int notification}){
    if(index==3 && notification>0){
      return Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(1.0.h),
          decoration: BoxDecoration(
            color: ThemeColor.ColorSale(),
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            minWidth: 1.0.w,
            minHeight: 1.0.h,
          ),
        ),
      );
    }else{
      return SizedBox();
    }
  }

  Widget _menuBox({MenuModel item,int index,int notification,BuildContext context}){
    return InkWell(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(1.0.w),
                child: SvgPicture.asset(item.icon,width: 13.0.w,height: 14.0.w,),
              ),
              getMessageRead(notification: notification,index: index)
            ],
          ),
          SizedBox(height: 0.1.h),
          Text(item.label,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.detailFontSize().sp))
        ],
      ),
    onTap: () {
      switch(item.page){
        case  "ShopMyNear" : AppRoute.ShopMyNear(context);
        break;
        case  "MarketView" :  AppRoute.ShopMain(context: context,myShopRespone: MyShopRespone(id: 1));
        break;
        case  "SpecialproductsView" : AppRoute.ProductMore(installData: homeObjectCombine.trendingRespone,api_link: "products/types/popular",context:context,barTxt:LocaleKeys.recommend_special_price_product.tr());
        break;
        case  "NotiView" :  {
          AppRoute.MyNoti(context,true);
          Usermanager().getUser().then((value){
            bloc.MarkAsReadNotifications(token: value.token);
          });
        }
        break;
        case  "MyLikeView" : {

          Usermanager().isLogin().then((value) async {
            if(!value){
              final result = await  AppRoute.Login(context,IsCallBack: true);
              if(result){
                AppRoute.Wishlists(context: context);
              }
            }else{
              AppRoute.Wishlists(context: context);
            }
          });



        }
        break;
      }
    },
    );
  }
}
