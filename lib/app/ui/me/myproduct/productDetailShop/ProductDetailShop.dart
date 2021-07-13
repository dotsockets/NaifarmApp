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
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductDetail.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductInto.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductSlide.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ShopOwn.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";
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
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
      bloc.onSuccess.stream.listen((event) {});
      _getProduct();
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
            preferredSize: Size.fromHeight(7.0.h),
            child: AppToobar(
              title: LocaleKeys.my_product_see.tr(),
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
                                        return Column(
                                          children: [
                                            buildTitle(
                                                img: (snapshot.data
                                                        as ProductShopItemRespone)
                                                    .images),
                                            buildProductDetail(snapshot.data
                                                as ProductShopItemRespone),
                                          ],
                                        );
                                      } else
                                        // return Hero(
                                        //     tag: widget.productImage,
                                        //     child: ProductSlide(
                                        //         imgList:
                                        //             widget.productItem.image));
                                        return Column(
                                          children: [
                                            Container(

                                              child: ProductSlide(
                                                  imgList:convertImageProduct(),stockQuantity: widget.productItem.stockQuantity),color: Colors.white,
                                            ),
                                            buildProductDetail(
                                                ProductShopItemRespone(
                                                    rating: widget
                                                        .productItem.rating,
                                                    name: widget
                                                        .productItem.name,
                                                    discountPercent: widget
                                                        .productItem
                                                        .discountPercent,
                                                    salePrice: widget
                                                        .productItem.salePrice,
                                                    offerPrice: widget
                                                        .productItem.offerPrice,
                                                    reviewCount: widget
                                                        .productItem.reviewCount
                                                        .toDouble())),
                                          ],
                                        );
                                    }),
                                StreamBuilder(
                                    stream: bloc.onSuccess.stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        var item = (snapshot.data
                                            as ProductShopItemRespone);
                                        return Column(
                                          children: [
                                            InkWell(
                                              child: ShopOwn(
                                                rateStyle: true,
                                                shopItem: ShopItem(
                                                  rating: item.shop != null
                                                      ? item.shop.rating
                                                      : 0,
                                                  name: item.shop.name != null
                                                      ? item.shop.name
                                                      : "-",
                                                  id: widget.productItem.shop !=
                                                          null
                                                      ? widget
                                                          .productItem.shop.id
                                                      : 0,
                                                  updatedAt:
                                                      item.shop.updatedAt !=
                                                              null
                                                          ? item.shop.updatedAt
                                                          : "-",
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
                                                            state: DataStates(id: item
                                                                .shop.state.id,name: item
                                                                .shop.state.name)),
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

  Widget buildProductDetail(ProductShopItemRespone item) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ProductInto(
              showBtn: false,
              data: ProducItemRespone(
                name: item.name,
                salePrice: item.salePrice,
                saleCount: item.saleCount,
                rating: item.rating == null
                    ? 0.0
                    : double.parse(item.rating.toString()),
                offerPrice: item.offerPrice,
                id: item.id,
              ),
              scaffoldKey: _scaffoldKey),
        ),
        SizedBox(
          height: 0.8.h,
        ),
      ],
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
              child: ProductSlide(imgList: imgProductList(imgRes: img)),
            ),
          ),
        ],
      ),
    );
  }

  List imgProductList({List<ImageProductShop> imgRes}) {

    List<String> image = <String>[];
    if (imgRes.isNotEmpty) {
      for (var item in imgRes) {
        image.add("${item.path.imgUrl()}");
      }
    }else{
      image.add("");
    }
    return image;
    // if (imgRes != null) {
    //   for (int i = 0; i < imgRes.length; i++)
    //    // img.add(ProductImage(name: imgRes[i].name, path: imgRes[i].path));
    //     imgList.add(ProductImage(name: imgRes[i].name, path: imgRes[i].path));
    // } else {
    //   img.add(ProductImage(name: "", path: ""));
    // }
    // return img;
  }


  List inventoryList({ ProductShopItemRespone item}) {
    List<InventoriesProduct> inventory = <InventoriesProduct>[];
    for (int i = 0; i < item.inventories.length; i++)
      inventory.add(
          InventoriesProduct(stockQuantity: item.inventories[i].stockQuantity));
    return inventory;
  }


  List imgShopList({  ProductShopItemRespone item}) {
    List<ProductImage> img = <ProductImage>[];

    if (item.shop.images != null || item.shop.images.length != 0) {
      for (int i = 0; i < item.shop.images.length; i++)
        img.add(ProductImage(
            name: item.shop.images[i].name, path: item.shop.images[i].path));
    } else {
      img.add(ProductImage(name: "", path: ""));
    }
    return img;
  }

  List<String> convertImageProduct() {
    List<String> image = <String>[];
    if (widget.productItem.image.isNotEmpty) {
      for (var item in widget.productItem.image) {
        image.add("${item.path.imgUrl()}");
      }
    }else{
      image.add("");
    }
    return image;
  }

  _getProduct(){
    NaiFarmLocalStorage.getProductMyShopCache().then((value) {
      if (value != null) {
        for (var data in value.item) {
          if (data.id == widget.productItem.id) {
            bloc.productRes.add(data);
            bloc.onSuccess.add(data);
            break;
          }
        }
      }
      Usermanager().getUser().then((value) => bloc.getProductDetailShop(
          context,
          token: value.token,
          productId: widget.productItem.id));
    });
  }
}
