import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';

class ProductVertical extends StatelessWidget {
  final String titleInto;
  final Function() onSelectMore;
  final Function(int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final  bool borderRadius;
  final String tagHero;
  final double IconSize;

  const ProductVertical({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.IconInto, this.producViewModel, this.borderRadius, this.tagHero, this.IconSize=35}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius?40:0),topRight:  Radius.circular(borderRadius?40:0)),
      child: Container(
        padding: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 15),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            _header_bar(),
            Column(
              children: List.generate(producViewModel.length, (index) => _buildCardProduct(item: producViewModel[index],index: index)),
            )
          ],
        ),
      ),
    );
  }


  Container _header_bar() => Container(
      child: Container(
        margin: EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
               // Image.asset(IconI=nto,width: 50,height: 50,),

                SvgPicture.asset(IconInto,width: IconSize,height: IconSize,),
                SizedBox(width: 8),
                Text(titleInto,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text("ดูทั้งหมด",style: FunctionHelper.FontTheme(color: Colors.black,fontSize:  ScreenUtil().setSp(40),fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                SvgPicture.asset('assets/images/svg/next.svg',width: 30,height: 30,),

              ],
            )
          ],
        ),
      )
  );

  _buildCardProduct({ProductModel item,int index}){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: "${tagHero}_${index}",
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                          child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                        ),
                        fit: BoxFit.cover,
                        imageUrl: item.product_image,
                        errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoProduct(item: item),
                )
              ],
            ),
            producViewModel.length!=index+1?Divider(color: Colors.black.withOpacity(0.5)):SizedBox()
          ],
        ),
      ),
      onTap: (){
        onTapItem(index);
      },
    );
  }

  Widget _buildInfoProduct({ProductModel item}){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.product_name,style: FunctionHelper.FontTheme(color: Colors.black,fontSize:  ScreenUtil().setSp(45),fontWeight: FontWeight.bold)),
          SizedBox(height: 10,),
          Text("฿${item.product_price}",style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold,fontSize:  ScreenUtil().setSp(50)),),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(item.product_status,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize:  ScreenUtil().setSp(40)),),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_pin,color: Color(ColorUtils.hexToInt("#666666")),),
                      SizedBox(width: 5,),
                      Text('เชียงใหม่',style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize:  ScreenUtil().setSp(40)),)
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.only(right: 15,left: 15,top: 5,bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Text('ซื้อเลย',style: FunctionHelper.FontTheme(color: Colors.white,fontSize:  ScreenUtil().setSp(45),fontWeight: FontWeight.bold),),
              )
            ],
          )
        ],
      ),
    );
  }

}
