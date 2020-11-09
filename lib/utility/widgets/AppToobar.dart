
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

enum Header_Type {
  barHasSearch,
  barNoSearch,
  barNoSearchNoTitle,
  barMe,
  barNormal
}

class AppToobar extends PreferredSize {
 final Header_Type header_type;
 final  String Title;
 final Function onClick;
 final String icon;

  const AppToobar({this.onClick, this.icon, Key key, this.header_type, this.Title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if(header_type==Header_Type.barHasSearch){
        return HasSearch(context);
    }else if(header_type==Header_Type.barNoSearch){
        return BarNoSearch(context);
    }else if(header_type==Header_Type.barNoSearchNoTitle){
      return barNoSearchNoTitle(context);
    }else if(header_type==Header_Type.barNormal){
      return BarNormal(context);
    }
  }

 Widget BarNoSearch(BuildContext context){
   return Container(
     color: ThemeColor.primaryColor(),
     child: SafeArea(
       bottom: false,
       child: Padding(
         padding: const EdgeInsets.only(top: 0,bottom: 3,right: 8,left: 12),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             GestureDetector(child: SvgPicture.asset('assets/images/svg/back_black.svg',color: Colors.white,),
               onTap: (){
                 Navigator.pop(context);
               },),
             Text(Title,style: GoogleFonts.sarabun(color: Colors.black,fontSize: 20,
               fontWeight: FontWeight.bold,decoration: TextDecoration.none,),),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 GestureDetector(child: SvgPicture.asset('assets/images/svg/search.svg',color: Colors.white),
                   onTap: (){},
                 ),_buildIconButton(
                   onPressed: () {
                     AppRoute.MyCart(context);
                   },
                   icon: Icons.shopping_cart_outlined,
                   notification: 20,
                 ),],
             ),
           ],
         ),
       ),
     ),
   );
 }

 Widget BarNormal(BuildContext context){
   return Container(
     height: 100,
     color: ThemeColor.primaryColor(),
     child: SafeArea(
       bottom: false,
       child: Padding(
         padding: const EdgeInsets.only(top: 0,bottom: 5,right: 8,left: 12),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             GestureDetector(child: SvgPicture.asset('assets/images/svg/back_black.svg',color: Colors.white,),
               onTap: (){
                 Navigator.pop(context);
               },),
             Text(Title,style: GoogleFonts.sarabun(color: Colors.black,fontSize: 20,
               fontWeight: FontWeight.bold,decoration: TextDecoration.none,),),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 Container(
                   margin: EdgeInsets.only(right: 7),
                   child: GestureDetector(child: SvgPicture.asset(icon,color: Colors.white,width: 35,height: 35,),
                     onTap: ()=>onClick(),
                   ),
                 ),],
             ),
           ],
         ),
       ),
     ),
   );
 }

  Widget barNoSearchNoTitle(BuildContext context){
    return GestureDetector(
      child: Container(

        padding: EdgeInsets.only(right: 25,left: 25,top: 10,bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(child: SvgPicture.asset('assets/images/svg/back_black.svg'),onTap: (){
              Navigator.pop(context);
            },),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: ThemeColor.primaryColor(),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Icon(Icons.shopping_cart_outlined,color: Colors.white,),
            )
          ],
        ),
      ),
      onTap: (){
        AppRoute.MyCart(context);
      },
    );
  }


  Widget HasSearch(BuildContext context){
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
              _buildIconButton(
                onPressed: (){
                  AppRoute.MyCart(context);
                },
                icon: Icons.shopping_cart_outlined,
                notification: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildIconButton({
    VoidCallback onPressed,
    IconData icon,
    int notification = 0,
  }) =>
      Stack(
        children: <Widget>[
          IconButton(
            iconSize: 35,
            onPressed: onPressed,
            icon: Icon(icon),
            color: Colors.white,
          ),
          notification == 0
              ? SizedBox()
              : Positioned(
            right: 5,
            top: 5,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: ThemeColor.ColorSale(),
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 15,
                minHeight: 15,
              ),
            ),
          ),
        ],
      );

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
        padding: EdgeInsets.only(left: 10,top: 5,bottom: 5,right: 10),
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
            prefixIcon: SvgPicture.asset('assets/images/svg/search.svg',color: Colors.black),
            prefixIconConstraints: sizeIcon,
            suffixIcon:  SvgPicture.asset('assets/images/svg/search_photo.svg',color: Color(ColorUtils.hexToInt('#c7bfbf'))),
            suffixIconConstraints: sizeIcon,
            filled: true
          ),
        ),
      ),
    );
  }

  Widget MeToobar(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Icon(Icons.settings)
        ],
      ),
    );
  }

}
