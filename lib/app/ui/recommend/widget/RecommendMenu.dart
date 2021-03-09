import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
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
  final Function(int) onClick;

  final List<MenuModel> _menuViewModel = MenuViewModel().getRecommendmenu();

   RecommendMenu({Key key, this.homeObjectCombine, this.onClick}) : super(key: key);
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
    if(index==2 && notification>0){
      return Positioned(
        right: 2,
        top: 2,
        child: Container(
          padding: EdgeInsets.all(0.8.h),
          decoration: BoxDecoration(
            color: ThemeColor.ColorSale(),
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            minWidth: 0.5.w,
            minHeight: 0.5.h,
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
                child: SvgPicture.asset(item.icon,width: 11.0.w,height: 11.0.w,),
              ),
              //getMessageRead(notification: notification,index: index)
            ],
          ),
          SizedBox(height: 0.1.h),
          Text(item.label,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.detailFontSize().sp))
        ],
      ),
    onTap: () async {
      switch(item.page){
       /* case  "ShopMyNear" :{
    FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
        //  AppRoute.ShopMyNear(context);
        }
        break;
        */
        case  "MarketView" :  AppRoute.ShopMain(context: context,myShopRespone: MyShopRespone(id: 1));
        break;
        case  "SpecialproductsView" : AppRoute.ProductMore(api_link: "products/types/discount",context:context,barTxt:LocaleKeys.recommend_special_price_product.tr());
        break;
        case  "NotiView" :  {
    // NaiFarmLocalStorage.saveNowPage(2).then((data){
    //
    //   //onClick(2);
    //         });

        Usermanager().isLogin().then((value) async {
          if(!value){
            final result = await  AppRoute.Login(context,IsCallBack: true,IsHeader: true);
          }else{
            NaiFarmLocalStorage.saveNowPage(2).then((value){
              AppRoute.MyNoti(context,true);
            });
          }
        });


        }
        break;
        case  "MyLikeView" : {

          // Usermanager().isLogin().then((value) async {
          //   if(!value){
          //     final result = await  AppRoute.Login(context,IsCallBack: true,IsHeader: true);
          //     if(result){
          //       AppRoute.Wishlists(context: context);
          //     }
          //   }else{
          //     AppRoute.Wishlists(context: context);
          //   }
          // });
          AppRoute.Wishlists(context: context);

        }
        break;
      }
    },
    );
  }
}
