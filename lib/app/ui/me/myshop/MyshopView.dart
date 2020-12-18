import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';

class MyshopView extends StatelessWidget {
  final bool IsLogin;

  const MyshopView({Key key, this.IsLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          _buildTabMenu(context),
          ListMenuItem(
            icon: 'assets/images/svg/latest.svg',
            title: LocaleKeys.me_title_history.tr(),
            onClick: () => AppRoute.MyShophistory(context,0),
          ),
          IsLogin ? _BuildDivider() : SizedBox(),
          IsLogin
              ? ListMenuItem(
                  icon: 'assets/images/svg/like_2.svg',
                  title: LocaleKeys.me_title_wallet.tr(),
                  Message: "300 บาท",
                  onClick: () => AppRoute.WithdrawMoney(context),
                )
              : SizedBox(),
          IsLogin ? _BuildDivider() : SizedBox(),
          IsLogin
              ? ListMenuItem(
                  icon: 'assets/images/svg/editprofile.svg',
                  title: LocaleKeys.me_title_my_product.tr(),
                  onClick: () {
                    AppRoute.MyProduct(context);
                  },
                )
              : SizedBox(),
          IsLogin ? _BuildDivider() : SizedBox(),
          IsLogin
              ? ListMenuItem(
                  icon: 'assets/images/svg/delivery.svg',
                  title: LocaleKeys.me_title_shipping.tr(),
                  onClick: () {
                    AppRoute.DeliveryMe(context);
                  },
                )
              : SizedBox(),
          _BuildDivider(),
          ListMenuItem(
              icon: 'assets/images/svg/money.svg',
              title: LocaleKeys.me_title_payment.tr(),
              onClick: () {
                AppRoute.PaymentMe(context);
              }),
          _BuildDivider(),
          ListMenuItem(
            icon: 'assets/images/svg/help.svg',
            title: LocaleKeys.me_title_help.tr(),
            onClick: () {
              AppRoute.SettingHelp(context);
            },
          ),
          SizedBox(height: 50),
          _buildBtnAddProduct(context)
        ],
      ),
    );
  }

  Widget _buildTabMenu(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey.shade300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabMenu(
              icon: 'assets/images/svg/status_delivery.svg',
              title: LocaleKeys.me_tab_shop.tr(),
              onClick: (){AppRoute.ShopMain(context);},
              notification: 0),
          TabMenu(
            icon: 'assets/images/svg/status_cancel.svg',
            title: LocaleKeys.me_menu_cancel_product.tr(),
         onClick: (){AppRoute.MyShophistory(context,4);
         },
            notification: 1,
          ),
          TabMenu(
            icon: 'assets/images/svg/status_restore.svg',
            title: LocaleKeys.me_menu_refund_product.tr(),
            onClick: (){AppRoute.MyShophistory(context,5);},
            notification: 0,
          ),
          TabMenu(
            icon: 'assets/images/svg/orther.svg',
            title: LocaleKeys.me_menu_other.tr(),
            notification: 0,
          )
        ],
      ),
    );
  }

  Widget _buildBtnAddProduct(BuildContext context) {
    return Container(
      child: FlatButton(
        color: ThemeColor.secondaryColor(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          AppRoute.MyNewProduct(context);
        },
        child: Text(
          LocaleKeys.add_product_btn.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
        ),
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
