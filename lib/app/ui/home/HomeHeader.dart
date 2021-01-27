import 'package:basic_utils/basic_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:sizer/sizer.dart';

class HomeHeader extends StatefulWidget {
  final HomeObjectCombine snapshot;
  final Function(CategoryGroupData) onTap;

  const HomeHeader({Key key, this.snapshot, this.onTap}) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0.3.w),
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 3.0.w, right: 1.8.w),
                  child: Icon(
                    Icons.qr_code_scanner_sharp,
                    color: Colors.white,
                    size: 6.0.w,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                      child: Container(
                  height: 5.0.h,
                  decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            new BorderRadius.all(Radius.circular(40.0))),
                  child: Container(
                        padding: EdgeInsets.only(left: 8, right: 11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              'assets/images/svg/search.svg',
                              color: Colors.grey.shade400,
                              width: 5.0.w,
                              height: 5.0.w,
                            ),
                            widget.snapshot.trendingRespone!=null?Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 10.0.w,
                                  padding: EdgeInsets.only(left: 6),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height: 400,
                                      aspectRatio: 16/9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 4),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 1200),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      scrollDirection: Axis.vertical,
                                    ),
                                    items: widget.snapshot.trendingRespone.data
                                        .map((e) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            child: Text("${e.name}",
                                                style: FunctionHelper.FontTheme(
                                                    color: Colors.grey.shade400,
                                                    fontSize:
                                                        SizeUtil.titleFontSize().sp,
                                                    fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )):SizedBox(),
                            SvgPicture.asset(
                              'assets/images/svg/search_photo.svg',
                              color: Color(ColorUtils.hexToInt('#c7bfbf')),
                              width: 5.0.w,
                              height: 5.0.w,
                            )
                          ],
                        )),
                ),
                    onTap: (){
                      AppRoute.SearchHome(context);
                    },)
                ),
                BuildIconShop(
                  size: 6.5.w,
                )

              ],
            ),
            SizedBox(
              height: 0.7.h,
            ),
            widget.snapshot != null
                ? CategoryMenu(
                    featuredRespone: widget.snapshot.featuredRespone,
                    selectedIndex: 0,
                    onTap: (CategoryGroupData val) {
                      widget.onTap(val);
                      // setState(() {
                      //   _categoryselectedIndex = val;
                      //   _categoryselectedIndex!=0?AppRoute.CategoryDetail(context,_categoryselectedIndex-1):print(_categoryselectedIndex);
                      // });
                      //  Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
                    },
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
