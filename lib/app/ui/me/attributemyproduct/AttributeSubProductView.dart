import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class AttributeSubProductView extends StatefulWidget {

  const AttributeSubProductView({
    Key key,
  }) : super(key: key);

  @override
  _AttributeSubProductViewState createState() => _AttributeSubProductViewState();
}

class _AttributeSubProductViewState extends State<AttributeSubProductView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UploadProductBloc bloc;
  final onAddAttr = BehaviorSubject<bool>();
  HashMap attributeMap = new HashMap<int, String>();

  @override
  void initState() {
    super.initState();
  }

  init() {
    onAddAttr.add(false);
    if (bloc == null) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));

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

      Usermanager().getUser().then(
          (value) => bloc.getAttributeMyShop(context, token: value.token));
    }
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
            preferredSize: Size.fromHeight(6.5.h),
            child: PreferredSize(
              preferredSize: Size.fromHeight(6.5.h),
              child: AppToobar(
                title: LocaleKeys.attributes_set.tr(),
                icon: "",
                isEnableSearch: false,
                headerType: Header_Type.barNormal,
              ),
            ),
          ),
          body: Container()
        )));
  }

  Widget _buildAttrCard() {
    return Column(
      children: List.generate(
        attributeMap.length,
        (index) =>
          Column(
            children: [
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    right: 2.0.w,
                    left: 3.5.w,
                    top: SizeUtil.paddingMenuItem().h,
                    bottom: SizeUtil.paddingMenuItem().h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(attributeMap.values.elementAt(index),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        color: Colors.black)),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.withOpacity(0.7),
                      size: SizeUtil.ratingSize().w,
                    )
                  ],
                ),
              ),
              SizedBox(height: 0.5.h,)
            ],
          ),
      ),
    );
  }

  Widget _buildAddBtn() {
    return StreamBuilder(
        stream: bloc.attributeMyShop.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var item = (snapshot.data as MyShopAttributeRespone);
            return _buildAttrAddBtn(myShopAttributeRespone: item);
          } else {
            return SizedBox();
          }
        });
  }

  Widget _buildAttrAddBtn({MyShopAttributeRespone myShopAttributeRespone}) {
    return Container(
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
                myShopAttributeRespone.data.length != 0
                    ? ThemeColor.secondaryColor()
                    : Colors.grey,
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () {
              if (myShopAttributeRespone.data.length != 0) {
                Platform.isAndroid
                    ? FunctionHelper.dropDownAndroid(
                        context,
                        List.generate(myShopAttributeRespone.data.length,
                            (index) => myShopAttributeRespone.data[index].name),
                        onTap: (int index) {
                        attributeMap[myShopAttributeRespone.data[index].id] =
                            myShopAttributeRespone.data[index].name;
                        onAddAttr.add(true);
                      })
                    : FunctionHelper.dropDownIOS(
                        context,
                        List.generate(myShopAttributeRespone.data.length,
                            (index) => myShopAttributeRespone.data[index].name),
                        onTap: (int index) {
                          attributeMap[myShopAttributeRespone.data[index].id] =
                              myShopAttributeRespone.data[index].name;
                          onAddAttr.add(true);
                        },
                      );
              }
            },
            child: Text(
              LocaleKeys.attributes_add.tr(),
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
              //   ),
              // ),
              // )
            )));
  }


}
