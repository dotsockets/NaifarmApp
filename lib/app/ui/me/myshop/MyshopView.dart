import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRespone.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/ExpandedSection.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class MyshopView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onStatus;

  MyshopView({Key key, this.scaffoldKey, this.onStatus}) : super(key: key);

  @override
  _MyshopViewState createState() => _MyshopViewState();
}

class _MyshopViewState extends State<MyshopView> {
  MemberBloc bloc;

  TextEditingController nameshopController = TextEditingController();
  TextEditingController slugshopController = TextEditingController();
  bool check = false;

  void _init() {
    if (null == bloc) {
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.AlertDialogShop(context,
            message: event.message, title: "Error Create");
        // FunctionHelper.SnackBarShow(scaffoldKey: widget.scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        // Future.delayed(
        //     const Duration(milliseconds: 1000), () {
        //
        // });
        Usermanager().getUser().then((value) => context
            .read<InfoCustomerBloc>()
            .loadCustomInfo(context, token: value.token));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
      builder: (_, item) {
        if (item is InfoCustomerLoaded) {
          if (item.profileObjectCombine.myShopRespone != null) {
            return _BuildMyShop(context,
                item: item.profileObjectCombine.myShopRespone,
                shpping: item.profileObjectCombine.shppingMyShopRespone);
          } else {
            return _BuildRegisterMyshop(context);
          }
        }else if(item is InfoCustomerError) {
          if (item.profileObjectCombine.myShopRespone != null) {
            return _BuildMyShop(context,
                item: item.profileObjectCombine.myShopRespone,
                shpping: item.profileObjectCombine.shppingMyShopRespone);
          } else {
            return _BuildRegisterMyshop(context);
          }
        } else if (item is InfoCustomerLoading) {
          return _BuildMyShop(context,
              item: MyShopRespone(
                  image: item.profileObjectCombine.myShopRespone != null
                      ? item.profileObjectCombine.myShopRespone.image
                      : [],
                  name: "กำลังโหลด",
                  active: 0),
              shpping: item.profileObjectCombine.shppingMyShopRespone);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _BuildRegisterMyshop(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(3.0.w),
                color: Colors.grey.shade300,
                child: Text(
                  "You can open a shop By filling in the information below to open your own shop ",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Container(
                padding: EdgeInsets.all(5.0.w),
                child: Column(
                  children: [
                    BuildEditText(
                        head: LocaleKeys.shop_name.tr(),
                        EnableMaxLength: false,
                        hint: LocaleKeys.set_default.tr() +
                            LocaleKeys.shop_name.tr(),
                        controller: nameshopController,
                        onChanged: (String x) => _checkError(),
                        inputType: TextInputType.text),
                    SizedBox(
                      height: 20,
                    ),
                    BuildEditText(
                        head: LocaleKeys.shop_detail.tr(),
                        EnableMaxLength: false,
                        hint: LocaleKeys.set_default.tr() +
                            LocaleKeys.shop_detail.tr(),
                        controller: slugshopController,
                        onChanged: (String x) => _checkError(),
                        inputType: TextInputType.text),
                    SizedBox(
                      height: 10,
                    ),
                    _buildButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildMyShop(BuildContext context,
      {MyShopRespone item, ShppingMyShopRespone shpping}) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          SizedBox(
            height: 0.2.h,
          ),
          ExpandedSection(
            expand: shpping.data.isNotEmpty
                ? shpping.data[0].rates.length == 0
                    ? true
                    : false
                : false,
            child: Container(
              padding: EdgeInsets.all(2.0.w),
              color: ThemeColor.Warning(),
              child: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: ThemeColor.ColorSale(),
                  ),
                  SizedBox(
                    width: 2.0.w,
                  ),
                  Expanded(
                      child: Text(
                          "Alway protect yourself by completing your transactions within Naifarm.",
                          style: FunctionHelper.FontTheme(
                              color: ThemeColor.ColorSale(),
                              fontSize: SizeUtil.titleSmallFontSize().sp))),
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      onPressed: () {
                        // setState(() {
                        //   warning = false;
                        // });
                      })
                ],
              ),
            ),
          ),

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
                            sellOrder: SellOrder(
                                unpaid: 0,
                                shipping: 0,
                                cancel: 0,
                                confirm: 0,
                                delivered: 0,
                                failed: 0,
                                refund: 0)));
              } else {
                return _buildTabMenu(
                    context,
                    CustomerCountRespone(
                        sellOrder: SellOrder(
                            unpaid: 0,
                            shipping: 0,
                            cancel: 0,
                            confirm: 0,
                            delivered: 0,
                            failed: 0,
                            refund: 0)));
              }
            },
          ),
          ListMenuItem(
            icon: 'assets/images/svg/latest.svg',
            title: LocaleKeys.me_title_history_shop.tr(),
            iconSize: 7.0.w,
            onClick: () => AppRoute.ShopOrderHistory(context, 0),
          ),
          //  widget.IsLogin ? _BuildDivider() : SizedBox(),
          // widget.IsLogin
          //     ? ListMenuItem(
          //   icon: 'assets/images/svg/like_2.svg',
          //   iconSize:7.0.w,
          //   title: LocaleKeys.me_title_wallet.tr(),
          //   Message: "300 บาท",
          //   onClick: () => AppRoute.WithdrawMoney(context),
          // )
          //     : SizedBox(),
          _BuildDivider(),

