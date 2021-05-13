import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class PurchaseView extends StatefulWidget {
  final Function(bool) onStatus;

  const PurchaseView({Key key, this.onStatus}) : super(key: key);

  @override
  _PurchaseViewState createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  ProductBloc bloc;

  init() {
    if (bloc == null) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getHomeDataCache().then((value) {
        bloc.productPopular.add(value.productForyou);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: Colors.grey.shade300,
      child: Column(
        children: [
          BlocBuilder<CustomerCountBloc, CustomerCountState>(
            builder: (_, count) {
              if (count is CustomerCountLoaded) {
                return _buildTabMenu(context, count.countLoaded);
              } else if (count is CustomerCountLoading) {
                return _buildTabMenu(
                    context,
                    count.countLoaded != null
                        ? count.countLoaded
                        : CustomerCountRespone(
                            buyOrder: BuyOrder(
                                unpaid: 0,
                                toBeRecieve: 0,
                                cancel: 0,
                                confirm: 0,
                                delivered: 0,
                                failed: 0,
                                refund: 0)));
              } else {
                return _buildTabMenu(
                    context,
                    CustomerCountRespone(
                        buyOrder: BuyOrder(
                            unpaid: 0,
                            toBeRecieve: 0,
                            cancel: 0,
                            confirm: 0,
                            delivered: 0,
                            failed: 0,
                            refund: 0)));
              }
            },
          ),
          ListMenuItem(
            icon: 'assets/images/png/latest.png',
            title: LocaleKeys.me_title_history.tr(),
            iconSize: 7.0.w,
            onClick: () => AppRoute.myShophistory(context, 0),
          ),
          buildDivider(),
          BlocBuilder<CustomerCountBloc, CustomerCountState>(
            builder: (_, count) {
              if (count is CustomerCountLoaded) {
                return ListMenuItem(
                    icon: 'assets/images/png/like_2.png',
                    title: LocaleKeys.me_title_likes.tr(),
                    message:
                        "${count.countLoaded.like} ${LocaleKeys.cart_item.tr()}",
                    iconSize: 7.0.w,
                    onClick: () {
                      Usermanager().isLogin().then((value) {
                        if (value != null) {
                          AppRoute.wishlists(context: context);
                        }
                      });
                    });
              } else if (count is CustomerCountLoading) {
                return ListMenuItem(
                    icon: 'assets/images/png/like_2.png',
                    title: LocaleKeys.me_title_likes.tr(),
                    message:
                        "${count.countLoaded != null ? count.countLoaded.like : 0} ${LocaleKeys.cart_item.tr()}",
                    iconSize: 7.0.w,
                    onClick: () {
                      Usermanager().isLogin().then((value) {
                        if (value != null) {
                          AppRoute.wishlists(context: context);
                        }
                      });
                    });
              } else {
                return ListMenuItem(
                    icon: 'assets/images/png/like_2.png',
                    title: LocaleKeys.me_title_likes.tr(),
                    message: "${0} รายการ",
                    iconSize: 7.0.w,
                    onClick: () {
                      Usermanager().isLogin().then((value) {
                        if (value != null) {
                          AppRoute.wishlists(context: context);
                        }
                      });
                    });
              }
            },
          ),
          //   widget.IsLogin?StreamBuilder(
          //     stream: bloc.ProductPopular.stream,
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if(snapshot.hasData && (snapshot.data as ProductRespone).data.length>0){
          //         return Column(
          //           children: [
          //             _BuildDivider(),
          //             BuyAgain(
          //                 productRespone: (snapshot.data as ProductRespone),
          //                 titleInto: LocaleKeys.me_title_again.tr(),
          //                 IconInto: 'assets/images/svg/foryou.svg',
          //                 onSelectMore: () {
          //                   AppRoute.ProductMore(api_link: "products/types/random",context: context,barTxt: LocaleKeys.me_title_again.tr());
          //
          //                 },
          //                 onTapItem: (ProductData item,int index) {
          //                   AppRoute.ProductDetail(context,
          //                       productImage: "payagin_${item.id}",productItem: ProductBloc.ConvertDataToProduct(data: item));
          //                 },
          //                 tagHero: "payagin")
          //           ],
          //         );
          //       }else{
          //         return SizedBox();
          //       }
          //     }
          // ): SizedBox(),
          buildDivider(),
          ListMenuItem(
            iconSize: 7.0.w,
            icon: 'assets/images/png/editprofile.png',
            title: LocaleKeys.me_title_setting.tr(),
            onClick: () async {
              Usermanager().getUser().then((value) => context
                  .read<InfoCustomerBloc>()
                  .loadCustomInfo(context, token: value.token));
              final result = await AppRoute.settingProfile(context);
              if (result != null && result) {
                widget.onStatus(result);
              }
            },
          ),
          //buildDivider(),
          // ListMenuItem(
          //   iconSize: 6.5.w,
          //   icon: 'assets/images/svg/help.svg',
          //   title: LocaleKeys.me_title_help.tr(),
          //   onClick: () {
          //     AppRoute.settingHelp(context);
          //   },
          // )
        ],
      ),
    );
  }

  Widget _buildTabMenu(BuildContext context, CustomerCountRespone count) {
    return Container(
      padding: EdgeInsets.all(3.0.w),
      color: Colors.grey.shade300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabMenu(
              icon: 'assets/images/png/status_pay.png',
              title: LocaleKeys.me_menu_pay.tr(),
              onClick: () {
                AppRoute.myShophistory(context, 0);
              },
              notification: count.buyOrder.unpaid),
          TabMenu(
            icon: 'assets/images/png/status_delivery.png',
            title: LocaleKeys.me_menu_ship.tr(),
            onClick: () {
              AppRoute.myShophistory(context, 1);
            },
            notification: count.buyOrder.confirm,
          ),
          TabMenu(
              icon: 'assets/images/png/status_pickup.png',
              title: LocaleKeys.me_menu_receive_shop.tr(),
              onClick: () {
                AppRoute.myShophistory(context, 2);
              },
              notification: count.buyOrder.toBeRecieve),
          TabMenu(
              icon: 'assets/images/png/status_star.png',
              title: LocaleKeys.me_menu_rate.tr(),
              onClick: () {
                AppRoute.myShophistory(context, 3);
              },
              notification: count.watingReview)
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 0.5,
      color: Colors.black.withOpacity(0.4),
    );
  }
}
