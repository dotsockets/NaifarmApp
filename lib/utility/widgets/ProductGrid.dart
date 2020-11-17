import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/screenutil.dart';
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
  final Function(int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final bool EnableHeader;
  final String tagHero;
  final bool FlashSallLabel;
  final bool isLike;

  const ProductGrid(
      {Key key,
      this.titleInto,
      this.onSelectMore,
      this.onTapItem,
      this.IconInto,
      this.producViewModel,
      this.EnableHeader = true,
      this.tagHero,
      this.FlashSallLabel = false, this.isLike= false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            EnableHeader ? _header_bar() : SizedBox(),
            _buildCardProduct(context: context)
          ],
        ) /*Column(
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

  Widget _buildCardProduct({BuildContext context}) {
    var _crossAxisSpacing = 100;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = ScreenUtil().setHeight(500);
    var _aspectRatio = _width / cellHeight;
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: producViewModel.length,
        padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount, childAspectRatio: _aspectRatio),
        itemBuilder: (context, index) {
          return Container(
            child: _buildProduct(item: producViewModel[index], index: index,context: context),
          );
        },
      ),
    );
  }

  Widget _FlashintoProduct({ProductModel item, int index}) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(
            item.product_name,
            style: GoogleFonts.sarabun(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "฿${item.product_price}",
            style: GoogleFonts.sarabun(
                color: ThemeColor.ColorSale(), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 7, bottom: 3, top: 3),
                    color: ThemeColor.ColorSale(),
                    child: Text(
                      item.product_status,
                      style: GoogleFonts.sarabun(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/svg/flash.svg',
                width: 45,
                height: 40,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _intoProduct({ProductModel item, int index}) {
    return Column(
      children: [
        Text(item.product_name,
            style: GoogleFonts.sarabun(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(45),
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 10,
        ),
        Text(
          "฿${item.product_price}",
          style:
              GoogleFonts.sarabun(color: ThemeColor.ColorSale(), fontSize: ScreenUtil().setSp(45)),
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
                  size: ScreenUtil().setHeight(40),
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.orange,
                  borderColor: Colors.black,
                  spacing: 0.0),
            ),
            Text((item.product_status),
                style: GoogleFonts.sarabun(
                    fontSize: ScreenUtil().setSp(30),
                    color: Colors.black,
                    fontWeight: FontWeight.w500))
          ],
        )
      ],
    );
  }

  Widget _buildProduct({ProductModel item, int index,BuildContext context}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 10, left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(35),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Hero(
                    tag: "${tagHero}_${index}",
                    child: CachedNetworkImage(
                      width: 120,
                      height: 120,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child:
                            Lottie.asset(Env.value.loadingAnimaion, height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: item.product_image,
                      errorWidget: (context, url, error) => Container(
                          height: 30,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 7, left: 8),
                      decoration: BoxDecoration(
                          color: ThemeColor.ColorSale(),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text(
                        "50%",
                        style: GoogleFonts.sarabun(
                            color: Colors.white, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(40)),
                      ),
                    ),
                    isLike?Container(
                        margin: EdgeInsets.only(right: 15,top: 7),
                        child: SvgPicture.asset(
                      'assets/images/svg/like_line.svg',
                      width: 35,
                      height: 35,
                          color: ThemeColor.ColorSale(),
                    )):SizedBox()
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            FlashSallLabel
                ? _FlashintoProduct(item: item, index: index)
                : _intoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: () => onTapItem(index),
    );
  }
}
