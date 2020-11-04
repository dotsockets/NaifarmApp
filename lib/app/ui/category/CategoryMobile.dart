
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class CategoryMobile extends StatelessWidget {
  final List<MenuModel> _menuViewModel = MenuViewModel().getMenustype();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: StickyHeader(
          header: AppToobar(),
          content: _content(context: context),
        ),
      ),
    );
  }


  Widget _content({BuildContext context}){
    var _crossAxisSpacing = 90;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 4;
    var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var cellHeight = 65;
    var _aspectRatio = _width /cellHeight;
    return Container(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _menuViewModel.length-1,
        padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount,childAspectRatio: _aspectRatio,mainAxisSpacing: 20,crossAxisSpacing: 20),
        itemBuilder: (context,index){
          return Container(
            child:_ProductImage(item: _menuViewModel[index+1],index: index),
          );
        },
      ),
    );
  }

  Widget _ProductImage({MenuModel item,int index}){
    return InkWell(
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  width:80,
                  height: 80,
                  placeholder: (context, url) => Container(
                    color: Colors.white,
                    child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                  ),
                  fit: BoxFit.cover,
                  imageUrl: item.icon,
                  errorWidget: (context, url, error) => Container(height: 80,width: 80,child: Icon(Icons.error,size: 30,)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(item.label,style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
      onTap: (){
        print("click");
      },
    );
  }


}
