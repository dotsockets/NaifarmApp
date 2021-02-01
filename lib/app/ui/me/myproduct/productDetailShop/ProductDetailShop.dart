import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductDetail.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductSlide.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ShopOwn.dart';

import 'package:sizer/sizer.dart';

class ProductDetailShopView extends StatefulWidget {
  final String productImage;
  ProductMyShop productItem;

  ProductDetailShopView({Key key, this.productItem,this.productImage}) : super(key: key);

  @override
  _ProductDetailShopViewState createState() => _ProductDetailShopViewState();
}

class _ProductDetailShopViewState extends State<ProductDetailShopView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UploadProductBloc bloc;
  MyShopRespone shop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _init() {

    if (null == bloc) {

      bloc = UploadProductBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });
     /* bloc.onLoad.stream.listen((event) {
        if (event) {
            FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.pop(context);
        }
      });*/
      bloc.onSuccess.stream.listen((event) {});

      Usermanager().getUser().then((value) => bloc.GetProductDetailShop(
          token: value.token, ProductId: widget.productItem.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar:  AppToobar(
          title: LocaleKeys.me_title_my_product.tr(),
          icon: "",
          header_type: Header_Type.barNormal,
        ),
        body: Container(
          color: Colors.grey.shade300,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              _BuildTitle(),
                              SizedBox(
                                height: 1.0.h,
                              ),
                              SizedBox(
                                height: 1.0.h,
                              ),

                              StreamBuilder(
                                  stream: bloc.onSuccess.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      var item = (snapshot.data as ProductMyShopRespone);
                                      return Column(
                                        children: [
                                          InkWell(
                                            child: ShopOwn(
                                              shopItem: ShopItem(rating: widget.productItem.rating,
                                                name: widget.productItem.shop!=null?widget.productItem.shop.name:"-",
                                                id: widget.productItem.shop!=null?widget.productItem.shop.id:0,
                                                updatedAt: widget.productItem.shop!=null?widget.productItem.shop.updatedAt:"",
                                                slug: widget.productItem.shop!=null?widget.productItem.shop.slug:"-",
                                                image: imgShopList(item: item),state: DataStates(name:item.shop.state.name,id: item.shop.state.id),
                                                countProduct: item.shop.countProduct
                                                ,//state:  DataStates(id: widget.productItem.shop.state.id,name: widget.productItem.shop.state.name)
                                              ),
                                              shopRespone:
                                              MyShopRespone(id: widget.productItem.shop!=null?widget.productItem.shop.id:0),
                                            ),
                                            onTap: () {
                                              AppRoute.ShopMain(
                                                  context: context,
                                                  myShopRespone: MyShopRespone(
                                                      id: widget.productItem.shop.id));
                                            },
                                          ),
                                          SizedBox(
                                            height: 1.0.h,
                                          ),
                                          Container(
                                              color: Colors.white,
                                              child: ProductDetail(
                                                  productItem: ProducItemRespone(
                                                      shopId: item.shopId,
                                                      inventories: inventoryList(item: item),
                                                      description: item.description!= null?item.description:"-")
                                              )
                                          )
                                        ],
                                      );
                                    } else {
                                      return Text("");
                                    }
                                  }),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildTitle() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Hero(tag: widget.productImage, child: ProductSlide(imgList:imgProductList())),
        Container(
          width: 80.0.w,
          child: Text(
            widget.productItem.name,
            textAlign: TextAlign.center,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.priceFontSize().sp, fontWeight: FontWeight.w500),
          ),
        )
          ,SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
             widget.productItem.offerPrice != null
                  ? Text("${widget.productItem.salePrice}",
                      style: FunctionHelper.FontTheme(
                          color: Colors.grey.shade300,
                          fontSize: SizeUtil.priceFontSize().sp-2,
                          decoration: TextDecoration.lineThrough))
                  : Text(""),
              SizedBox(width: widget.productItem.offerPrice!=null?1.0.w:0),
              Text(widget.productItem.offerPrice!=null?"฿ ${widget.productItem.offerPrice}":"฿ ${widget.productItem.salePrice}",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.priceFontSize().sp,
                      color: ThemeColor.ColorSale())),
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Text(
            "${LocaleKeys.my_product_sold.tr()} ${widget.productItem.saleCount != null ? widget.productItem.saleCount.toString() : '0'} ${LocaleKeys.cart_item.tr()}",
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          SizedBox(
            height: 2.0.h,
          ),
        ],
      ),
    );
  }
  List imgProductList() {
    List<ProductImage> img = List<ProductImage>();

    if(widget.productItem.image!=null) {
      for (int i = 0; i < widget.productItem.image.length; i++)
        img.add(ProductImage(name: widget.productItem.image[i].name,
            path: widget.productItem.image[i].path));
    }else{
      img.add(ProductImage(name: "", path: ""));
    }
    return img;
  }

  List inventoryList({ProductMyShopRespone item}) {
    List<InventoriesProduct> inventory = List<InventoriesProduct>();
    for (int i = 0; i < item.inventories.length; i++)
      inventory.add(InventoriesProduct(stockQuantity: item.inventories[i].stockQuantity));
    return inventory;
  }

  List imgShopList({ProductMyShopRespone item}) {
    List<ProductImage> img = List<ProductImage>();
    if(item.shop.image!=null) {
    for (int i = 0; i < item.image.length; i++)
      img.add(ProductImage(name: item.shop.image[i].name, path: item.shop.image[i].path));
    }else{
      img.add(ProductImage(name: "", path: ""));
    } return img;
  }


}
