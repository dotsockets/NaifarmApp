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
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';

import 'ProductLandscape.dart';
import 'Skeleton.dart';

class ProductGrid extends StatefulWidget {

  final String titleInto;
  final Function() onSelectMore;
  final Function(ProductData,int) onTapItem;
  final String IconInto;
  final bool EnableHeader;
  final String tagHero;
  final bool FlashSallLabel;
  final bool isLike;
  final bool showBorder;
  ProductRespone productRespone;
  final String api_link;
  final bool showSeeMore;

   ProductGrid(
      {Key key,
        this.titleInto,
        this.onSelectMore,
        this.onTapItem,
        this.IconInto,
        this.EnableHeader = true,
        this.tagHero,
        this.FlashSallLabel = false,
        this.isLike = false,
        this.showBorder = false,this.productRespone, this.api_link, this.showSeeMore})
      : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {

  ProductBloc bloc;
  List<ProductData> product_data = List<ProductData>();
  int page = 1;
  int limit = 10;
  ScrollController _scrollController = ScrollController();
  bool step_page = false;
  final position_scroll = BehaviorSubject<bool>();
  void _init(){
    if(null == bloc) {

      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.MoreProduct.stream.listen((event) {
        setState(() {
          product_data.addAll(event.data);
        });
      });
      // if(page==1){
      //  bloc.MoreProduct.add(widget.productRespone);
      //  page = 2;
      // }else{
      //   bloc.loadMoreData(page: page.toString(),limit: 5,link: widget.api_link);
      // }
      //
      if(widget.productRespone!=null){
        product_data.addAll(widget.productRespone.data);
      }else{
        bloc.loadMoreData(page: page.toString(),limit: 5,link: widget.api_link);
      }
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
          _scrollController.position.pixels <=
          200) {
        if (step_page) {
          step_page = false;
          page++;
          bloc.loadMoreData(
              page: page.toString(),
              limit: limit,
              link: widget.api_link);
        }
      }

      if (_scrollController.position.pixels > 500) {
        position_scroll.add(true);
      } else {
        position_scroll.add(false);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    _init();
    return product_data.length>0?ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.showBorder ? 40 : 0),
          topRight: Radius.circular(widget.showBorder ? 40 : 0)),
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              widget.EnableHeader ? _header_bar() : SizedBox(),
              SizedBox(height: 10,),
              _buildCardProduct(context: context)
            ],
          )),
    ):  Skeleton.LoaderGridV(context);
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
        GestureDetector(
            child: Visibility(
              visible: widget.showSeeMore,
              child: Row(
                children: [
                  Text(LocaleKeys.recommend_see_more.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500)),
                  SizedBox(width: 2.0.w),
                  SvgPicture.asset('assets/images/svg/next.svg',width: 3.0.w,height: 3.0.h,),
                ],
              ),
            ),
            onTap: ()=>widget.onSelectMore()
        )
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
    child: Column(
      children: [
        for (int i = 0; i < product_data.length; i += 2)
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  Check(i),
                      (index) => _buildProduct(
                      index: i + index,
                      item: product_data[i + index],
                      context: context)),
            ),
          )
      ],
    ),
  );



  Widget _intoProduct({ProductData item, int index}) {
    return Column(
      children: [
        SizedBox(height: 0.5.h),
        Container(
          height: SizeUtil.titleSmallFontSize().sp*2.5,
          child: Text(item.name,maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: FunctionHelper.FontTheme(
                  color: Colors.black,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            item.offerPrice!=null?Text("${item.salePrice}",style: FunctionHelper.FontTheme(
                color: Colors.grey,
                fontSize: SizeUtil.priceFontSize().sp-2, decoration: TextDecoration.lineThrough)):SizedBox(),
            SizedBox(width: item.offerPrice!=null?1.0.w:0),
            Text(item.offerPrice!=null?"฿${item.offerPrice}":"฿${item.salePrice}",maxLines: 1,
              overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
          ],
        ),
        SizedBox(
          height: 1.0.h,
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
            Text("${LocaleKeys.my_product_sold.tr()} ${item.saleCount!=null?item.saleCount.toString():'0'} ${LocaleKeys.cart_item.tr()}",
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Hero(
                    tag: "${widget.tagHero}_${item.id}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1.0.h),
                      child: CachedNetworkImage(
                        width: 28.0.w,
                        height: 35.0.w,
                        placeholder: (context, url) => Container(
                          width: 28.0.w,
                          height: 35.0.w,
                          color: Colors.white,
                          child:
                          Lottie.asset('assets/json/loading.json',   width: 28.0.w,
                            height: 35.0.w,),
                        ),
                        imageUrl: ProductLandscape.CovertUrlImage(item.image),
                        errorWidget: (context, url, error) => Container(
                            width: 28.0.w,
                            height: 35.0.w,
                            child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.only(top: 7, left: 8),
                        decoration: BoxDecoration(
                            color: ThemeColor.ColorSale(),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        padding: EdgeInsets.only(
                            left: 1.5.w, right: 1.5.w, top: 1.0.w, bottom: 1.0.w),
                        child: Text(
                          item.discountPercent.toString()+"%",
                          style: GoogleFonts.sarabun(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: SizeUtil.titleSmallFontSize().sp),
                        ),
                      ),
                      visible: item.discountPercent>0?true:false,
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
            _intoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: () => widget.onTapItem(item,item.id),
    );
  }

  int Check(int i) => i != product_data.length - 1 ? 2 : 1;
}
