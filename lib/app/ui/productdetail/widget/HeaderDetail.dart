import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';



class HeaderDetail extends StatefulWidget {
  final Function onClick;
  final String title;
  final TrackingScrollController scrollController;

  HeaderDetail({Key key, this.onClick, this.scrollController, this.title}) : super(key: key);

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
  double _opacity_icon;

  final _opacityMax = 0.01;



  @override
  void initState() {
    _backgroundColor = Colors.transparent;
    _backgroundColorSearch = Colors.black.withOpacity(0.2);

    _colorIcon = Colors.white;
    _colorTitle = Colors.transparent;
    _opacity = 0.0;
    _offset = 0.0;
    _opacity_icon = 0.0;

    widget.scrollController.addListener(_onScroll);

    super.initState();

  }





  _onScroll() {
    final scrollOffset = widget.scrollController.offset;

    if (scrollOffset >= _offset && scrollOffset > 0) {
      _opacity = double.parse((_opacity + _opacityMax).toStringAsFixed(2));
      _opacity_icon = double.parse((_opacity_icon - _opacityMax).toStringAsFixed(2));

      if (_opacity >= 1.0) {
        _opacity = 1.0;
        _colorIcon = Colors.black.withOpacity(_opacity);
      }

      if(_opacity_icon<=0){
        _opacity_icon = 0.0;
      }

      _offset = scrollOffset;
    } else if (scrollOffset < 100) {
       _opacity = double.parse((_opacity - _opacityMax).toStringAsFixed(2));
      _opacity_icon = double.parse((_opacity_icon + _opacityMax).toStringAsFixed(2));
      if (_opacity <= 0.0) {
        _opacity_icon = 0.2;
        _opacity = 0.0;
        _colorIcon = Colors.white.withOpacity(_opacity);
      }


       if(_opacity_icon>0.20){
         _opacity_icon = _opacity_icon - _opacityMax;
       }


    }

    setState(() {
      if(scrollOffset>=100){
        _opacity = 1.0;
        _opacity_icon = 0.0;
      }
     else if (scrollOffset <= 0) {
        _colorIcon = Colors.white;
        _offset = 0.0;
        _opacity_icon = 0.2;
        _opacity = 0.0;
       // _colorIcon = Colors.white.withOpacity(_opacity_icon);
      }

      _backgroundColorSearch = Colors.black.withOpacity(_opacity_icon);
      _backgroundColor = Colors.white.withOpacity(_opacity);
      _colorTitle = Colors.black.withOpacity(_opacity);


    });


  }


    @override
    Widget build(BuildContext context) {

      return Container(
        height: 8.0.h,
        decoration: BoxDecoration(
          color: _backgroundColor,

          boxShadow: [
             BoxShadow(
              color: widget.scrollController.offset>0?Colors.grey.withOpacity(0.5):Colors.transparent,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 2.0.w,left: 1.5.w, right: 1.5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                      icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons
                          .arrow_back_ios_rounded, color:_colorIcon,),
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
                //         style: FunctionHelper.FontTheme(
                //             color: Colors.black,
                //             fontWeight: FontWeight.bold,
                //             fontSize: SizeUtil.titleFontSize().sp),
                //       ),
                //     ),
                //   ),
                // ),
Expanded(
  child: Text(widget.title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: FunctionHelper.FontTheme(
          fontSize: SizeUtil.titleFontSize().sp,
          fontWeight: FontWeight.bold,
          color: _colorTitle)),
),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: _backgroundColorSearch,
                    child: BuildIconShop(

                      iconColor: _colorIcon),
                  ),
                ),
                SizedBox(width: 2.0.w,),
                ClipRRect(
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
      );
    }
  }

