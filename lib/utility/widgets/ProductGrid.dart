import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductGrid extends StatelessWidget {
  final String titleInto;
  final Function() onSelectMore;
  final Function() onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;

  const ProductGrid(
      {Key key,
      this.titleInto,
      this.onSelectMore,
      this.onTapItem,
      this.IconInto,
      this.producViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,

      child: Column(
        children: [
          _header_bar(),
          _buildCardProduct(context: context)],

      )/*Column(
        children: [
          _header_bar(),
          _buildCardProduct(),
         /* Column(
            children: List.generate( producViewModel.length,(index) => _buildCardProduct(item: producViewModel[index], index: index)),
          )*/
        ],
      ),*/
    );
  }

  Container _header_bar() => Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
        child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        // Image.asset(IconI=nto,width: 50,height: 50,),

        SvgPicture.asset(
          IconInto,
          width: 30,
          height: 30,
        ),
        SizedBox(width: 8),
        Text(titleInto,
            style: GoogleFonts.sarabun(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    ),
  ],
        ),
      );



  Widget _buildCardProduct({BuildContext context}){
    var _crossAxisSpacing = 100;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var cellHeight = 200;
    var _aspectRatio = _width /cellHeight;
    return Container(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: producViewModel.length,
        padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount,childAspectRatio: _aspectRatio),
        itemBuilder: (context,index){
          return Container(
            child:_buildInfoProduct(item: producViewModel[index]),
          );
        },
      ),
    );
  }

  Widget _buildInfoProduct({ProductModel item}) {
    return Container(
      padding: EdgeInsets.only(right: 10,left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.3),width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: CachedNetworkImage(
                  width: 100,
                  height: 100,
                  placeholder: (context, url) => Container(
                    color: Colors.white,
                    child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                  ),
                  fit: BoxFit.cover,
                  imageUrl: item.product_image,
                  errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7,left: 8),
                decoration: BoxDecoration(
                  color: ThemeColor.ColorSale(),
                  borderRadius: BorderRadius.all(Radius.circular(7))
                ),
                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                child: Text("50%",style: GoogleFonts.sarabun(color: Colors.white,fontWeight: FontWeight.bold),),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(item.product_name,
              style: GoogleFonts.sarabun(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10,
          ),
          Text(
            "฿${item.product_price}",
            style: GoogleFonts.sarabun(
                color: ThemeColor.ColorSale(), fontSize: 18),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 6),
                child: SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {},
                    starCount: 5,
                    rating: 2,
                    size: 14.0,
                    isReadOnly: true,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    color: Colors.orange,
                    borderColor: Colors.black,
                    spacing: 0.0),
              ),
              Text((item.product_status),
                  style: GoogleFonts.sarabun(fontSize: 12,color: Colors.black,fontWeight: FontWeight.w600))
            ],
          )
        ],
      ),
    );
  }
}
