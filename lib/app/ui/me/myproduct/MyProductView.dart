import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/Available.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/Banned.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/InActive.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/SoldOut.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
import 'package:sizer/sizer.dart';

class MyProductView extends StatefulWidget {
  final int shopId;
  final int indexTab;
  final bool pushEvent;

  const MyProductView({Key key, this.shopId, this.indexTab,this.pushEvent}) : super(key: key);

  @override
  _MyProductViewState createState() => _MyProductViewState();
}

class _MyProductViewState extends State<MyProductView> {
  List<ProductModel> listProducts = ProductViewModel().getMyProducts();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UploadProductBloc bloc;
  int limit = 5;
  int page = 1;
  bool stepPage = false;
  int tabNum = 0;

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   if(widget.pushEvent){
    //     AppRoute.imageProduct(context, isactive: IsActive.NewProduct);
    //   }
    // });

  }

  init() {
    if (bloc == null) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.saveNowPage(0);


      /*  bloc.onSuccess.stream.listen((event)  {
          if(event is bool){
            bloc.ProductMyShopRes.add(bloc.ProductMyShopRes.value);
         }
       });

       bloc.onError.stream.listen((event) {
         FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
         Future.delayed(const Duration(milliseconds: 1000), () {
           Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: page.toString(),limit: 5,token: value.token));
         });
       });
*/
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.5.h),
            child: Container(
              child: AppBar(
                elevation: 0,
                toolbarHeight: 6.5.h,
                iconTheme: IconThemeData(
                  color: Colors.white, //change your color here
                ),
                backgroundColor: ThemeColor.primaryColor(),
                title: Text(
                  LocaleKeys.me_title_my_product.tr(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                      padding: EdgeInsets.only(
                          right: SizerUtil.deviceType == DeviceType.mobile
                              ? 0
                              : 3.0.w),
                      icon: Icon(
                        Icons.search,
                        size: SizeUtil.mediumIconSize().w,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        AppRoute.searchMyProductView(
                            context: context,
                            shopID: widget.shopId,
                            tabNum: tabNum);
                      }),
                  // PopupMenuButton(
                  //   child: Container(
                  //     padding: EdgeInsets.only(
                  //         right: SizeUtil.paddingCart().w,
                  //         left: SizeUtil.paddingItem().w),
                  //     child: Icon(
                  //       FontAwesome.ellipsis_v,
                  //       size: SizeUtil.mediumIconSize().w,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   itemBuilder: (context) {
                  //     return [
                  //       PopupMenuItem(
                  //         value: 0,
                  //         child: Row(
                  //           children: [
                  //             Padding(
                  //               padding: EdgeInsets.only(right: 5.0),
                  //               child: Icon(
                  //                 FontAwesome.tag,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             Text(
                  //               LocaleKeys.attributes_set.tr(),
                  //               style: FunctionHelper.fontTheme(
                  //                   fontSize: SizeUtil.titleFontSize().sp,
                  //                   fontWeight: FontWeight.w500),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       PopupMenuItem(
                  //         value: 1,
                  //         child: Row(
                  //           children: [
                  //             Padding(
                  //               padding: EdgeInsets.only(right: 5.0),
                  //               child: Icon(
                  //                 FontAwesome.ticket,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             Text(
                  //               LocaleKeys.coupon_coupon_title.tr(),
                  //               style: FunctionHelper.fontTheme(
                  //                   fontSize: SizeUtil.titleFontSize().sp,
                  //                   fontWeight: FontWeight.w500),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ];
                  //   },
                  //   onSelected: (int selectedValue) {
                  //     switch (selectedValue) {
                  //       case 0:
                  //         AppRoute.attribute(context: context);
                  //         break;
                  //       case 1:
                  //         AppRoute.coupons(
                  //             context: context, shopId: widget.shopId);
                  //         break;
                  //       default:
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                 
                  color: Colors.white,
                  child: DefaultTabController(
                    length: 4,
                    initialIndex: widget.indexTab,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeUtil.tabBarHeight().h,
                            child: Container(
                              child: TabBar(
                                physics: NeverScrollableScrollPhysics(),
                                indicator: MD2Indicator(
                                  indicatorSize: MD2IndicatorSize.normal,
                                  indicatorHeight: 0.5.h,
                                  indicatorColor: ThemeColor.colorSale(),
                                ),
                                isScrollable: false,
                                onTap: (value) {
                                  tabNum = value;
                                  NaiFarmLocalStorage.saveNowPage(value);
                                },
                                tabs: [
                                  _tab(
                                      title: LocaleKeys.shop_available.tr(),
                                      message: false),
                                  _tab(
                                      title: LocaleKeys.shop_sold_out.tr(),
                                      message: false),
                                  _tab(
                                      title: LocaleKeys.shop_banned.tr(),
                                      message: false),
                                  _tab(
                                      title: LocaleKeys.shop_inactive.tr(),
                                      message: false)
                                ],
                              ),
                            ),
                          ),
                          // create widgets for each tab bar here
                          Expanded(
                            child: TabBarView(
                              children: [
                                Available(
                                  shopId: widget.shopId,
                                  scaffoldKey: _scaffoldKey,
                                  searchTxt: "",
                                ),
                                SoldOut(
                                  shopId: widget.shopId,
                                  scaffoldKey: _scaffoldKey,
                                  searchTxt: "",
                                ),
                                Banned(
                                  shopId: widget.shopId,
                                  scaffoldKey: _scaffoldKey,
                                  searchTxt: "",
                                ),
                                InActive(
                                  shopId: widget.shopId,
                                  scaffoldKey: _scaffoldKey,
                                  searchTxt: "",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return Container(
        margin: EdgeInsets.only(top: 3.0.h, bottom: 3.0.h),
        width: 50.0.w,
        height: 5.0.h,
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
          onPressed: () async {
            // index==0?AppRoute.ProductAddType(context):AppRoute.ImageProduct(context);
            var result = await AppRoute.imageProduct(context,
                isactive: IsActive.NewProduct);
            if (result != null && result) {
              Usermanager().getUser().then((value) => bloc.getProductMyShop(
                  context,
                  page: "1",
                  limit: 5,
                  token: value.token));
            }
          },
          child: Text(
            LocaleKeys.btn_add_product.tr(),
            style: FunctionHelper.fontTheme(
                color: Colors.white,
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
        ));
  }

  Widget _tab({String title, bool message}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: FunctionHelper.fontTheme(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: Colors.black)),
          message
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 10,
                    height: 20,
                    color: ThemeColor.colorSale(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

/*buttonDialog(BuildContext context, {int shopId}) {
  showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dialog(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                AppRoute.attribute(context: context);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    LocaleKeys.attributes_set.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Dialog(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                AppRoute.coupons(context: context, shopId: shopId);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    LocaleKeys.coupon_coupon_title.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}*/
