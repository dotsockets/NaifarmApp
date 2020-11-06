import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

enum Header_Type {
  barHasSearch,
  barNoSearch,
  barNoSearchNoTitle
}

class AppToobar extends PreferredSize {
 final Header_Type header_type;
 final  String Title;

  const AppToobar({Key key, this.header_type, this.Title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if(header_type==Header_Type.barHasSearch){
        return HasSearch();
    }else if(header_type==Header_Type.barNoSearch){
        return BarNoSearch(context);
    }else if(header_type==Header_Type.barNoSearchNoTitle){
      return barNoSearchNoTitle(context);
    }
  }

 Widget BarNoSearch(BuildContext context){
   return Container(
     color: ThemeColor.primaryColor(),
     child: SafeArea(
       bottom: false,
       child: Padding(
         padding: const EdgeInsets.only(top: 8,bottom: 8,right: 8,left: 12),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             GestureDetector(child: SvgPicture.asset('assets/images/svg/back_black.svg',color: Colors.white,),
               onTap: (){
                 Navigator.pop(context);
               },),
             Text("สินค้า Naifarm ฟาร์มมาร์เก็ต",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 16,
               fontWeight: FontWeight.w500,decoration: TextDecoration.none,),),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 GestureDetector(child: SvgPicture.asset('assets/images/svg/search.svg',color: Colors.white),
                   onTap: (){},
                 ),_buildIconButton(
                   onPressed: () => print("click"),
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

  Widget barNoSearchNoTitle(BuildContext context){
    return Container(
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
    );
  }


  Widget HasSearch(){
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
                onPressed: () => print("click"),
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

}