          ListMenuItem(
            iconSize: 7.0.w,
            icon: 'assets/images/svg/editprofile.svg',
            title: LocaleKeys.me_title_my_product.tr(),
            onClick: () {
              if (shpping.data[0].rates.length == 0) {
                FunctionHelper.NaiFarmDialog(
                    context: context,
                    message:
                        "Please complete the shop information. Before handling products ",
                    onClick: () {
                      Navigator.of(context).pop();
                    });
              } else {
                AppRoute.MyProduct(context, item.id);
              }
            },
          ),
          _BuildDivider(),
          ListMenuItem(
            iconSize: 7.0.w,
            icon: 'assets/images/svg/delivery.svg',
            title: LocaleKeys.me_title_shipping.tr(),
            onClick: () {
              AppRoute.DeliveryMe(context);
            },
          ),
          _BuildDivider(),
          ListMenuItem(
              iconSize: 7.0.w,
              icon: 'assets/images/svg/money.svg',
              title: LocaleKeys.me_title_payment.tr(),
              onClick: () {
                AppRoute.PaymentMe(context);
              }),
          _BuildDivider(),
          ListMenuItem(
            iconSize: 6.5.w,
            icon: 'assets/images/svg/help.svg',
            title: LocaleKeys.me_title_help.tr(),
            onClick: () {
              AppRoute.SettingHelp(context);
            },
          ),
          _BuildDivider(num: 10),
          ListMenuItem(
            iconSize: 7.0.w,
            icon: 'assets/images/svg/work.svg',
            title: LocaleKeys.setting_account_title_shop.tr(),
            IsPhoto:
                "${item != null ? item.image != null ? item.image.isNotEmpty ? "${Env.value.baseUrl}/storage/images/${item.image[0].path}" : '' : '' : ''}",
            Message: item.name,
            onClick: () async {
              final result = await AppRoute.ShopProfile(context);
              if (result != null && result) {
                widget.onStatus(result);
              } else {
                widget.onStatus(false);
              }
            },
          ),
          SizedBox(height: 3.5.h),
          _buildBtnAddProduct(context, shpping)
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
              icon: 'assets/images/svg/status_delivery.svg',
              title: LocaleKeys.me_menu_ship.tr(),
              onClick: () {
                AppRoute.ShopOrderHistory(context, 1);
              },
              notification: count.sellOrder.confirm),
          TabMenu(
            icon: 'assets/images/svg/status_delivery.svg',
            title: LocaleKeys.me_menu_shipping.tr(),
            onClick: () {
              AppRoute.ShopOrderHistory(context, 2);
            },
            notification: count.sellOrder.shipping,
          ),
          TabMenu(
            icon: 'assets/images/svg/status_cancel.svg',
            title: LocaleKeys.me_menu_cancel_product.tr(),
            onClick: () {
              AppRoute.ShopOrderHistory(context, 4);
            },
            notification: count.sellOrder.cancel,
          ),
          // TabMenu(
          //   icon: 'assets/images/svg/status_restore.svg',
          //   title: LocaleKeys.me_menu_refund_product.tr(),
          //   onClick: (){AppRoute.ShopOrderHistory(context,5);},
          //   notification: count.sellOrder.refund,
          // )
        ],
      ),
    );
  }

  Widget _buildBtnAddProduct(
      BuildContext context, ShppingMyShopRespone shpping) {
    return Container(
      width: 60.0.w,
      height: 5.5.h,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            ThemeColor.secondaryColor(),
          ),
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.3),
          ),
        ),
        onPressed: () {
          if (shpping.data[0].rates.length == 0) {
            FunctionHelper.NaiFarmDialog(
                context: context,
                message:
                    "Please complete the shop information. Before handling products ",
                onClick: () {
                  Navigator.of(context).pop();
                });
          } else {
            AppRoute.ImageProduct(context, isactive: IsActive.NewProduct);
          }
        },
        child: Text(
          LocaleKeys.btn_add_product.tr(),
          style: FunctionHelper.FontTheme(
              color: Colors.white,
              fontSize: SizeUtil.titleFontSize().sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
        width: 60.0.w,
        height: 5.5.h,
        margin: EdgeInsets.all(15),
        child: _buildButtonItem(btnTxt: LocaleKeys.btn_continue.tr()));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          ThemeColor.secondaryColor(),
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        if (check) {
          Usermanager().getUser().then((value) => bloc.CreateMyShop(context,
              name: nameshopController.text,
              slug: slugshopController.text,
              description: slugshopController.text,
              token: value.token));
        }
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _BuildDivider({double num = 0.5}) {
    return Container(
      height: num,
      color: Colors.grey.shade300,
    );
  }

  void _checkError() {
    //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "ไม่ถูกต้อง",context: context);
    check = false;

    if (nameshopController.text != "" && slugshopController.text != "") {
      check = true;
    }
    setState(() {});
  }
}
