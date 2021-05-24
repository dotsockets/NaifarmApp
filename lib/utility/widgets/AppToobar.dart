import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'BuildIconShop.dart';

enum Header_Type { barHome, barNoBackground, barNormal, barcartShop, barMap }

class AppToobar extends PreferredSize {
  final Header_Type headerType;
  final String title;
  final Function onClick;
  final String icon;
  final bool isEnableSearch;
  final String locationTxt;
  final String hint;
  final Function(String) onSearch;
  final bool showBackBtn;
  final bool showCartBtn;
  final Function onTab;

  const AppToobar(
      {this.onClick,
      this.icon = "",
      Key key,
      this.headerType,
      this.title = "",
      this.isEnableSearch = true,
      this.showCartBtn = true,
      this.showBackBtn = true,
      this.locationTxt = "",
      this.hint = "",
      this.onSearch,
      this.onTab})
      // ignore: missing_required_param
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    if (headerType == Header_Type.barHome) {
      return barHome(context);
    } else if (headerType == Header_Type.barcartShop) {
      return barCartShop(context);
    } else if (headerType == Header_Type.barNoBackground) {
      return barNoSearchNoTitle(context);
    } else if (headerType == Header_Type.barNormal) {
      return barNormal(context);
    } else /*if (headerType == Header_Type.barMap)*/ {
      return barMap(context);
    }
  }

  Widget barNormal(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0.3.w),
      decoration: new BoxDecoration(
        color: ThemeColor.primaryColor(),
        // borderRadius:  IsborderRadius?BorderRadius.only(
        //   topRight: const Radius.circular(30.0),
        //   topLeft: const Radius.circular(30.0),
        // ):BorderRadius.all(Radius.circular(0.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showBackBtn
                  ? Container(
                      width: 10.0.w,
                      height: 10.0.w,
                      child: IconButton(
                        icon: Icon(
                          Platform.isAndroid
                              ? Icons.arrow_back
                              : Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: SizeUtil.iconSmallSize().w,
                        ),
                        onPressed: () {
                          onClick == null
                              ? Navigator.of(context).pop()
                              : onClick();
                        },
                      ),
                    )
                  : SizedBox(
                      width: 10.0.w,
                      height: 10.0.w,
                    ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      title,
                      style: FunctionHelper.fontTheme(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtil.titleFontSize().sp),
                    ),
                  ),
                ),
              ),
              isEnableSearch
                  ? Container(
                      width: 10.0.w,
                      height: 10.0.w,
                      child: IconButton(
                        icon: Icon(Icons.search_rounded,
                            color: Colors.white,
                            size: SizeUtil.iconSmallSize().w),
                        onPressed: () {
                          AppRoute.searchHome(context);
                        },
                      ),
                    )
                  : SizedBox(
                      width: 10.0.w,
                      height: 10.0.w,
                    )
            ],
          ),
        ],
      ),
    );
  }

  Widget barCartShop(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(left: 0, right: 0.3.w),
          color: ThemeColor.primaryColor(),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    showBackBtn
                        ? Container(
                            width: 12.0.w,
                            height: 10.0.w,
                            child: IconButton(
                              icon: Icon(
                                Platform.isAndroid
                                    ? Icons.arrow_back
                                    : Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: SizeUtil.iconSmallSize().w,
                              ),
                              onPressed: () {
                                onClick == null
                                    ? Navigator.of(context).pop()
                                    : onClick();
                              },
                            ),
                          )
                        : SizedBox(
                            width: 12.0.w,
                            height: 10.0.w,
                          ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            title,
                            style: FunctionHelper.fontTheme(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeUtil.titleFontSize().sp),
                          ),
                        ),
                      ),
                    ),
                    showCartBtn
                        ? Container(
                            padding: EdgeInsets.only(
                                right: SizeUtil.paddingCart().w,
                                left: SizeUtil.paddingItem().w),
                            child: BuildIconShop())
                        : SizedBox(
                            width: 12.0.w,
                            height: 10.0.w,
                          ),
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
        ),
      ],
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
              child: Image.asset(
                'assets/images/png/back_black.png',
                width: 7.0.w,
                height: 7.0.w,
              ),
              onTap: () {
                onClick == null ? Navigator.of(context).pop() : onClick();
              },
            ),
            Container(
              width: 20.0.w,
              height: 20.0.w,
              decoration: BoxDecoration(
                  color: ThemeColor.primaryColor(),
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: BuildIconShop(),
            )
          ],
        ),
      ),
      onTap: () {
        AppRoute.myCart(context, true);
      },
    );
  }

  Widget barMap(BuildContext context) {
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
                child: Image.asset(
                  'assets/images/png/back_black.png',
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
                  child: Image.asset(
                    'assets/images/png/map.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                visible: isEnableSearch,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget barHome(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding:
              EdgeInsets.only(left: 0, right: 0.3.w, bottom: 1.5.h, top: 1.0.h),
          color: ThemeColor.primaryColor(),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                    right: SizeUtil.paddingItem().w,
                    left: SizeUtil.paddingItem().w),
                child: Container(
                  child: IconButton(
                    icon: Icon(
                        Platform.isAndroid
                            ? Icons.arrow_back
                            : Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: SizeUtil.iconSmallSize().w),
                    onPressed: () {
                      onClick == null ? Navigator.of(context).pop() : onClick();
                    },
                  ),
                ),
              ),
              _buildSearch(context),
              showCartBtn
                  ? Container(
                      padding: EdgeInsets.only(
                          right: SizeUtil.paddingCart().w,
                          left: SizeUtil.paddingItem().w),
                      child: BuildIconShop())
                  : IconButton(
                      icon: Icon(
                        FontAwesome.ellipsis_v,
                        size: SizeUtil.mediumIconSize().w,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        onTab();
                      },
                    )
            ],
          ),
        )
      ],
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
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(40.0))),
        child: Container(
            padding: EdgeInsets.only(left: 1, right: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  child: Image.asset(
                    'assets/images/png/search.png',
                    color: Colors.black,
                    width: 4.0.w,
                    height: 4.0.w,
                  ),
                  visible: isEnableSearch,
                ),
                Expanded(
                    child: InkWell(
                  child: isEnableSearch
                      ? SizedBox()
                      : Container(
                          padding: EdgeInsets.only(left: 4.0.w, bottom: 0.3.h),
                          child: TextField(
                            style: FunctionHelper.fontTheme(
                                color: Colors.black,
                                fontSize: SizeUtil.titleSmallFontSize().sp),
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: hint,
                              isCollapsed: true,
                              contentPadding:
                                  EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
                              hintStyle: FunctionHelper.fontTheme(
                                  color: Colors.grey,
                                  fontSize: SizeUtil.titleSmallFontSize().sp),
                            ),
                            onChanged: (String s) =>
                                onSearch != null ? onSearch(s) : null,
                          ),
                        ),
                  onTap: () {
                    //AppRoute.SearchHome(context);
                  },
                )),
                /* SvgPicture.asset(
              'assets/images/svg/search_photo.svg',
              color: Color(ColorUtils.hexToInt('#c7bfbf')),
              width: 5.0.w,
              height: 5.0.w,
            )*/
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
                Image.asset(
                  'assets/images/png/map.png',
                  color: Colors.black.withOpacity(0.5),
                  width: 15,
                  height: 15,
                ),
                Expanded(
                    child: !isEnableSearch
                        ? Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(txtController.text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FunctionHelper.fontTheme(
                                    color: Colors.black,
                                    fontSize:
                                        SizeUtil.titleSmallFontSize().sp)),
                          )
                        : Container(
                            padding: EdgeInsets.only(left: 5, top: 10),
                            child: TextFormField(
                              style: FunctionHelper.fontTheme(
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
                                hintStyle: FunctionHelper.fontTheme(
                                    color: Colors.grey,
                                    fontSize: SizeUtil.titleSmallFontSize().sp),
                              ),
                              onChanged: (String s) =>
                                  onSearch != null ? onSearch(s) : null,
                            ),
                          )),
                Image.asset(
                  'assets/images/png/search.png',
                  color: ThemeColor.colorSale(),
                  width: 25,
                  height: 25,
                )
              ],
            ),
          ),
          onTap: () {
            AppRoute.searchMap(context, txtController.text);
          },
        ),
      ),
    );
  }
}
