import 'dart:io';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';
import 'package:easy_localization/easy_localization.dart';

class HeaderDetail extends StatefulWidget {
  final Function onClick;
  final String title;
  final TrackingScrollController scrollController;

  HeaderDetail({Key key, this.onClick, this.scrollController, this.title})
      : super(key: key);

  @override
  _HeaderDetailState createState() => _HeaderDetailState();
}

class _HeaderDetailState extends State<HeaderDetail> {
  Color _backgroundColor;
  Color _backgroundColorSearch;
  Color _colorIcon;
  Color _colorTitle;
  double _opacity;
  double _offset;
  double _opacityIcon;
  final _reload = BehaviorSubject<bool>();
  final _opacityMax = 0.01;

  @override
  void initState() {
    _backgroundColor = Colors.transparent;
    _backgroundColorSearch = Colors.black.withOpacity(0.2);

    _colorIcon = Colors.white;
    _colorTitle = Colors.transparent;
    _opacity = 0.0;
    _offset = 0.0;
    _opacityIcon = 0.0;

    widget.scrollController.addListener(_onScroll);
    _reload.add(true);
    super.initState();
  }

  _onScroll() {
    final scrollOffset = widget.scrollController.offset;

    if (scrollOffset >= _offset && scrollOffset > 0) {
      _opacity = double.parse((_opacity + _opacityMax).toStringAsFixed(2));
      _opacityIcon =
          double.parse((_opacityIcon - _opacityMax).toStringAsFixed(2));

      if (_opacity >= 1.0) {
        _opacity = 1.0;
        _colorIcon = Colors.white.withOpacity(_opacity);
      }

      if (_opacityIcon <= 0) {
        _opacityIcon = 0.0;
      }

      _offset = scrollOffset;
    } else if (scrollOffset < 100) {
      _opacity = double.parse((_opacity - _opacityMax).toStringAsFixed(2));
      _opacityIcon =
          double.parse((_opacityIcon + _opacityMax).toStringAsFixed(2));
      if (_opacity <= 0.0) {
        _opacityIcon = 0.2;
        _opacity = 0.0;
        _colorIcon = Colors.white.withOpacity(_opacity);
      }

      if (_opacityIcon > 0.20) {
        _opacityIcon = _opacityIcon - _opacityMax;
      }
    }

    if (scrollOffset >= 100) {
      _opacity = 1.0;
      _opacityIcon = 0.0;
    } else if (scrollOffset <= 0) {
      _colorIcon = Colors.white;
      _offset = 0.0;
      _opacityIcon = 0.2;
      _opacity = 0.0;
      // _colorIcon = Colors.white.withOpacity(_opacityIcon);
    }

    _backgroundColorSearch = Colors.black.withOpacity(_opacityIcon);
    _backgroundColor = ThemeColor.primaryColor().withOpacity(_opacity);
    _colorTitle = Colors.black.withOpacity(_opacity);

    _reload.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _reload.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              children: [
                Container(
                   height: 12.0.h,
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: widget.scrollController.offset > 0
                            ? Colors.grey.withOpacity(0.5)
                            : Colors.transparent,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                      top: 2.0.w, left: 1.5.w, right: 1.5.w, bottom: 1.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  color: _backgroundColorSearch,
                                  child: IconButton(
                                    icon: Icon(
                                      Platform.isAndroid
                                          ? Icons.arrow_back
                                          : Icons.arrow_back_ios_rounded,
                                      color: _colorIcon,
                                    ),
                                    onPressed: () {
                                      widget.onClick == null
                                          ? Navigator.of(context).pop()
                                          : widget.onClick();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Expanded(
                          //   child: Container(
                          //     child: Center(
                          //       child: Text(
                          //         title,
                          //         style: FunctionHelper.fontTheme(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: SizeUtil.titleFontSize().sp),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child:
                                // widget.title
                                Center(
                              child: Text(LocaleKeys.my_product_detail.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.w500,
                                      color: _colorTitle)),
                            ),
                          ),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  color: _backgroundColorSearch,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.transparent,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Container(
                                //margin: EdgeInsets.only(top: 0.3.h,left: 0.1.h),
                                child: BuildIconShop(iconColor: _colorIcon),
                              )
                            ],
                          ),
                          //SizedBox(width: 2.0.w,),
                          /* ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                color: _backgroundColorSearch,
                                child: IconButton(
                                  icon: Icon(FontAwesome.ellipsis_v, color:_colorIcon,),
                                  onPressed: () {
                                    FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                                  },
                                ),
                              ),
                            ),*/
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
              ],
            );
          } else {
            return SizedBox();
          }
        });
  }
}
