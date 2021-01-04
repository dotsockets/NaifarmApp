import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/ui/me/widget/BuyAgain.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class PurchaseView extends StatelessWidget {
  final bool IsLogin;

  const PurchaseView({Key key, this.IsLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildTabMenu(context),
          ListMenuItem(
            icon: 'assets/images/svg/latest.svg',
            title: LocaleKeys.me_title_history.tr(),
            onClick: () => AppRoute.MyShophistory(context,0),
          ),
          _BuildDivider(),
          ListMenuItem(
              icon: 'assets/images/svg/like_2.svg',
              title: LocaleKeys.me_title_likes.tr(),
              Message: "8 รายการ",
              onClick: () {
                AppRoute.ProductMore(context,LocaleKeys.me_title_likes.tr(),ProductViewModel().getMarketRecommend());
              }),
          _BuildDivider(),
          IsLogin
              ? Container(
                  child: BuyAgain(
                      titleInto: LocaleKeys.me_title_again.tr(),
                      producViewModel: ProductViewModel().getProductForYou(),
                      IconInto: 'assets/images/svg/foryou.svg',
                      onSelectMore: () {
                        AppRoute.ProductMore(context,LocaleKeys.me_title_again.tr(),ProductViewModel().getProductForYou());
                      },
                      onTapItem: (int index) {
                        AppRoute.ProductDetail(context,
                            productImage: "payagin_${index}");
                      },
                      tagHero: "payagin"),
                )
              : SizedBox(),
          IsLogin ? _BuildDivider() : SizedBox(),
          ListMenuItem(
              icon: 'assets/images/svg/editprofile.svg', title: LocaleKeys.me_title_setting.tr(),onClick: (){AppRoute.SettingProfile(context,IsLogin);},),
          _BuildDivider(),
          ListMenuItem(
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

  Widget _buildTabMenu(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0.w),
      color: Colors.grey.shade300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabMenu(
              icon: 'assets/images/svg/status_pay.svg',
              title: LocaleKeys.me_menu_pay.tr(),
              onClick: (){AppRoute.MyShophistory(context,0);},
              notification: 1),
          TabMenu(
            icon: 'assets/images/svg/status_delivery.svg',
            title: LocaleKeys.me_menu_ship.tr(),
            onClick: (){AppRoute.MyShophistory(context,1);},
            notification: 0,
          ),
          TabMenu(
              icon: 'assets/images/svg/status_pickup.svg',
              title: LocaleKeys.me_menu_receive_shop.tr(),
              onClick: (){AppRoute.MyShophistory(context,3);},
              notification: 0),
          TabMenu(
              icon: 'assets/images/svg/status_star.svg',
              title: LocaleKeys.me_menu_rate.tr(),
              onClick: (){AppRoute.MyShophistory(context,3);},
              notification: 0)
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
