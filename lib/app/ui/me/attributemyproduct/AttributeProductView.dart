import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/AttributeRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class AttributeProductView extends StatefulWidget {
  final ProductShopItemRespone productMyShopRespone;

  const AttributeProductView({Key key, this.productMyShopRespone})
      : super(key: key);

  @override
  _AttributeProductViewState createState() => _AttributeProductViewState();
}

class _AttributeProductViewState extends State<AttributeProductView> with RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UploadProductBloc bloc;
  // HashMap attrMap = new HashMap<int, String>();

  @override
  void initState() {
    super.initState();

  }

  init() {
    //initialValue();

    if (bloc == null) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));

      if (widget.productMyShopRespone != null) {
        bloc.productRes.add(widget.productMyShopRespone);
      }

      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    Usermanager().getUser().then((value) => bloc.getProductIDMyShop(context,
        token: value.token, productId: widget.productMyShopRespone.id));
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.grey.shade300,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(7.0.h),
                  child: AppBar(
                    elevation: 0,
                    toolbarHeight: 6.5.h,
                    iconTheme: IconThemeData(
                      color: Colors.white, //change your color here
                    ),
                    backgroundColor: ThemeColor.primaryColor(),
                    title: Text(
                      LocaleKeys.attributes_set.tr(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w600),
                    ),
                    centerTitle: true,
                    actions: [
                      Container(
                        padding: EdgeInsets.only(
                            right: SizeUtil.paddingCart().w,
                            left: SizeUtil.paddingItem().w),
                        child: IconButton(
                          onPressed: () async {
                            var result = await AppRoute.attributeProductAdd(
                                context: context,
                                productMyShopRespone:
                                    widget.productMyShopRespone);
                            if (result != null && result) {
                              // Usermanager().getUser().then(
                              //         (value) => bloc.getAttributeMyShop(context, token: value.token));
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            size: SizeUtil.mediumIconSize().w,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                body: StreamBuilder(
                    stream: bloc.productRes.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var item = snapshot.data as ProductShopItemRespone;
                        return Column(
                          children: [
                            Column(
                                children: List.generate(
                              item.inventories[0].attributes.length,
                              (index) => Container(
                                  margin: EdgeInsets.only(bottom: 0.5.h),
                                  child: _buildListAttr(index, item)),
                            )),
                            SizedBox(
                              height: 1.0.h,
                            ),
                          ],
                        );
                      } else
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/json/boxorder.json',
                                  height: 70.0.w, width: 70.0.w, repeat: false),
                              Text(LocaleKeys.search_product_not_found.tr(),
                                  style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 2.0.h,
                              ),
                            ],
                          ),
                        );
                    }))));
  }

  Widget _buildListAttr(int index, ProductShopItemRespone item) {
    return InkWell(
      onTap: () {
        AppRoute.attributeProductEdit(
            context: context,
        value:item.inventories[0].attributes[index].values[0].value ,name: item.inventories[0].attributes[index].attributes[0].name,nameId: item.inventories[0].attributes[index].attributes[0].id);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.only(
            right: 2.0.w,
            left: 3.5.w,
            top: SizeUtil.paddingMenuItem().h,
            bottom: SizeUtil.paddingMenuItem().h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("${LocaleKeys.attributes_index.tr()} ${index+1}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        color: Colors.black)),

                Text(" (${item.inventories[0].attributes[index].attributes[0].name},${item.inventories[0].attributes[index].values[0].value})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        color: Colors.grey)),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.withOpacity(0.7),
              size: SizeUtil.ratingSize().w,
            )
          ],
        ),
      ),
    );
  }

// initialValue() {
//   if (widget.productMyShopRespone.inventories[0].attributes.length != 0) {
//     for (var item in widget.productMyShopRespone.inventories[0].attributes)
//       attrMap[item.attributes[0].id] = item.attributes[0].name;
//   }
// }
}
