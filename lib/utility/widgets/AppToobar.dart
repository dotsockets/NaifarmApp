
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

import 'BuildIconShop.dart';

enum Header_Type {
  barHome,
  barNoBackground,
  barNormal,
  barcartShop
}

class AppToobar extends PreferredSize {
 final Header_Type header_type;
 final  String Title;
 final Function onClick;
 final String icon;
 final isEnable_Search;

  const AppToobar({this.onClick, this.icon="", Key key, this.header_type, this.Title="",this.isEnable_Search=false}) : super(key: key);


 @override
 Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

 @override
  Widget build(BuildContext context) {
    if(header_type==Header_Type.barHome){
        return BarHome(context);
    }else if(header_type==Header_Type.barcartShop){
        return BarCartShop(context);
    }else if(header_type==Header_Type.barNoBackground){
      return barNoSearchNoTitle(context);
    }else if(header_type==Header_Type.barNormal){
      return BarNormal(context);
    }
  }


 Widget BarNormal(BuildContext context){
   return Container(
     child: AppBar(
       leading: IconButton(
         icon: Icon(Icons.arrow_back_ios, color: Colors.white),
         onPressed: () => Navigator.of(context).pop(),
       ),
       actions: [
         Container(
           margin: EdgeInsets.only(right: 10),
           child: SvgPicture.asset(icon,color: Colors.white,width: 30,height: 30,),
         )
       ],
       backgroundColor: ThemeColor.primaryColor(),
       title: Text(
         Title,
         style: GoogleFonts.sarabun(color: Colors.black),
       ),
     ),
   );
 }

 Widget BarCartShop(BuildContext context){
   return Container(
     child: AppBar(
       leading: IconButton(
         icon: Icon(Icons.arrow_back_ios, color: Colors.white),
         onPressed: () => Navigator.of(context).pop(),
       ),
       actions: [
         isEnable_Search?Container(
           margin: EdgeInsets.only(bottom: 5,right: 5),
           child: GestureDetector(child: SvgPicture.asset('assets/images/svg/search.svg',color: Colors.white),
             onTap: (){
               onClick();
             },
           ),
         ):SizedBox(),
         Container(
           margin: EdgeInsets.only(right: 10),
           child: BuildIconShop(size: 30,),
         )
       ],
       backgroundColor: ThemeColor.primaryColor(),
       title: Text(
         Title,
         style: GoogleFonts.sarabun(color: Colors.black,fontSize: ScreenUtil().setSp(50)),
       ),
     ),
   );
 }

  Widget barNoSearchNoTitle(BuildContext context){
    return GestureDetector(
      child: Container(

        padding: EdgeInsets.only(right: 20,left: 20,top: 10,bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(child: SvgPicture.asset('assets/images/svg/back_black.svg'),onTap: (){
              Navigator.pop(context);
            },),
            Container(
              decoration: BoxDecoration(
                  color: ThemeColor.primaryColor(),
                borderRadius: BorderRadius.all(Radius.circular(40))
              ),
              child: BuildIconShop(size: 30,notification: 0,),
            )
          ],
        ),
      ),
      onTap: (){
        AppRoute.MyCart(context,true);
      },
    );
  }


  Widget BarHome(BuildContext context){
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 8,bottom: 8,right: 8,left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              SizedBox(width: 8),
              BuildIconShop(notification: 20,size: 30,)
            ],
          ),
        ),
      ),
    );
  }



  Expanded _buildSearch() {
    final border = OutlineInputBorder(
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
    );

    return Expanded(
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(40.0))
        ),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            focusedBorder: border,
            enabledBorder: border,
            isDense: true,
          // hintText: "search",
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset('assets/images/svg/search.svg',color: Colors.black),
            ),
            prefixIconConstraints: sizeIcon,
            suffixIcon:  Padding(
              padding: const EdgeInsets.only(top: 4,bottom: 4,right: 10),
              child: SvgPicture.asset('assets/images/svg/search_photo.svg',color: Color(ColorUtils.hexToInt('#c7bfbf'))),
            ),
            suffixIconConstraints: sizeIcon,
            filled: true
          ),
        ),
      ),
    );
  }



}
