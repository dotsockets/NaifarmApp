import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/ui/me/widget/BuyAgain.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class PurchaseView extends StatefulWidget {
  final bool IsLogin;
  final CustomerInfoRespone item;
  final Function(bool) onStatus;

  const PurchaseView({Key key, this.IsLogin, this.item, this.onStatus}) : super(key: key);

  @override
  _PurchaseViewState createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {

  ProductBloc bloc;

  init(){
    if(bloc==null){
      bloc = ProductBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getHomeDataCache().then((value){
        bloc.ProductPopular.add(value.trendingRespone);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      child: Column(
        children: [
          BlocBuilder<CustomerCountBloc, CustomerCountState>(
            builder: (_, count) {
              if(count is CustomerCountLoaded){
                return  _buildTabMenu(context,count.countLoaded);
              }else{
                return  _buildTabMenu(context,CustomerCountRespone(buyOrder: BuyOrder(unpaid: 0,toBeRecieve: 0,cancel: 0,confirm: 0,delivered: 0,failed: 0,fulfill: 0,refund: 0)));
              }

            },
          ),
          ListMenuItem(
            icon: 'assets/images/svg/latest.svg',
            title: LocaleKeys.me_title_history.tr(),
            iconSize: 8.0.w,
            onClick: () => AppRoute.MyShophistory(context,0,orderType: "order"),
          ),
          _BuildDivider(),
          BlocBuilder<CustomerCountBloc, CustomerCountState>(
            builder: (_, count) {
              if(count is CustomerCountLoaded){
                return  ListMenuItem(
                    icon: 'assets/images/svg/like_2.svg',
                    title: LocaleKeys.me_title_likes.tr(),
                    Message: "${count.countLoaded.like} รายการ",
                    iconSize: 8.0.w,
                    onClick: () {
                      AppRoute.Wishlists(context:context);
                    });
              }else{
                return  ListMenuItem(
                    icon: 'assets/images/svg/like_2.svg',
                    title: LocaleKeys.me_title_likes.tr(),
                    Message: "${0} รายการ",
                    iconSize: 8.0.w,
                    onClick: () {
                      AppRoute.Wishlists(context:context);
                    });
              }

            },
          ),
          _BuildDivider(),
          widget.IsLogin?StreamBuilder(
            stream: bloc.ProductPopular.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData && (snapshot.data as ProductRespone).data.length>0){
                return Container(
                  child: BuyAgain(
                    productRespone: (snapshot.data as ProductRespone),
                      titleInto: LocaleKeys.me_title_again.tr(),
                      IconInto: 'assets/images/svg/foryou.svg',
                      onSelectMore: () {
                        AppRoute.ProductMore(context: context,barTxt: LocaleKeys.me_title_again.tr(),installData: (snapshot.data as ProductRespone));

                      },
                      onTapItem: (ProductData item,int index) {
                        AppRoute.ProductDetail(context,
                            productImage: "payagin_${item.id}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                      },
                      tagHero: "payagin"),
                );
              }else{
                return SizedBox();
              }
            }
        ): SizedBox(),
          widget.IsLogin ? _BuildDivider() : SizedBox(),
          ListMenuItem(
            iconSize: 8.0.w,
              icon: 'assets/images/svg/editprofile.svg', title: LocaleKeys.me_title_setting.tr(),onClick: () async {
            final result = await AppRoute.SettingProfile(context,widget.IsLogin,item: widget.item);
            if(result!=null && result){
              widget.onStatus(result);
            }

              },),
          _BuildDivider(),
          ListMenuItem(
            iconSize: 8.0.w,
            icon: 'assets/images/svg/help.svg',
            title: LocaleKeys.me_title_help.tr(),
            onClick: () {
              AppRoute.SettingHelp(context);
            },
          )
        ],
      ),
    );
  }

  Widget _buildTabMenu(BuildContext context,CustomerCountRespone count) {
    return Container(
      padding: EdgeInsets.all(5.0.w),
      color: Colors.grey.shade300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabMenu(
              icon: 'assets/images/svg/status_pay.svg',
              title: LocaleKeys.me_menu_pay.tr(),
              onClick: (){AppRoute.MyShophistory(context,0,orderType: "order");},
              notification: count.buyOrder.unpaid),
          TabMenu(
            icon: 'assets/images/svg/status_delivery.svg',
            title: LocaleKeys.me_menu_ship.tr(),
            onClick: (){AppRoute.MyShophistory(context,1,orderType: "order");},
            notification: count.buyOrder.confirm,
          ),
          TabMenu(
              icon: 'assets/images/svg/status_pickup.svg',
              title: LocaleKeys.me_menu_receive_shop.tr(),
              onClick: (){AppRoute.MyShophistory(context,3,orderType: "order");},
              notification: count.buyOrder.toBeRecieve),
          TabMenu(
              icon: 'assets/images/svg/status_star.svg',
              title: LocaleKeys.me_menu_rate.tr(),
              onClick: (){AppRoute.MyShophistory(context,3,orderType: "order");},
              notification: count.watingReview)
        ],
      ),
    );
  }

  Widget _BuildDivider() {
    return Container(
      height: 0.5,
      color: Colors.black.withOpacity(0.4),
    );
  }
}
