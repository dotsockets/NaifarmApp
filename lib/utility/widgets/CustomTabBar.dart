import 'package:badges/badges.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/HomeMenuIndex.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../OneSignalCall.dart';

class CustomTabBar extends StatefulWidget {
  final List<MenuModel> menuViewModel;
  final int selectedIndex;

  const CustomTabBar({
    Key key,
    this.menuViewModel,
    this.selectedIndex,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);

    context.read<HomeMenuIndex>().listen((index) {
      _tabController.index = index;
    });
  }

  // if (!isSelect && index == 0) {
  // text = LocaleKeys.tab_bar_home.tr();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: _tabController,
        indicatorColor: Color(ColorUtils.hexToInt("#e85440")),
        indicatorWeight: 5.0,
        labelPadding: EdgeInsets.zero,
        labelColor: Colors.white60,
        labelStyle: TextStyle(
            fontSize: SizeUtil.detailFontSize().sp,
            fontWeight: FontWeight.bold),
        unselectedLabelColor: Colors.white,
        indicatorPadding: SizeUtil.custombarIndicationPadding(),
        tabs: [
          SizedBox(
            height: SizeUtil.tabMenuHeight().h,
            child: Tab(
              icon: _buildIcon(
                  sizeIcon: SizeUtil.custombarIconSize().w,
                  pathIcon: 'assets/images/png/home_active.png',
                  index: 0,
                  notification: 0),
              text: _tabController.index == 0
                  ? LocaleKeys.tab_bar_recommend.tr()
                  : LocaleKeys.tab_bar_home.tr(),
            ),
          ),
          SizedBox(
            height: SizeUtil.tabMenuHeight().h,
            child: Tab(
              icon: _buildIcon(
                  sizeIcon: SizeUtil.custombarIconSize().w,
                  pathIcon: 'assets/images/png/type.png',
                  index: 1,
                  notification: 0),
              text: LocaleKeys.tab_bar_category.tr(),
            ),
          ),
          SizedBox(
            height: SizeUtil.tabMenuHeight().h,
            child: Tab(
              icon: BlocBuilder<CustomerCountBloc, CustomerCountState>(
                builder: (_, count) {
                  if (count is CustomerCountLoaded) {
                    return _buildIcon(
                        sizeIcon: SizeUtil.custombarIconSize().w + 1.0.w,
                        pathIcon: 'assets/images/png/notification.png',
                        index: 2,
                        notification:
                            count.countLoaded.notification.unreadCustomer +
                                count.countLoaded.notification.unreadShop);
                  } else if (count is CustomerCountLoading) {
                    return _buildIcon(
                      sizeIcon: SizeUtil.custombarIconSize().w + 1.0.w,
                      pathIcon: 'assets/images/png/notification.png',
                      index: 2,
                      notification: count.countLoaded != null
                          ? count.countLoaded.notification.unreadCustomer +
                              count.countLoaded.notification.unreadShop
                          : count.countLoaded != null
                              ? count.countLoaded.cartCount
                              : 0,
                    );
                  } else {
                    return _buildIcon(
                        sizeIcon: SizeUtil.custombarIconSize().w + 1.0.w,
                        pathIcon: 'assets/images/png/notification.png',
                        index: 2,
                        notification: 0);
                  }
                },
              ),
              text: LocaleKeys.recommend_notification.tr(),
            ),
          ),
          SizedBox(
            height: SizeUtil.tabMenuHeight().h,
            child: Tab(
              icon: BlocBuilder<CustomerCountBloc, CustomerCountState>(
                builder: (_, count) {
                  if (count is CustomerCountLoaded) {
                    return _buildIcon(
                      sizeIcon: (SizeUtil.custombarIconSize() + 0.7).w,
                      pathIcon: 'assets/images/png/cart.png',
                      index: 3,
                      notification: count.countLoaded != null
                          ? count.countLoaded.cartCount
                          : 0,
                    );
                  } else if (count is CustomerCountLoading) {
                    return _buildIcon(
                      sizeIcon: (SizeUtil.custombarIconSize() + 0.7).w,
                      pathIcon: 'assets/images/png/cart.png',
                      index: 3,
                      notification: count.countLoaded != null
                          ? count.countLoaded.cartCount
                          : 0,
                    );
                  } else {
                    return _buildIcon(
                        sizeIcon: (SizeUtil.custombarIconSize() + 0.7).w,
                        pathIcon: 'assets/images/png/cart.png',
                        index: 3,
                        notification: 0);
                  }
                },
              ),
              text: LocaleKeys.cart_toobar.tr(),
            ),
          ),
          SizedBox(
            height: SizeUtil.tabMenuHeight().h,
            child: Tab(
              icon: _buildIcon(
                  sizeIcon: SizeUtil.custombarIconSize().w,
                  pathIcon: 'assets/images/png/me.png',
                  index: 4,
                  notification: 0),
              text: LocaleKeys.tab_bar_me.tr(),
            ),
          ),
        ],
        onTap: (index) {
          if (index != 3) {
            context.read<HomeMenuIndex>().onSelect(index);
          } else {
            _tabController.index = widget.selectedIndex;
          }

          // widget.onTap(index),
          Usermanager().getUser().then((value) => context
              .read<CustomerCountBloc>()
              .loadCustomerCount(context, token: value.token));
          NaiFarmLocalStorage.saveNowPage(index);
          if (index == 4 || index == 2) {
            OneSignalCall.cancelNotification("", 0);
          }

          if (index == 3) {
            Usermanager().getUser().then((value) {
              if (value.token != null) {
                AppRoute.myCart(context, true);
              } else {
                AppRoute.login(context,
                    isCallBack: true, isHeader: true, isSetting: false);
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildIcon(
      {String pathIcon, int index, int notification, double sizeIcon}) {
    return Stack(
      children: [
        Column(
          children: [
            Badge(
              shape: BadgeShape.circle,
              position: BadgePosition.topEnd(top: -1.5.w, end: -1.0.w),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              showBadge: index == 2 || index == 3
                  ? notification > 0
                      ? true
                      : false
                  : false,
              badgeContent: Container(
                padding: EdgeInsets.all(notification < 10
                    ? (SizerUtil.deviceType == DeviceType.mobile ? 0.7 : 3.0)
                    : 0),
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: SizerUtil.deviceType == DeviceType.mobile
                          ? 0.5.w
                          : 0),
                  child: Text(
                    "$notification",
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.shopBadgeSize().sp),
                  ),
                ),
              ),
              child: Container(
                child: Image.asset(
                  pathIcon,
                  color: _tabController.index == index
                      ? ThemeColor.gradientColor()
                      : Colors.white,
                  width: sizeIcon,
                  height: sizeIcon,
                ),
              ),
            ),
            // Jaruvas
            /*_buildLabel(
              text: text,
              color: isSelect ? ThemeColor.secondaryColor() : Colors.white,
              wrapText: menuViewModel[0].label == text,
            ),
            SizedBox(height: 0.5.w),
            isSelect
                ? Container(
                    color: Color(ColorUtils.hexToInt("#e85440")),
                    width: 10.0.w,
                    height: 1.0.w,
                  )
                : SizedBox()*/
          ],
        ),
      ],
    );
  }

  Baseline buildLabel({String text, Color color, bool wrapText}) => Baseline(
        baselineType: TextBaseline.alphabetic,
        child: Text(
          text,
          style: TextStyle(
            fontSize: SizeUtil.detailSmallFontSize().sp,
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: wrapText ? -1.0 : null,
          ),
        ),
        baseline: 12,
      );
}
