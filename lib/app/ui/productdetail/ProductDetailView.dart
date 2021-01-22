import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductDetailObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widget/BuildChoosesize.dart';
import 'widget/ProductDetail.dart';
import 'widget/ProductInto.dart';
import 'widget/ProductSlide.dart';
import 'widget/Reviewscore.dart';
import '../../../utility/widgets/ShopOwn.dart';
import 'package:sizer/sizer.dart';

class ProductDetailView extends StatefulWidget {
  final String productImage;
  ProducItemRespone productItem;

   ProductDetailView({Key key, this.productImage, this.productItem}) : super(key: key);

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>  with TickerProviderStateMixin{
  ScrollController scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   int IndexTypes1=1;
   int IndexTypes2=1;
  ProductBloc bloc;
  MyShopRespone shop;
   AnimationController _controller;
   Animation<double> _animation;
  StreamController<bool> checkScrollControl = new StreamController<bool>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkScrollControl.add(true);
    scrollController = ScrollController();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2500),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();

    scrollController.addListener(() {
      if(scrollController.offset == scrollController.position.maxScrollExtent){
       checkScrollControl.add(false);
      }else{
        checkScrollControl.add(true);
      }
    });

  }


  void _init(){

    if(null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.ProductItem.add(widget.productItem);
     bloc.onError.stream.listen((event) {
       checkScrollControl.add(false);
       FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
     });

     bloc.onLoad.stream.listen((event) {
       if (event) {
         //  FunctionHelper.SuccessDialog(context,message: "555");
         FunctionHelper.showDialogProcess(context);
       } else {
         Navigator.of(context).pop();
       }
     });
     bloc.onSuccess.stream.listen((event) {

     });

      Usermanager().getUser().then((value){
        bloc.GetWishlistsByProduct(productID: widget.productItem.id,token: value.token);
        bloc.loadProductsById(id: widget.productItem.id,token: value.token);
        bloc.loadProductTrending("1");
      });


    }

  }


   @override
   void dispose() {
     _controller.dispose();
     super.dispose();
   }




   @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child:  Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          AppToobar(header_type: Header_Type.barNoBackground,onClick: (){
                            Navigator.of(context).pop();
                          },),
                          StreamBuilder(
                              stream: bloc.onError.stream,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if(!snapshot.hasData) {
                                  return Content;
                                }else{
                                  return Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15.0.h),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset('assets/json/boxorder.json',
                                              height: 70.0.w, width: 70.0.w, repeat: false),
                                          Text(
                                            LocaleKeys.cart_empty.tr(),
                                            style: FunctionHelper.FontTheme(
                                                fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                          ),
                        ],
                      ),
                    ),

                    StreamBuilder<Object>(
                        stream: checkScrollControl.stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              left: 0.0,
                              child: Container(
                                color: Colors.white,
                                child: StreamBuilder(
                                  stream: bloc.Wishlists.stream,
                                  builder: (BuildContext context,AsyncSnapshot snapshot){
                                    if(snapshot.hasData){
                                      if((snapshot.data as WishlistsRespone).total>0){
                                        return  FadeTransition(
                                          ///Providing our animation to opacity property
                                          opacity: _animation,
                                          child: _BuildFooterTotal(item: (snapshot.data as WishlistsRespone)),
                                        );
                                      }else{
                                        return  FadeTransition(
                                          opacity: _animation,
                                          child: _BuildFooterTotal(item: (snapshot.data as WishlistsRespone)),
                                        );
                                      }

                                    }else{
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                          return SizedBox();
                        })
                  ],
                ),

              ),


            ],
          ),
        ),
      ),
    );
  }


  Widget get Content => Column(
    children: [
      Hero(tag: widget.productImage, child: ProductSlide(imgList: widget.productItem.image)),
      ProductInto(data: widget.productItem),
      _Divider(),
      StreamBuilder(
          stream: bloc.ProductItem.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) {
              var item = (snapshot.data as ProducItemRespone);
              return  Column(
                children: [
                  BuildChoosesize(IndexType1: IndexTypes1,IndexType2: IndexTypes2,onclick1: (int index)=>setState(() =>IndexTypes1 = index),onclick2: (int index)=>setState(() =>IndexTypes2 = index)),
                  _Divider(),
                  ShopOwn(shopItem: item.shop,shopRespone:
                  MyShopRespone(id: item.shopId)),
                  _Divider(),
                  ProductDetail(productItem: item),
                  _Divider(),
                  StreamBuilder(
                    stream: bloc.TrendingGroup.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData ) {
                        return  ProductLandscape(
                          productRespone:snapshot.data,
                          titleInto: LocaleKeys.recommend_you_like.tr(),
                          IconInto: 'assets/images/svg/like.svg',
                          onSelectMore: () {

                          },
                          onTapItem: (ProductData item,int index) {
                            AppRoute.ProductDetail(context,
                                productImage: "product_like_${index}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                          },
                          tagHero: "product_like",
                        );
                      }else{
                        return SizedBox();
                      }
                    },
                  ),
                  _Divider(),
                  Reviewscore()
                ],
              );
            }else{
              return SizedBox();
            }
          }
      )
    ],
  );



  Widget _BuildFooterTotal({WishlistsRespone item}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0),bottom: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0))
      ),
        child: Row(
          children: [
            Expanded(child: GestureDetector(
              child: SvgPicture.asset(
                'assets/images/svg/share.svg',
                width: 8.0.w,
                height: 8.0.w,
              ),
              onTap: (){

              },
            )),
            Container(
              color: Colors.grey.withOpacity(0.4),
              height: 8.0.h,
              width: 1,
            ),
            Expanded(child: GestureDetector(
              child: SvgPicture.asset(
                item.total>0?'assets/images/svg/like_line.svg':'assets/images/svg/like_line_null.svg',
                width: 8.0.w,
                height: 8.0.w,
                color: ThemeColor.ColorSale(),
              ),
              onTap: (){
                if(item.total>0){
                  int id = item.data[0].id;
                  item.data = [];
                  item.total = 0;
                  bloc.Wishlists.add(item);
                  Usermanager().getUser().then((value) => bloc.DELETEWishlists(WishId:id,token: value.token));
                }else{
                  Usermanager().getUser().then((value) => bloc.AddWishlists(productId: widget.productItem.id,inventoryId: bloc.ProductItem.value.inventories[0].id,token: value.token));
                  item.data = [];
                  item.total = 1;
                  bloc.Wishlists.add(item);
                }
              },
            )),
            Expanded(
                flex: 2,
                child: InkWell(
                  onTap:(){
                    if(bloc.ProductItem.value.inventories[0].stockQuantity>0){
                      List<Items> items = new List<Items>();
                      items.add(Items(inventoryId: bloc.ProductItem.value.inventories[0].id,quantity: 1));
                      Usermanager().getUser().then((value) => bloc.AddCartlists(cartRequest: CartRequest(
                        shopId: widget.productItem.shop.id,
                        items:items,
                      ),token: value.token));
                    }else{
                      FunctionHelper.FailDialog(context,message: "ไม่สามารถทำรายการได้เนื่องจากไม่มีสินค้าในร้านในขณะนี้ กรุณาติดต่อกับทางร้าน");
                    }

                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 8.0.h,
                      color: ThemeColor.ColorSale(),
                      child: Text(LocaleKeys.buy_product_btn.tr(),
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ))
          ],
        ),
    );
  }



  Widget _Divider() {
    return Container(
      color: Colors.black.withOpacity(0.2),
      height: 2.0.w,
    );
  }


}
