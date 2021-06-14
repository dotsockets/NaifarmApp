import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/AttributeRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class AttributeView extends StatefulWidget {
  @override
  _AttributeViewState createState() => _AttributeViewState();
}

class _AttributeViewState extends State<AttributeView> with RouteAware {
  UploadProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  init() {
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
      _getAttr();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    _getAttr();
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
                      var result = await AppRoute.attributeAdd(context: context);
                      if (result) {
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
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: bloc.attributeMyShop.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var item = (snapshot.data as AttributeRespone);
                    return item.data.length != 0
                        ? Column(
                            children: [
                              Column(
                                children: List.generate(
                                    item.data.length,
                                    (index) => Column(
                                          children: [
                                            Slidable(
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.25,
                                              child: _buildItem(
                                                  name: item.data[index].name,
                                                  id: item.data[index].id),
                                              secondaryActions: <Widget>[
                                                IconSlideAction(
                                                  color: ThemeColor
                                                      .secondaryColor(),
                                                  iconWidget: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Lottie.asset(
                                                          'assets/json/edit.json',
                                                          height: (SizeUtil
                                                                      .iconSmallSize() -
                                                                  0.5)
                                                              .h,
                                                          width: (SizeUtil
                                                                      .iconSmallSize() -
                                                                  0.5)
                                                              .h,
                                                          repeat: true),
                                                      Text(
                                                        LocaleKeys.cart_edit
                                                            .tr(),
                                                        style: FunctionHelper
                                                            .fontTheme(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: SizeUtil
                                                                        .titleSmallFontSize()
                                                                    .sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    AppRoute.attributeEdit(
                                                        idAttr:
                                                            item.data[index].id,nameAttr:  item.data[index].name,
                                                        context: context,);
                                                  },
                                                ),
                                                IconSlideAction(
                                                  color: ThemeColor.colorSale(),
                                                  iconWidget: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 0.5.h),
                                                        child: Lottie.asset(
                                                            'assets/json/delete.json',
                                                            height: SizeUtil
                                                                    .imgSmallWidth()
                                                                .h,
                                                            width: SizeUtil
                                                                    .imgSmallWidth()
                                                                .h,
                                                            repeat: true),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 0.5.h),
                                                        child: Text(
                                                          LocaleKeys.cart_del
                                                              .tr(),
                                                          style: FunctionHelper
                                                              .fontTheme(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      SizeUtil.titleSmallFontSize()
                                                                          .sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    //bloc.attributeMyShop.value.data.removeAt(index);
                                                    //bloc.attributeMyShop.add(bloc.attributeMyShop.value);
                                                    Usermanager()
                                                        .getUser()
                                                        .then((value) => bloc
                                                            .deleteAttributeMyShop(
                                                                context,
                                                                id: item
                                                                    .data[index]
                                                                    .id,
                                                                token: value
                                                                    .token));
                                                  },
                                                ),
                                              ],
                                            ),
                                            index != item.data.length - 1
                                                ? SizedBox(
                                                    height: 0.5.h,
                                                  )
                                                : SizedBox()
                                          ],
                                        )),
                              ),
                              //_buildButton()
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 15.0.h,
                                color: Colors.white,
                                child: Center(
                                  child: Text(LocaleKeys.attributes_empty.tr(),
                                      style: FunctionHelper.fontTheme(
                                          fontSize: SizeUtil.titleFontSize().sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              //_buildButton()
                            ],
                          );
                  } else {
                    return StreamBuilder(
                        stream: bloc.onError.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                    LocaleKeys.search_product_not_found.tr(),
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.w500)),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        });
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({String name, int id}) {
    return InkWell(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.all(SizeUtil.iconSmallSize().w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name,
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: ThemeColor.primaryColor())),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade400,
                    size: SizeUtil.imgMedWidth().w,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        AppRoute.attributeEdit(
          idAttr: id,
          nameAttr: name,
          context: context,);
      },
    );
  }

_getAttr(){
  Usermanager().getUser().then(
          (value) => bloc.getAttributeMyShop(context, token: value.token));
}
}
