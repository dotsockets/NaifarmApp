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
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
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
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      /*bloc.onSuccessDel.stream.listen((event) {
        Usermanager().getUser().then((value) => bloc.GetAttributeMyShop(token: value.token));
      });*/
      Usermanager().getUser().then((value) => bloc.GetAttributeMyShop(token: value.token));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    Usermanager()
        .getUser()
        .then((value) => bloc.GetAttributeMyShop(token: value.token));
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
            child: AppToobar(
              title: LocaleKeys.attributes_set.tr(),
              icon: "",
              isEnable_Search: false,
              header_type: Header_Type.barNormal,
            ),
          ),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: bloc.attributeMyShop.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var item = (snapshot.data as MyShopAttributeRespone);
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
                                                  txt: item.data[index].name,
                                                  id: item.data[index].id),
                                              secondaryActions: <Widget>[
                                                IconSlideAction(
                                                  color: ThemeColor.secondaryColor(),
                                                  iconWidget: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Lottie.asset('assets/json/edit.json',
                                                          height: 4.5.h,
                                                          width: 4.5.h,
                                                          repeat: true),
                                                      Text(
                                                        LocaleKeys.cart_edit.tr(),
                                                        style: FunctionHelper.FontTheme(
                                                            color: Colors.white,
                                                            fontSize: SizeUtil.titleSmallFontSize().sp,
                                                            fontWeight: FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    AppRoute.AttributeEdit(idAttr: item.data[index].id,context: context,nameAttr:item.data[index].name );
                                                  },
                                                ),
                                                IconSlideAction(
                                                  color: ThemeColor.ColorSale(),
                                                  iconWidget: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(top: 0.5.h),
                                                        child: Lottie.asset('assets/json/delete.json',
                                                            height: 3.0.h,
                                                            width: 3.0.h,
                                                            repeat: true),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 0.5.h),
                                                        child: Text(
                                                          LocaleKeys.cart_del.tr(),
                                                          style: FunctionHelper.FontTheme(
                                                              color: Colors.white,
                                                              fontSize: SizeUtil.titleSmallFontSize().sp,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    //bloc.attributeMyShop.value.data.removeAt(index);
                                                    //bloc.attributeMyShop.add(bloc.attributeMyShop.value);
                                                    Usermanager().getUser().then((value) => bloc.DELETEAttributeMyShop(id: item.data[index].id, token: value.token));
                                                    },
                                                ),
                                              ],
                                            ),
                                        index != item.data.length - 1 ? SizedBox(height: 0.5.h,) : SizedBox()
                                      ],
                                    )
                                    ),
                              ),
                              _buildButton()
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
                                      style: FunctionHelper.FontTheme(
                                          fontSize: SizeUtil.titleFontSize().sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              _buildButton()
                            ],
                          );
                  } else {
                    return StreamBuilder(
                        stream: bloc.onError.stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 15.0.h,
                              color: Colors.white,
                              child: Center(
                                child: Text(LocaleKeys.search_product_not_found.tr(),
                                    style: FunctionHelper.FontTheme(
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.w500)),
                              ),
                            );
                          }else{
                            return SizedBox();
                          }
                        }
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({String txt, int id}) {
    return InkWell(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.all(5.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(txt,
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: ThemeColor.primaryColor())),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade400,
                    size: 5.0.w,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        AppRoute.AttributeDetail(context: context, idAttr: id);
      },
    );
  }

  /* Widget _buildLine(){
    return Container(
      height: 0.1.w,
      color: Colors.black.withOpacity(0.4),
    );
  }*/
  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.only(top: 2.0.h),
      child: Center(
        child: FlatButton(
          minWidth: 50.0.w,
          height: 5.0.h,
          color: ThemeColor.secondaryColor(),
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () {
            AppRoute.AttributeEdit(context: context,nameAttr: "",idAttr: 0);
          },
          child: Text(
            LocaleKeys.attributes_add.tr(),
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
