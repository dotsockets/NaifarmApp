
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class CategoryView extends StatelessWidget {
  @override
  final List<MenuModel> _menuViewModel = MenuViewModel().getMenustype();
  Widget build(BuildContext context) {
    _menuViewModel.removeAt(0);
    return Scaffold(
      appBar:  AppToobar(header_type: Header_Type.barHome,isEnable_Search: true,),

      backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: _content(context: context)
      ),
    ),
    );
  }


  Widget _content({BuildContext context}){
   return Container(
     padding: EdgeInsets.all(10),
     child: Column(
       children: [
         Column(
           children: item((_menuViewModel.length/4).floor(),4,context),
         ),
         Column(
           children: item(1,(_menuViewModel.length/4).floor()*4,context),
         )
       ],
     ),
   );
  }



  List<Widget> item(int con,int count,BuildContext context){
    var data = List<Widget>();
    var j=0;
    int n = ((_menuViewModel.length/4).floor()*4)+4-_menuViewModel.length;
    for( int i=0;i<(con);i++){
      j+=4;
      data.add(
          Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            margin: EdgeInsets.only(bottom: 20),
            child: con!=1?Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for( int i=count;i>=1;i--)
                    _ProductImage(item: _menuViewModel[j-i],index: j-1,context: context)
                ]
            ):Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for( int i=count;i<_menuViewModel.length;i++)
                    _ProductImage(item: _menuViewModel[i],index: i,context: context),

                  if(_menuViewModel.length%4!=0)
                    for( int i=0;i<n;i++)
                      SizedBox(width:SizeUtil.categoryBox(),
                        height: SizeUtil.categoryBox(),)


                ]
            ),
          )
      );
    }
    return data;
  }

  Widget _ProductImage({MenuModel item,int index,BuildContext context}){
    return InkWell(
      child: Container(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  width:SizeUtil.categoryBox(),
                  height: SizeUtil.categoryBox(),
                  placeholder: (context, url) => Container(
                    color: Colors.white,
                    child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                  ),
                  fit: BoxFit.cover,
                  imageUrl: item.icon,
                  errorWidget: (context, url, error) => Container(height: ScreenUtil().setWidth(200),width: ScreenUtil().setHeight(160),child: Icon(Icons.error,size: 30,)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(item.label,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.bold),)
          ],
        ),
      ),
      onTap: (){
       // print(index);
        for (int i=0;i<_menuViewModel.length;i++){
           if(_menuViewModel[i].type==item.type){
             AppRoute.CategoryVegetable(context,i);
             break;
           }

        }

       // AppRoute.CategoryVegetable(context,_menuViewModel[].type);
      },
    );
  }
  int Check(int i)=>i!=_menuViewModel.length-1?4:1;

}
