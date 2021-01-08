import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';


class MyshopView extends StatefulWidget {

  final bool IsLogin;
  CustomerInfoRespone  customerInfoRespone;
  final MyShopRespone myShopRespone;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onStatus;


  MyshopView({Key key, this.IsLogin,this.customerInfoRespone,this.scaffoldKey, this.myShopRespone, this.onStatus}) : super(key: key);

  @override
  _MyshopViewState createState() => _MyshopViewState();
}

class _MyshopViewState extends State<MyshopView> {

  MemberBloc bloc;

  TextEditingController nameshopController = TextEditingController();
  TextEditingController slugshopController = TextEditingController();
  bool check = true;

  void _init(){
    if(null == bloc){
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: widget.scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
          setState(() {});
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    _init();

    if(widget.customerInfoRespone!=null && widget.customerInfoRespone.shop!=null || bloc.onSuccess.value!=null){
      return _BuildMyShop(context);
    }else{
      return _BuildRegisterMyshop(context);
    }

  }

  Widget _BuildRegisterMyshop(BuildContext context){
    return Container(
      color: Colors.grey.shade300,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            children: [
              BuildEditText(
                  head: LocaleKeys.shop_name.tr(),
                  EnableMaxLength: false,
                  hint: LocaleKeys.set_default.tr()+LocaleKeys.shop_name.tr(),
                  controller: nameshopController,
                  onChanged: (String x)=>_checkError(),
                  inputType: TextInputType.text),
              SizedBox(height: 20,),
              BuildEditText(
                  head: LocaleKeys.shop_detail.tr(),
                  EnableMaxLength: false,
                  hint: LocaleKeys.set_default.tr()+LocaleKeys.shop_detail.tr(),
                  controller: slugshopController,
                  onChanged: (String x)=>_checkError(),
                  inputType: TextInputType.text),
              SizedBox(height: 10,),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildMyShop(BuildContext context){
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          _buildTabMenu(context),
          ListMenuItem(
            icon: 'assets/images/svg/latest.svg',
            title: LocaleKeys.me_title_history_shop.tr(),
            iconSize: 8.0.w,
            onClick: () => AppRoute.MyShophistory(context,0),
          ),
          widget.IsLogin ? _BuildDivider() : SizedBox(),
          widget.IsLogin
              ? ListMenuItem(
            icon: 'assets/images/svg/like_2.svg',
            iconSize: 8.0.w,
            title: LocaleKeys.me_title_wallet.tr(),
            Message: "300 บาท",
            onClick: () => AppRoute.WithdrawMoney(context),
          )
              : SizedBox(),
          widget.IsLogin ? _BuildDivider() : SizedBox(),
          widget.IsLogin
              ? ListMenuItem(
            iconSize: 8.0.w,
            icon: 'assets/images/svg/editprofile.svg',
            title: LocaleKeys.me_title_my_product.tr(),
            onClick: () {
              AppRoute.MyProduct(context);
            },
          )
              : SizedBox(),
          widget.IsLogin ? _BuildDivider() : SizedBox(),
          widget.IsLogin
              ? ListMenuItem(
            iconSize: 8.0.w,
            icon: 'assets/images/svg/delivery.svg',
            title: LocaleKeys.me_title_shipping.tr(),
            onClick: () {
              AppRoute.DeliveryMe(context);
            },
          )
              : SizedBox(),
          _BuildDivider(),
          ListMenuItem(
              iconSize: 8.0.w,
              icon: 'assets/images/svg/money.svg',
              title: LocaleKeys.me_title_payment.tr(),
              onClick: () {
                AppRoute.PaymentMe(context);
              }),
          _BuildDivider(),
          ListMenuItem(
            iconSize: 8.0.w,
            icon: 'assets/images/svg/help.svg',
            title: LocaleKeys.me_title_help.tr(),
            onClick: () {
              AppRoute.SettingHelp(context);
            },
          ),
          _BuildDivider(num: 10),
          ListMenuItem(
            icon: 'assets/images/svg/help.svg',
            title: "ตั้งค่าข้อมูลร้านค้า",
            IsPhoto: "${widget.myShopRespone.image!=null?"${Env.value.baseUrl}/storage/images/${widget.myShopRespone.image[0].path}":''}",
            Message: widget.myShopRespone.name,
            onClick: () async {

              final result = await AppRoute.ShopProfile(context);

              if(result!=null && result){
                widget.onStatus(result);
              }else{
                widget.onStatus(false);
              }
            },
          ),
          SizedBox(height: 30),
          _buildBtnAddProduct(context)
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
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }


  Widget _buildButton() {
    return Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: _buildButtonItem(btnTxt: LocaleKeys.continue_btn.tr())));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return FlatButton(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color:!check? ThemeColor.ColorSale()
          : Colors.grey.shade400,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {

           Usermanager().getUser().then((value) => bloc.CreateMyShop(name: nameshopController.text,slug: slugshopController.text,description: slugshopController.text,token: value.token));
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _BuildDivider({double num=0.5}) {
    return Container(
      height: num,
      color: Colors.grey.shade300,
    );
  }

  void _checkError() {
    //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "ไม่ถูกต้อง",context: context);
    check = true;

    if(nameshopController.text!="" && slugshopController.text!=""){
      check = false;
    }
    setState(() {});
  }
}
