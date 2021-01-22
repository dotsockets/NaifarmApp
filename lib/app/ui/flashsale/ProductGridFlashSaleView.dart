import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';


class ProductGridFlashSaleView extends StatefulWidget {
  final String titleInto;
  final Function() onSelectMore;
  final Function(int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final bool EnableHeader;
  final String tagHero;
  final bool FlashSallLabel;
  final bool isLike;
  final bool showBorder;
  final FlashsaleRespone flashsaleProduct;
  final String api_link;

  const ProductGridFlashSaleView(
      {Key key,
        this.titleInto,
        this.onSelectMore,
        this.onTapItem,
        this.IconInto,
        this.producViewModel,
        this.EnableHeader = true,
        this.tagHero,
        this.FlashSallLabel = false,
        this.isLike = false,
        this.showBorder = false,this.flashsaleProduct, this.api_link})
      : super(key: key);
  @override
  _ProductGridFlashSaleViewState createState() => _ProductGridFlashSaleViewState();
}

class _ProductGridFlashSaleViewState extends State<ProductGridFlashSaleView> {

  ProductBloc bloc;
  List<FlashsaleItems> product_data = List<FlashsaleItems>();

  void _init(){
    if(null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      if(widget.flashsaleProduct!=null){
        bloc.Flashsale.add(widget.flashsaleProduct);
      }else{
        bloc.loadMoreData(page: "1",limit: 5,link: widget.api_link);
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    _init();
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.showBorder ? 40 : 0),
          topRight: Radius.circular(widget.showBorder ? 40 : 0)),
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              widget.EnableHeader ? _header_bar() : SizedBox(),
              _buildCardProduct(context: context)
            ],
          )),
    );
  }

  Container _header_bar() => Container(
    margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              widget.IconInto,
              width: 30,
              height: 30,
            ),
            SizedBox(width: 8),
            Text(widget.titleInto,
                style: FunctionHelper.FontTheme(
                    color: Colors.black,
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );

  Widget _buildCardProduct({BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ItemRow(context),
    );
  }

  Container ItemRow(BuildContext context) => Container(
    child: StreamBuilder(
      stream: bloc.Flashsale.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          product_data.clear();
            product_data.addAll((snapshot.data as FlashsaleRespone).data[0].items);

          return Column(
            children: [
              for (int i = 0; i < product_data.length; i += 2)
                Container(
                  padding: EdgeInsets.only(left: 7, right: 7),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        Check(i),
                            (index) => _buildProduct(
                            index: i + index,
                            item: product_data[i+index].product,
                            context: context)),
                  ),
                )
            ],
          );
        }else{
          return SizedBox();
        }
      },
    ),
  );

  Widget _FlashintoProduct({ProductData item, int index}) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(
            " "+item.name+" ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FunctionHelper.FontTheme(
                color: Colors.black, fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          SizedBox(height: 5),
          Text(
            "฿${item.salePrice}",
            style: FunctionHelper.FontTheme(
                color: ThemeColor.ColorSale(), fontWeight: FontWeight.bold,fontSize: SizeUtil.priceFontSize().sp),
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
                      LocaleKeys.my_product_sold.tr()+" "+item.saleCount.toString()+" "+LocaleKeys.cart_item.tr(),
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailSmallFontSize().sp,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/svg/flash.svg',
                width: 8.0.w,
                height: 8.0.w,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _intoProduct({ProductData item, int index}) {
    return Column(
      children: [
        Text(item.name,
            style: FunctionHelper.FontTheme(
                color: Colors.black,
                fontSize: SizeUtil.titleSmallFontSize().sp,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 10,
        ),
        Text(
          "฿${item.salePrice}",
          style: FunctionHelper.FontTheme(
              color: ThemeColor.ColorSale(), fontSize: SizeUtil.titleSmallFontSize().sp),
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
            Text(LocaleKeys.my_product_sold.tr()+item.hasVariant.toString()+" "+LocaleKeys.cart_item.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.detailSmallFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500))
          ],
        )
      ],
    );
  }

  Widget _buildProduct({ProductData item, int index, BuildContext context}) {
    return GestureDetector(
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 15,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Hero(
                  tag: "${widget.tagHero}_${index}",
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(1.0.h),
                      child: CachedNetworkImage(
                        width: 120,
                        height: 130,
                        placeholder: (context, url) => Container(
                          width: 120,
                          height: 130,
                          color: Colors.white,
                          child:
                          Lottie.asset(Env.value.loadingAnimaion, height: 30),
                        ),
                        fit: BoxFit.cover,
                        imageUrl: ProductLandscape.CovertUrlImage(item.image),
                        errorWidget: (context, url, error) => Container(
                            width: 120,
                            height: 120,
                            child: Icon(
                              Icons.error,
                              size: 30,
                            )),
                      ),
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeUtil.titleSmallFontSize().sp),
                      ),
                    ),
                    widget.isLike
                        ? Container(
                        margin: EdgeInsets.only(right: 8, top: 7),
                        child: SvgPicture.asset(
                          'assets/images/svg/like_line.svg',
                          width: 35,
                          height: 35,
                          color: ThemeColor.ColorSale(),
                        ))
                        : SizedBox()
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            widget.FlashSallLabel
                ? _FlashintoProduct(item: item, index: index)
                : _intoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: () => widget.onTapItem(index),
    );
  }

  int Check(int i) => i != product_data.length - 1 ? 2 : 1;
}
