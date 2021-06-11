import 'dart:io';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:sizer/sizer.dart';

class CategoryHeader extends StatelessWidget {
  final CategoryObjectCombin snapshot;
  final Function(CategoryGroupData) onTap;
  final String title;
  final bool moreSize;

  const CategoryHeader(
      {Key key, this.snapshot, this.onTap, this.title, this.moreSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 3.0.h),
      decoration: new BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: new BorderRadius.only(
            bottomRight: const Radius.circular(40.0),
            bottomLeft: const Radius.circular(40.0),
          )),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 0, right: 0.3.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Platform.isAndroid
                              ? Icons.arrow_back
                              : Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
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
            snapshot != null
                ? CategoryMenu(
                    moreSize: moreSize,
                    featuredRespone: snapshot.supGroup,
                    onTap: (CategoryGroupData val) {
                      AppRoute.categorySubDetail(context, val.id,
                          title: val.name);
                    },
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
