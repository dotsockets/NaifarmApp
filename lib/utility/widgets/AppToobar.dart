import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'BuildIconShop.dart';

enum Header_Type { barHome, barNoBackground, barNormal, barcartShop, barMap }

class AppToobar extends PreferredSize {
  final Header_Type header_type;
  final String title;
  final Function onClick;
  final String icon;
  final isEnable_Search;
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
    } else if (header_type == Header_Type.barcartShop) {
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
      child: AppBar(
        leading: Visibility(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () =>
                onClick == null ? Navigator.of(context).pop() : onClick(),
          ),
          visible: showBackBtn,
        ),
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: icon != ""
                  ? SvgPicture.asset(
                      icon,
                      color: Colors.white,
                      width: 30,
                      height: 30,
                    )
                  : Container(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 30,
                      )),
            ),
            onTap: () {
              AppRoute.SearchHome(context);
            },
          ),
        ],
        backgroundColor: ThemeColor.primaryColor(),
        title: Center(
          child: Text(
            title,
            style: FunctionHelper.FontTheme(
                color: Colors.black,
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget BarCartShop(BuildContext context) {
    return Container(
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          isEnable_Search
              ? Container(
                  margin: EdgeInsets.only(bottom: 5, right: 5),
                  child: GestureDetector(
                    child: SvgPicture.asset('assets/images/svg/search.svg',
                        color: Colors.white),
                    onTap: () {
                      onClick();
                    },
                  ),
                )
              : SizedBox(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: BlocBuilder<CustomerCountBloc, CustomerCountState>(
              builder: (_, count) {
                if (count is CustomerCountLoaded) {
                  return BuildIconShop(
                    size: 7.0.w,
                    notification: count.countLoaded.notification.unreadCustomer,
                  );
                } else {
                  return BuildIconShop(
                    size: 7.0.w,
                    notification: 0,
                  );
                }
              },
            ),

          )
        ],
        backgroundColor: ThemeColor.primaryColor(),
        title: Container(
          padding: EdgeInsets.only(left: 30),
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
              child: SvgPicture.asset('assets/images/svg/back_black.svg'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Container(
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setWidth(120),
              decoration: BoxDecoration(
                  color: ThemeColor.primaryColor(),
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: BuildIconShop(
                size: ScreenUtil().setWidth(65),
                notification: 0,
              ),
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
      padding: EdgeInsets.only(
          top: 0.5.h,
          bottom: 0.5.h,
          left: isEnable_Search ? 15 : 10,
          right: 0.3.w),
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              child: Container(
                child: GestureDetector(
                  child: SvgPicture.asset(
                    'assets/images/svg/back_black.svg',
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              visible: isEnable_Search ? false : true,
            ),
            _buildSearch(isEnable_Search ? false : true, context),
            BlocBuilder<CustomerCountBloc, CustomerCountState>(
              builder: (_, count) {
                if (count is CustomerCountLoaded) {
                  return BuildIconShop(
                    notification: count.countLoaded.notification.unreadCustomer,
                    size: 3.0.h,
                  );
                } else {
                  return BuildIconShop(
                    notification: 0,
                    size: 3.0.h,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildSearch(bool isEditable, BuildContext context) {
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
      height: 4.6.h,
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(40.0))),
      child: Container(
          padding: EdgeInsets.only(left: 5, right: 11, bottom: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                child: SvgPicture.asset(
                  'assets/images/svg/search.svg',
                  color: Colors.black,
                  width: 7.0.w,
                  height: 7.0.w,
                ),
                visible: isEnable_Search,
              ),
              Expanded(
                  child: InkWell(
                child: isEnable_Search
                    ? SizedBox(
                        height: 40,
                      )
                    : Container(
                        padding: EdgeInsets.only(left: 15, bottom: 4),
                        child: TextField(
                          style: FunctionHelper.FontTheme(
                              color: Colors.black,
                              fontSize: SizeUtil.titleSmallFontSize().sp),
                          enabled: isEditable,
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
          )

          /* InkWell(
          child: TextField(
            enabled: isEditable,
            decoration: InputDecoration(
              focusedBorder: border,
              enabledBorder: border,
              isDense: true,
            // hintText: "search",
              hintStyle: TextStyle(
                fontSize: SizeUtil.titleFontSize().sp,
                color: Colors.black,
              ),
              prefixIcon: Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset('assets/images/svg/search.svg',color: Colors.black),
                ),
                visible: isEnable_Search,
              ),
              prefixIconConstraints: sizeIcon,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(top: 4,bottom: 4,right: 10),
                child: SvgPicture.asset('assets/images/svg/search_photo.svg',color: Color(ColorUtils.hexToInt('#c7bfbf'))),
              ),
              suffixIconConstraints: sizeIcon,
              filled: true
            ),
          ),
          onTap: (){AppRoute.SearchHome(context);},
        ),*/
          ),
    ));
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
