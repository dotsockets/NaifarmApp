
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:like_button/like_button.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class ProductInto extends StatelessWidget {
  final ProducItemRespone data;
  final GlobalKey<ScaffoldState> scaffoldKey;
   ProductInto({Key key, this.data, this.scaffoldKey}) : super(key: key);
  ProductBloc bloc;

  void _init(BuildContext context) {
    if (null == bloc) {


      bloc = ProductBloc(AppProvider.getApplication(context));
      //bloc.ProductItem.add(widget.productItem);
      bloc.onError.stream.listen((event) {
        //checkScrollControl.add(true);
        if (event != null) {
          if (event.error.status == 406) {
            FunctionHelper.AlertDialogShop(context,
                title: "Error", message: event.error.message);
          }else if(event.error.status == 0 || event.error.status >= 500){

          }else {
            FunctionHelper.SnackBarShow(scaffoldKey: scaffoldKey, message: event.error.message);
          }
        }
      });


      bloc.onSuccess.stream.listen((event) {
        if(event is CartResponse){

        }else if(event is bool){
         // Usermanager().getUser().then((value) => bloc.GetMyWishlistsById(token: value.token,productId: data.id));
        }

      });

      Usermanager().getUser().then((value) => bloc.GetWishlistsByProduct(token: value.token,productID: data.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(left: 3.0.w,right: 1.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name.toString(),
              textAlign: TextAlign.center,
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.priceFontSize().sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            data.offerPrice!=null?Text("฿${data.salePrice}",style: FunctionHelper.FontTheme(
                color: Colors.grey,
                fontSize: SizeUtil.priceFontSize().sp, decoration: TextDecoration.lineThrough)):SizedBox(),
            SizedBox(width: data.offerPrice!=null?1.0.w:0),
            Text(data.offerPrice!=null?"฿${data.offerPrice}":"฿${data.salePrice}",maxLines: 1,
              overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
          ],
        ),
            Row(
              children: [
                Expanded(child: Text(
                  "${LocaleKeys.my_product_sold_end.tr()} ${data.saleCount!=null? data.saleCount.toString():'0'} ${LocaleKeys.cart_item.tr()}",
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
                ),),
                InkWell(
                  child: SvgPicture.asset(
                    'assets/images/svg/share.svg',
                    width: 8.0.w,
                    height: 8.0.w,
                  ),
                  onTap: () {
                    Share.share('${Env.value.baseUrlWeb}/${data.name}-i.${data.id}');
                    // FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                  },
                ),
                SizedBox(width: 1.0.h,),
                StreamBuilder(
                  stream: bloc.Wishlists.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot snapshot) {

                    if (snapshot.hasData && (snapshot.data as WishlistsRespone) != null) {
                      if ((snapshot.data as WishlistsRespone).total > 0) {
                        return LikeContent(item: snapshot.data);
                      } else {
                        return LikeContent(item: snapshot.data);
                      }
                    } else {
                      return LikeContent(item: WishlistsRespone());
                    }
                  },
                ),

              ],
            ),
            SizedBox(height: 15),
           // _IntroShipment()
          ],
        ),
      ),
    );
  }

  Widget LikeContent({WishlistsRespone item}){
    return LikeButton(
      size: 10.0.w,
      isLiked: item.total>0?true:false,
      circleColor: const CircleColor(
          start: Color(0xffF03A13), end: Color(0xffE6593A)),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Color(0xffF03A13),
        dotSecondaryColor: Color(0xffE6593A),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked?Icons.favorite:Icons.favorite_outline_sharp,
          color: isLiked ? ThemeColor.ColorSale() : Colors.black.withOpacity(0.55),
          size: 8.0.w,
        );
      },
      likeCountAnimationType: LikeCountAnimationType.part,
      likeCountPadding:  EdgeInsets.all(1.0.w),
      onTap: (bool like)=>onLikeButtonTapped(item.total>0?true:false,item),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked,WishlistsRespone item) async {


      if (item.total > 0) {
        int id = item.data[0].id;
        item.data = [];
        item.total = 0;
        bloc.Wishlists.add(item);
        Usermanager().getUser().then((value) =>
            bloc.DELETEWishlists(WishId: id, token: value.token));
      } else {

        Usermanager().getUser().then((value) => bloc.AddWishlists(
            productId: data.id,
            inventoryId: data
                .inventories[0].id,
            token: value.token));
        item.data = [];
        item.total = 1;
        bloc.Wishlists.add(item);
      }



    return !isLiked;
  }

  Widget _IntroShipment() {
    return Container(
      color: ThemeColor.primaryColor().withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/svg/delivery.svg',
              width: 8.0.w,
              height: 8.0.w,
            ),
            SizedBox(width: 2.0.w),
            Text(LocaleKeys.cart_free.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.ColorSale())),
            Text(LocaleKeys.cart_delivery_free.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

}
