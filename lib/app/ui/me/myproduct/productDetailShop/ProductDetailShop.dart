import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
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
import 'package:naifarm/app/ui/productdetail/widget/ProductInto.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductSlide.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ShopOwn.dart';

import 'package:sizer/sizer.dart';

class ProductDetailShopView extends StatefulWidget {
  final String productImage;
  final ProductMyShop productItem;

  ProductDetailShopView({Key key, this.productItem, this.productImage})
      : super(key: key);

  @override
  _ProductDetailShopViewState createState() => _ProductDetailShopViewState();
}

class _ProductDetailShopViewState extends State<ProductDetailShopView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UploadProductBloc bloc;
  MyShopRespone shop;

  @override
  void initState() {
    super.initState();
  }

  void _init() {
    if (null == bloc) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));

      bloc.onError.stream.listen((event) {
        FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });
      /* bloc.onLoad.stream.listen((event) {
        if (event) {
            FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.pop(context);
        }
      });*/
      bloc.onSuccess.stream.listen((event) {});

      Usermanager().getUser().then((value) => bloc.getProductDetailShop(context,
          token: value.token, productId: widget.productItem.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.me_title_my_product.tr(),
              icon: "",
              isEnableSearch: false,
              headerType: Header_Type.barNormal,
            ),
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
                                StreamBuilder(
                                    stream: bloc.productRes.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return buildTitle(
                                            img: (snapshot.data
                                                    as ProductMyShopRespone)
                                                .image);
                                      } else
                                        return Hero(
                                            tag: widget.productImage,
                                            child: ProductSlide(
                                                imgList:
                                                    widget.productItem.image));
                                    }),
                                StreamBuilder(
                                    stream: bloc.onSuccess.stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        var item = (snapshot.data
                                            as ProductMyShopRespone);
                                        return Column(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: ProductInto(
                                                  showBtn: false,
                                                  data: ProducItemRespone(
                                                    name: item.name,
                                                    salePrice: item.salePrice,
                                                    rating: item.rating,
                                                    offerPrice: item.offerPrice,
                                                    id: item.id,
                                                  ),
                                                  scaffoldKey: _scaffoldKey),
                                            ),
                                            InkWell(
                                              child: ShopOwn(
                                                rateStyle: true,
                                                shopItem: ShopItem(
                                                  rating: item.shop.rating,
                                                  name: item.shop.name != null
                                                      ? item.shop.name
                                                      : "-",
                                                  id: widget.productItem.shop !=
                                                          null
                                                      ? widget
                                                          .productItem.shop.id
                                                      : 0,
                                                  updatedAt:
                                                      item.shop.updatedAt,
                                                  slug:
                                                      widget.productItem.shop !=
                                                              null
                                                          ? widget.productItem
                                                              .shop.slug
                                                          : "-",
                                                  image:
                                                      imgShopList(item: item),
                                                  state: DataStates(
                                                      name: item.shop.state !=
                                                              null
                                                          ? item.shop.state.name
                                                          : "ไม่ถูกต้อง",
                                                      id: item.shop.state !=
                                                              null
                                                          ? item.shop.state.id
                                                          : 0),
                                                  countProduct: item.shop
                                                      .countProduct, //state:  DataStates(id: widget.productItem.shop.state.id,name: widget.productItem.shop.state.name)
                                                ),
                                                shopRespone: MyShopRespone(
                                                    id: widget.productItem
                                                                .shop !=
                                                            null
                                                        ? widget
                                                            .productItem.shop.id
                                                        : 0),
                                              ),
                                              onTap: () {
                                                AppRoute.shopMain(
                                                    context: context,
                                                    myShopRespone:
                                                        MyShopRespone(
                                                            id: widget
                                                                .productItem
                                                                .shop
                                                                .id));
                                              },
                                            ),
                                            SizedBox(
                                              height: 0.8.h,
                                            ),
                                            Container(
                                                color: Colors.white,
                                                child: ProductDetail(
                                                    productItem: ProducItemRespone(
                                                        shopId: item.shopId,
                                                        inventories:
                                                            inventoryList(
                                                                item: item),
                                                        shop: ShopItem(
                                                            id: item.shop.id,
                                                            state: item
                                                                .shop.state),
                                                        description:
                                                            item.description !=
                                                                    null
                                                                ? item
                                                                    .description
                                                                : "-")))
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 15.0.h,
                                            ),
                                            Platform.isAndroid
                                                ? CircularProgressIndicator()
                                                : CupertinoActivityIndicator(),
                                          ],
                                        );
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
      ),
    );
  }

  Widget buildTitle({List<ImageProductShop> img}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          FullScreenWidget(
            backgroundIsTransparent: true,
            child: Center(
              child: Hero(
                tag: widget.productImage,
                child: ProductSlide(imgList: imgProductList(imgRes: img)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List imgProductList({List<ImageProductShop> imgRes}) {
    List<ProductImage> img = [];

    if (imgRes != null) {
      for (int i = 0; i < imgRes.length; i++)
        img.add(ProductImage(name: imgRes[i].name, path: imgRes[i].path));
    } else {
      img.add(ProductImage(name: "", path: ""));
    }
    return img;
  }

  List inventoryList({ProductMyShopRespone item}) {
    List<InventoriesProduct> inventory = [];
    for (int i = 0; i < item.inventories.length; i++)
      inventory.add(
          InventoriesProduct(stockQuantity: item.inventories[i].stockQuantity));
    return inventory;
  }

  List imgShopList({ProductMyShopRespone item}) {
    List<ProductImage> img = [];

    if (item.shop.image != null || item.shop.image.length != 0) {
      for (int i = 0; i < item.shop.image.length; i++)
        img.add(ProductImage(
            name: item.shop.image[i].name, path: item.shop.image[i].path));
    } else {
      img.add(ProductImage(name: "", path: ""));
    }
    return img;
  }
}
