import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'BuildIconShop.dart';
import 'CategoryMenu.dart';

enum Header_Type {
  barHome,
  barNoBackground,
  barNormal,
  barcartShop,
  barMap
}

class AppToobar extends PreferredSize {
  final Header_Type header_type;
  final String title;
  final Function onClick;
  final String icon;
  final bool isEnable_Search;
  final String locationTxt;
  final String hint;
  final Function(String) onSearch;
  final bool showBackBtn;

  const AppToobar(
      {this.onClick = null,
      this.icon = "",
      Key key,
      this.header_type,
      this.title = "",
      this.isEnable_Search = false,
      this.showBackBtn = true,
      this.locationTxt = "",
      this.hint = "",
      this.onSearch})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    if (header_type == Header_Type.barHome) {
      return BarHome(context);
    }  else if (header_type == Header_Type.barcartShop) {
      return BarCartShop(context);
    } else if (header_type == Header_Type.barNoBackground) {
      return barNoSearchNoTitle(context);
    } else if (header_type == Header_Type.barNormal) {
      return BarNormal(context);
    } else if (header_type == Header_Type.barMap) {
      return BarMap(context);
    }
  }

  Widget BarNormal(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0.3.w),
      decoration: new BoxDecoration(
        color: ThemeColor.primaryColor(),
        // borderRadius:  IsborderRadius?BorderRadius.only(
        //   topRight: const Radius.circular(30.0),
        //   topLeft: const Radius.circular(30.0),
        // ):BorderRadius.all(Radius.circular(0.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),

      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showBackBtn?IconButton(
                  icon: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios_rounded,color: Colors.white,),
                  onPressed: (){
                    onClick == null ? Navigator.of(context).pop() : onClick();
                  },
                ):SizedBox(width: 10.0.w,height: 10.0.w,),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        title,
                        style: FunctionHelper.FontTheme(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeUtil.titleFontSize().sp),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search_rounded,color: Colors.white,),
                  onPressed: (){
                    Usermanager().getUser().then((value) {
                    if (value.token != null) {
                    AppRoute.SearchHome(context);
                    } else {
                    AppRoute.Login(context);
                    }
                    });
                  },
                )

              ],
            ),


          ],
        ),
      ),
    );
  }



  Widget BarCartShop(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0.3.w),
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showBackBtn?IconButton(
                  icon: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios_rounded,color: Colors.white,),
                  onPressed: (){
                    onClick == null ? Navigator.of(context).pop() : onClick();
                  },
                ):SizedBox(width: 10.0.w,height: 10.0.w,),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        title,
                        style: FunctionHelper.FontTheme(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeUtil.titleFontSize().sp),
                      ),
                    ),
                  ),
                ),
                BuildIconShop()

              ],
            ),

            // setState(() {
            //   _categoryselectedIndex = val;
            //   _categoryselectedIndex!=0?AppRoute.CategoryDetail(context,_categoryselectedIndex-1):print(_categoryselectedIndex);
            // });
            //  Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));


          ],
        ),
      ),
    );
  }

  Widget barNoSearchNoTitle(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 15, left: 20, top: 10, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: SvgPicture.asset('assets/images/svg/back_black.svg',width: 7.0.w,height: 7.0.w,),
              onTap: () {
                onClick == null ? Navigator.of(context).pop() : onClick();

              },
            ),
            Container(
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setWidth(120),
              decoration: BoxDecoration(
                  color: ThemeColor.primaryColor(),
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: BuildIconShop(),
            )
          ],
        ),
      ),
      onTap: () {
        AppRoute.MyCart(context, true);
      },
    );
  }

  Widget BarMap(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 8, right: 14, left: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/images/svg/back_black.svg',
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildSearchMap(context),
              Visibility(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 8,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/svg/map.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
                visible: isEnable_Search,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BarHome(BuildContext context) {
    return Container(
      height: 13.0.h,
      padding: EdgeInsets.only(left: 0, right: 0.3.w),
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios_rounded,color: Colors.white,),
                  onPressed: (){
                    onClick == null ? Navigator.of(context).pop() : onClick();
                  },
                ),
                _buildSearch(context),
                BuildIconShop()

              ],
            ),

                // setState(() {
                //   _categoryselectedIndex = val;
                //   _categoryselectedIndex!=0?AppRoute.CategoryDetail(context,_categoryselectedIndex-1):print(_categoryselectedIndex);
                // });
                //  Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));


          ],
        ),
      ),
    );
  }

  Expanded _buildSearch(BuildContext context) {
    /* final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 10,
      ),
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    );

    final sizeIcon = BoxConstraints(
      minWidth: 35,
      minHeight: 35,
    );*/

    return Expanded(
      child: Container(
        height: 5.2.h,
        decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(Radius.circular(40.0))),
        child: Container(
        padding: EdgeInsets.only(left: 1, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              child: SvgPicture.asset(
                'assets/images/svg/search.svg',
                color: Colors.black,
                width: 4.0.w,
                height: 4.0.w,
              ),
              visible: isEnable_Search,
            ),
            Expanded(
                child: InkWell(
              child: isEnable_Search
                  ? SizedBox()
                  : Container(
                      padding: EdgeInsets.only(left: 4.0.w,bottom: 0.3.h),
                      child: TextField(
                        style: FunctionHelper.FontTheme(
                            color: Colors.black,
                            fontSize: SizeUtil.titleSmallFontSize().sp),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: hint,
                          hintStyle: FunctionHelper.FontTheme(
                              color: Colors.grey,
                              fontSize: SizeUtil.titleSmallFontSize().sp),
                        ),
                        onChanged: (String s) =>
                            onSearch != null ? onSearch(s) : null,
                      ),
                    ),
              onTap: () {
                AppRoute.SearchHome(context);
              },
            )),
            SvgPicture.asset(
              'assets/images/svg/search_photo.svg',
              color: Color(ColorUtils.hexToInt('#c7bfbf')),
              width: 5.0.w,
              height: 5.0.w,
            )
          ],
        )),
      ),
    );
  }

  Expanded _buildSearchMap(BuildContext context) {
    TextEditingController txtController = TextEditingController();
    txtController.text = locationTxt.toString().trim().replaceAll("null", "");

    /*final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 10,
      ),
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    );

    final sizeIcon = BoxConstraints(
      minWidth: 35,
      minHeight: 35,
    );*/
    return Expanded(
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(40.0))),
        child: InkWell(
          child: Container(
            padding: EdgeInsets.only(right: 10, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/images/svg/fontSize: SizeUtil.titleSmallFontSize().spsvg',
                  color: Colors.black.withOpacity(0.5),
                  width: 15,
                  height: 15,
                ),
                Expanded(
                    child: !isEnable_Search
                        ? Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(txtController.text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FunctionHelper.FontTheme(
                                    color: Colors.black,
                                    fontSize:
                                        SizeUtil.titleSmallFontSize().sp)),
                          )
                        : Container(
                            padding: EdgeInsets.only(left: 5, top: 10),
                            child: TextFormField(
                              style: FunctionHelper.FontTheme(
                                  color: Colors.black,
                                  fontSize: SizeUtil.titleSmallFontSize().sp),
                              enabled: true,
                              maxLines: 1,
                              initialValue: locationTxt.toString().length > 30
                                  ? locationTxt
                                          .toString()
                                          .trim()
                                          .substring(0, 30) +
                                      "..."
                                  : "",
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: hint,
                                hintStyle: FunctionHelper.FontTheme(
                                    color: Colors.grey,
                                    fontSize: SizeUtil.titleSmallFontSize().sp),
                              ),
                              onChanged: (String s) =>
                                  onSearch != null ? onSearch(s) : null,
                            ),
                          )),
                SvgPicture.asset(
                  'assets/images/svg/search.svg',
                  color: ThemeColor.ColorSale(),
                  width: 25,
                  height: 25,
                )
              ],
            ),
          ),
          onTap: () {
            AppRoute.SearchMap(context, txtController.text);
          },
        ),
      ),
    );
  }
}
