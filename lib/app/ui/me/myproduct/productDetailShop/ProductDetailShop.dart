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
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductDetail.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductSlide.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ShopOwn.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';

import 'package:sizer/sizer.dart';

class ProductDetailShopView extends StatefulWidget {
  final int productId;

  ProductDetailShopView({Key key, this.productId}) : super(key: key);

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
      bloc.onLoad.stream.listen((event) {
        if (event) {
          //  FunctionHelper.showDialogProcess(context);
        }
      });
      bloc.onSuccess.stream.listen((event) {});

      Usermanager().getUser().then((value) => bloc.GetProductDetailShop(
          token: value.token, ProductId: widget.productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      key: _scaffoldKey,
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(

                      child: Column(
                        children: [
                          AppToobar(
                            title: "ดู" + LocaleKeys.me_title_my_product.tr(),
                            icon: "",
                            header_type: Header_Type.barNormal,
                          ),
                          StreamBuilder(
                              stream: bloc.onSuccess.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  var item =
                                      (snapshot.data as ProductMyShopRespone);
                                  return Column(
                                    children: [
                                      _BuildTitle(
                                          item: item,
                                          img: imgProductList(item: item)),
                                      SizedBox(
                                        height: 1.0.h,
                                      ),
                                      InkWell(
                                        child: ShopOwn(
                                          shopItem: ShopItem(
                                              name: item.shop.name,
                                              id: item.shopId,
                                              slug: item.slug,
                                              image: imgShopList(item: item)),
                                          shopRespone:
                                              MyShopRespone(id: item.shopId),
                                        ),
                                        onTap: () {
                                          AppRoute.ShopMain(
                                              context: context,
                                              myShopRespone: MyShopRespone(
                                                  id: item.shopId));
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
                                                  description:
                                                      item.description))),
                                    ],
                                  );
                                } else {
                                  return Container(
                                    color: Colors.white,
                                    child: Column(children: [
                                      SizedBox(height: 1.0.h),
                                        Skeleton.LoaderSlider(context),Skeleton.LoaderList(context)

                                    ],),
                                  );
                                }
                              }),
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

  Widget _BuildTitle({ProductMyShopRespone item, List<ProductImage> img}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ProductSlide(imgList: img),
          Text(item.name,
              style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
              )),
          SizedBox(
            height: 1.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item.offerPrice != null
                  ? Text("${item.offerPrice} ",
                      style: FunctionHelper.FontTheme(
                          color: Colors.grey.shade300,
                          fontSize: SizeUtil.priceFontSize().sp,
                          decoration: TextDecoration.lineThrough))
                  : Text(""),
              Text("฿ ${item.salePrice}",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.priceFontSize().sp,
                      color: ThemeColor.ColorSale())),
            ],
          ),
          SizedBox(
            height: 1.0.h,
          ),
          Text(
            "${LocaleKeys.my_product_sold.tr()} ${item.saleCount != null ? item.saleCount.toString() : '0'} ${LocaleKeys.cart_item.tr()}",
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          SizedBox(
            height: 1.0.h,
          ),
        ],
      ),
    );
  }
  List imgProductList({ProductMyShopRespone item}) {
    List<ProductImage> img = List<ProductImage>();
    for (int i = 0; i < item.image.length; i++)
      img.add((ProductImage(name: item.image[i].name, path: item.image[i].path)));
    return img;
  }

  List inventoryList({ProductMyShopRespone item}) {
    List<InventoriesProduct> inventory = List<InventoriesProduct>();
    for (int i = 0; i < item.image.length; i++)
      inventory.add((InventoriesProduct(stockQuantity: item.inventories[i].stockQuantity)));
    return inventory;
  }

  List imgShopList({ProductMyShopRespone item}) {
    List<ProductImage> img = List<ProductImage>();
    for (int i = 0; i < item.image.length; i++)
      img.add((ProductImage(name: item.shop.image[i].name, path: item.shop.image[i].path)));
    return img;
  }


}
