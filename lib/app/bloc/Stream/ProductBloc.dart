import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesRequest.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/BannersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/app/model/pojo/response/FeedbackRespone.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MarketObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductDetailCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductMoreCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UploadProductBloc.dart';

class ProductBloc {
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<ThrowIfNoSuccess>();
  final onSuccess = BehaviorSubject<Object>();

  final isStatus = BehaviorSubject<Object>();

  final productPopular = BehaviorSubject<ProductRespone>();
  final categoryGroup = BehaviorSubject<CategoryGroupRespone>();
  final featuredGroup = BehaviorSubject<CategoryGroupRespone>();
  final trendingGroup = BehaviorSubject<ProductRespone>();
  final searchProduct = BehaviorSubject<SearchRespone>();
  final productMartket = BehaviorSubject<ProductRespone>();
  final recommendProduct = BehaviorSubject<ProductRespone>();
  final moreProduct = BehaviorSubject<ProductRespone>();
  final moreFeedback = BehaviorSubject<FeedbackRespone>();
  final flashsale = BehaviorSubject<FlashsaleRespone>();
  final productMyShopRes = BehaviorSubject<ProductMyShopListRespone>();
  final productItem = BehaviorSubject<ProducItemRespone>();
  final myShop = BehaviorSubject<MyShopRespone>();
  final wishlists = BehaviorSubject<WishlistsRespone>();
  final bayNow = <ProductData>[];

  final zipProductDetail = BehaviorSubject<ProducItemRespone>();

  final zipMarketProfile = BehaviorSubject<MarketObjectCombine>();

  final zipHomeObject = BehaviorSubject<HomeObjectCombine>();

  final zipCategoryObject = BehaviorSubject<CategoryObjectCombin>();

  final zipShopObject = BehaviorSubject<ZipShopObjectCombin>();

  List<ProductData> productMore = <ProductData>[];
  List<FeedbackData> feedbackList = <FeedbackData>[];
  List<Hits> searchList = <Hits>[];
  List<ProductMyShop> productList = <ProductMyShop>[];



  ProductBloc(this._application){

  }

  void dispose() {
    _compositeSubscription.clear();
    featuredGroup.close();
    productMartket.close();
    recommendProduct.close();
    myShop.close();
    categoryGroup.close();
    moreProduct.close();
    flashsale.close();
    zipProductDetail.close();
    zipMarketProfile.close();
    zipHomeObject.close();
  }



  loadHomeData(
      {BuildContext context, String token, bool callback = false}) async {
    //  onLoad.add(true);
    StreamSubscription subscription = Rx.combineLatest8(
        Stream.fromFuture(_application.appStoreAPIRepository.getSliderImage(
          context,
        ))
        // สไลด์ภาพ
        ,
        Stream.fromFuture(_application.appStoreAPIRepository
            .getProductPopular(context, "1", 10)),
        // สินค้าขายดี
        Stream.fromFuture(
            _application.appStoreAPIRepository.getCategoryGroup(
          context,
        )),
        // หมวดหมู่ทั่วไป
        Stream.fromFuture(
            _application.appStoreAPIRepository.getCategoriesFeatured(
          context,
        )),
        // หมวดหมู่แนะนำ
        Stream.fromFuture(_application.appStoreAPIRepository
            .getProductTrending(context, "1", 6)),
        // สินค้าแนะนำ
        Stream.fromFuture(_application.appStoreAPIRepository
            .getShopProduct(context, shopId: 1, page: "1", limit: 10)),
        // สินค้าของ NaiFarm
        Stream.fromFuture(_application.appStoreAPIRepository
            .flashsale(context, page: "1", limit: 5)),
        //  Flashsale
        Stream.fromFuture(_application.appStoreAPIRepository.moreProduct(
            context,
            page: "1",
            limit: 10,
            link: "products/types/trending")),
        // สินค้าสำหรับคุน
        (a, b, c, d, e, f, g, h) {
      final _slider = (a as ApiResult).respone;
      final _product = (b as ApiResult).respone;
      final _category = (c as ApiResult).respone;
      final _featured = (d as ApiResult).respone;
      final _trending = (e as ApiResult).respone;
      final _martket = (f as ApiResult).respone;
      final _flashsale = (g as ApiResult).respone;
      final productForyou = (h as ApiResult).respone;

      return HomeObjectCombine(
          sliderRespone: _slider,
          productRespone: _product,
          categoryGroupRespone: _category,
          featuredRespone: _featured,
          trendingRespone: _trending,
          martket: _martket,
          flashsaleRespone: _flashsale,
          productForyou: productForyou);
    }).listen((event) {
      // onLoad.add(false);
      if (callback) {
        onSuccess.add(true);
      }
      // onSuccess.add(true);
      NaiFarmLocalStorage.saveHomeData(event)
          .then((value) => zipHomeObject.add(event));
    });
    _compositeSubscription.add(subscription);
  }

  loadProductPopular(BuildContext context, String page) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getProductPopular(context, page, 10))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        productPopular.add((respone.respone as ProductRespone));
      }
    });
    _compositeSubscription.add(subscription);
  }

  getMyWishlists(BuildContext context, {String token}) {
    //onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getMyWishlists(context, token: token))
        .listen((respone) {
      // onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        wishlists.add((respone.respone as WishlistsRespone));
        // NaiFarmLocalStorage.getHomeDataCache().then((value1){
        //   value1.wishlistsRespone = (respone.respone as WishlistsRespone);
        //   NaiFarmLocalStorage.saveHomeData(value1).then((value2) {
        //     Wishlists.add(value1.wishlistsRespone);
        //   });
        //
        // });

      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadProductTrending(BuildContext context,
      {String page, int limit = 10}) async {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getProductTrending(context, page, limit))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        trendingGroup.add(respone.respone);
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadProductSearch(BuildContext context,
      {String page, String query, int limit}) async {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getSearch(context, page: page, query: query, limit: limit))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        searchProduct.add((respone.respone as SearchRespone));
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadCategoryGroup(
    BuildContext context,
  ) {
    StreamSubscription subscription = Stream.fromFuture(
        _application.appStoreAPIRepository.getCategoryGroup(
      context,
    )).listen((respone) {
      if (respone.httpCallBack.status == 200) {
        categoryGroup.add((respone.respone as CategoryGroupRespone));
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadMartket(BuildContext context, String page) {
    StreamSubscription subscription = Rx.combineLatest3(
        Stream.fromFuture(_application.appStoreAPIRepository.farmMarket(
          context,
        )),
        Stream.fromFuture(_application.appStoreAPIRepository
            .getProductTrending(context, "1", 5)),
        Stream.fromFuture(_application.appStoreAPIRepository
            .getShopProduct(context, shopId: 1, page: "1", limit: 5)),
        (a, b, c) {
      final _market = (a as ApiResult).respone;
      final _hotproduct = (b as ApiResult).respone;
      final _recommend = (c as ApiResult).respone;
      return MarketObjectCombine(
          profileshop: _market, hotproduct: _hotproduct, recommend: _recommend);
    }).listen((event) {
      zipMarketProfile.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  loadMoreData(BuildContext context,
      {String page, int limit, String link, int typeMore = 0}) {
    if (typeMore == 1) {
      StreamSubscription subscription = Stream.fromFuture(
              _application.appStoreAPIRepository.getSearch(context,
                  query: "&categoryGroupId=$link", limit: limit, page: page))
          .listen((respone) {
        if (respone.httpCallBack.status == 200) {
          var item = (respone.respone as SearchRespone);
          if (page == "1") {
            NaiFarmLocalStorage.getProductMoreCache().then((value) {
              if (value != null) {
                for (var data in value.productRespone) {
                  if (data.slag == link) {
                    value.productRespone.remove(data);
                    break;
                  }
                }
                value.productRespone.add(ProductMoreCombin(
                    searchRespone: convertSearchData(item: item), slag: link));
                NaiFarmLocalStorage.saveProductMoreCache(value).then((value) {
                  productMore.addAll(convertSearchData(item: item).data);
                  moreProduct.add(convertSearchData(item: item));
                });
              } else {
                List<ProductMoreCombin> data = <ProductMoreCombin>[];
                data.add(ProductMoreCombin(
                    searchRespone: convertSearchData(item: item), slag: link));
                NaiFarmLocalStorage.saveProductMoreCache(ProducMoreCache(data))
                    .then((value) {
                  productMore.addAll(convertSearchData(item: item).data);
                  moreProduct.add(convertSearchData(item: item));
                });
              }
            });
          } else {
            productMore.addAll(convertSearchData(item: item).data);
            moreProduct.add(convertSearchData(item: item));
          }
        } else {
          onError.add(respone.httpCallBack);
        }
      });
      _compositeSubscription.add(subscription);
      // https://stg-api-test.naifarm.com/v1/products/types/popular?limit=10&page=1
    } else {
      StreamSubscription subscription = Stream.fromFuture(_application
              .appStoreAPIRepository
              .moreProduct(context, page: page, link: link, limit: limit))
          .listen((respone) {
        if (respone.httpCallBack.status == 200) {
          var item = (respone.respone as ProductRespone);
          if (page == "1") {
            NaiFarmLocalStorage.getProductMoreCache().then((value) {
              if (value != null) {
                for (var data in value.productRespone) {
                  if (data.slag == link) {
                    value.productRespone.remove(data);
                    break;
                  }
                }
                value.productRespone
                    .add(ProductMoreCombin(searchRespone: item, slag: link));
                NaiFarmLocalStorage.saveProductMoreCache(value).then((value) {
                  productMore.addAll(item.data);
                  moreProduct.add(ProductRespone(
                      data: productMore,
                      limit: item.limit,
                      page: item.page,
                      total: item.total));
                });
              } else {
                List<ProductMoreCombin> data = <ProductMoreCombin>[];
                data.add(ProductMoreCombin(searchRespone: item, slag: link));
                NaiFarmLocalStorage.saveProductMoreCache(ProducMoreCache(data))
                    .then((value) {
                  productMore.addAll(item.data);
                  moreProduct.add(ProductRespone(
                      data: productMore,
                      limit: item.limit,
                      page: item.page,
                      total: item.total));
                });
              }
            });
          } else {
            productMore.addAll(item.data);
            moreProduct.add(ProductRespone(
                data: productMore,
                limit: item.limit,
                page: item.page,
                total: item.total));
          }
        } else {
          onError.add(respone.httpCallBack);
        }
      });
      _compositeSubscription.add(subscription);
    }
  }

  loadFlashsaleData(BuildContext context, {String page, int limit}) {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .flashsale(context, page: page, limit: limit))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as FlashsaleRespone);
        for (var value in item.data[0].items) {
          productMore.add(value.product);
        }
        List<FlashsaleItems> itemTemp = <FlashsaleItems>[];
        for (var value in productMore) {
          itemTemp.add(FlashsaleItems(product: value));
        }
        List<FlashsaleData> data = <FlashsaleData>[];
        data.add(FlashsaleData(
            items: itemTemp,
            id: item.data[0].id,
            end: item.data[0].end,
            start: item.data[0].start));
        flashsale.add(FlashsaleRespone(
            data: data,
            total: item.total,
            limit: item.limit,
            page: item.page,
            loadmore: item.data[0].items.length > limit ? true : false));
      }
    });
    _compositeSubscription.add(subscription);
  }

  getWishlistsByProduct(BuildContext context, {int productID, String token}) {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getWishlistsByProduct(context, productID: productID, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        // var item = (respone.respone as DataWishlists);
        // print("wrfcd ${item}");
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteWishlists(BuildContext context,
      {int productId, int wishId, String token,bool reload=false}) {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .deleteWishlists(context, wishId: wishId, token: token))
        .listen((respone) {
      // Wishlists.add((respone.respone as WishlistsRespone));

      if (respone.httpCallBack.status == 200) {
        // GetMyWishlists(token: token);
        //Wishlists.add(WishlistsRespone(total: 0));
        //
        // ProducItemRespone tempProductItem = ProducItemRespone();
        // SearchRespone tempSearch = SearchRespone();
        // // DataWishlists tempWishlist = DataWishlists();
        // NaiFarmLocalStorage.getProductDetailCache().then((value) {
        //   if (value != null) {
        //     for (var data in value.item) {
        //       if (data.productObjectCombine.producItemRespone.id == productId) {
        //         tempProductItem = data.productObjectCombine.producItemRespone;
        //         tempSearch = data.searchRespone;
        //
        //         value.item.remove(data);
        //         break;
        //       }
        //     }
        //
        //     value.item.add(ProductDetailData(
        //         searchRespone: null,
        //         productObjectCombine:
        //             ProductObjectCombine(producItemRespone: tempProductItem)));
        //
        //     NaiFarmLocalStorage.saveProductDetailCache(value).then((data) {
        //       onSuccess.add(true);
        //     });
        //   }
        // });
        if(reload){
          wishlists.add(null);
        }

        onSuccess.add(true);
        isStatus.add(false);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addWishlists(BuildContext context,
      {int inventoryId, int productId, String token}) {
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.addWishlists(context,
                inventoryId: inventoryId, productId: productId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        // GetMyWishlists(token: token); GetWishlistsByProduct
        var item = (respone.respone as DataWishlists);
        ProducItemRespone tempProductItem = ProducItemRespone();
        SearchRespone tempSearch = SearchRespone();
        NaiFarmLocalStorage.getProductDetailCache().then((value) {
          if (value != null) {
            for (var data in value.item) {
              if (data.productObjectCombine.producItemRespone.id == productId) {
                tempProductItem = data.productObjectCombine.producItemRespone;
                tempSearch = data.searchRespone;
                value.item.remove(data);
                break;
              }
            }
            value.item.add(ProductDetailData(
                searchRespone: null,
                productObjectCombine: ProductObjectCombine(
                    producItemRespone: tempProductItem, dataWishlists: item)));

            NaiFarmLocalStorage.saveProductDetailCache(value).then((value) {
              if (item != null) {
                List<DataWishlists> data = <DataWishlists>[];
                data.add(item);
                wishlists.add(WishlistsRespone(data: data, total: 1));
              } else {
                List<DataWishlists> data = <DataWishlists>[];
                wishlists.add(WishlistsRespone(data: data, total: 0));
              }
            });
          }
        });
        isStatus.add(true);
        //  onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadProductsPage(BuildContext context, {int id, String token}) {
    //  onLoad.add(true);
    onError.add(null);

    Stream.fromFuture(
        _application.appStoreAPIRepository.productsById(context, id: id)).listen((event) {
      if (event.httpCallBack.status == 200) {
        var item = (event.respone as ProducItemRespone);
        if (item != null) {
          getSearchCategoryGroupId(context,
              productItem: item,
              groupId: item.categories[0].category != null
                  ? item.categories[0].category
                      .categorySubGroup.categoryGroup.id
                  : 0,
              limit: 10);
        }

        NaiFarmLocalStorage.getProductDetailCache().then((value) {
          if (value != null) {
            for (var data in value.item) {
              if (data.productObjectCombine.producItemRespone.id == id) {
                value.item.remove(data);
                break;
              }
            }

            value.item.add(ProductDetailData(
                productObjectCombine: ProductObjectCombine(
                    producItemRespone: item)));

            NaiFarmLocalStorage.saveProductDetailCache(value).then((data) {
              zipProductDetail.add(item);
            });
          } else {
            List<ProductDetailData> data = <ProductDetailData>[];
            data.add(ProductDetailData(productObjectCombine: ProductObjectCombine(producItemRespone: item)));

            NaiFarmLocalStorage.saveProductDetailCache(
                    ProductDetailCombin(data))
                .then((value) {
              zipProductDetail.add(item);
            });
          }
        });
      } else {
        onError.add(event.httpCallBack);
      }
    });
  }

  getProductsById(BuildContext context, {int id, bool onload}) {
    onLoad.add(true);
    Stream.fromFuture(
            _application.appStoreAPIRepository.productsById(context, id: id))
        .listen((event) {
      //  onLoad.add(false);
      if (event.httpCallBack.status == 200) {
        var item = (event.respone as ProducItemRespone);
        productItem.add(item);
      } else {
        onLoad.add(false);
        onError.add(event.httpCallBack);
      }
    });
  }

  getProductsByIdApplink(BuildContext context, {int id, bool onload}) {
    onLoad.add(true);
    Stream.fromFuture(
            _application.appStoreAPIRepository.productsById(context, id: id))
        .listen((event) {
      onLoad.add(false);
      if (event.httpCallBack.status == 200) {
        var item = (event.respone as ProducItemRespone);
        productItem.add(item);
      } else {
        onError.add(event.httpCallBack);
      }
    });
  }

  // loadProductsPage({int id,String token}){
  // //  onLoad.add(true);
  //   onError.add(null);
  //   StreamSubscription subscription = Stream.combineLatest2(
  //       Stream.fromFuture(_application.appStoreAPIRepository.ProductsById(id: id)),
  //       Stream.fromFuture(_application.appStoreAPIRepository.GetWishlistsByProduct(productID: id,token: token)),(a, b){
  //     final producItemRespone = (a as ApiResult).respone;
  //     final wishlistsRespone  =(b as ApiResult).respone;
  //
  //     if((a as ApiResult).httpCallBack.status==200){
  //
  //       return ProductObjectCombine(producItemRespone: producItemRespone,wishlistsRespone: wishlistsRespone);
  //
  //       }else{
  //
  //         onError.add((a as ApiResult).httpCallBack.result);
  //         return ProductObjectCombine();
  //
  //       }
  //
  //   }).listen((event) {
  //    // onLoad.add(false);
  //     if(event.producItemRespone!=null){
  //       GetSearchCategoryGroupId(GroupId: event.producItemRespone.categories[0].category.categorySubGroup.categoryGroup.id,limit: 10);
  //     }
  //     ZipProductDetail.add(event);
  //   });
  //   _compositeSubscription.add(subscription);
  // }

  // loadProductsById({int id,String token}){
  //   onError.add(null);
  //
  //   StreamSubscription subscription =
  //   Stream.fromFuture(_application.appStoreAPIRepository.ProductsById(id: id)).listen((respone) {
  //
  //     if(respone.httpCallBack.status==200){
  //      // GetMyWishlists(token: token);
  //       ProductItem.add(respone.respone);
  //     }else{
  //       onError.add(respone.httpCallBack);
  //     }
  //
  //   });
  //   _compositeSubscription.add(subscription);
  //
  //
  // }

  shopById(BuildContext context, {int shopid, String token}) {
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.shopById(context, id: shopid))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        getMyWishlists(context, token: token);
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadShop(BuildContext context, {int shopid, String token}) {
    onError.add(null);
    StreamSubscription subscription = Rx.combineLatest4(
        Stream.fromFuture(_application.appStoreAPIRepository
            .getProductTypeShop(context,
                type: "popular",
                shopId: shopid,
                limit: 10,
                page: "1",
                token: token)),
        Stream.fromFuture(_application.appStoreAPIRepository
            .getProductTypeShop(context,
                type: "trending",
                shopId: shopid,
                limit: 10,
                page: "1",
                token: token)),
        Stream.fromFuture(
            _application.appStoreAPIRepository.shopById(context, id: shopid)),
        Stream.fromFuture(_application.appStoreAPIRepository
            .getCategoryByShop(context, token: token, categoryId: shopid)),
        (a, b, c, d) {
      final productmyshop = (a as ApiResult).respone;
      final productrecommend = (b as ApiResult).respone;
      final shopRespone = (c as ApiResult).respone;
      final categoryRespone = (d as ApiResult).respone;

      if ((c as ApiResult).httpCallBack.status == 200) {
        return ZipShopObjectCombin(
            productmyshop: productmyshop,
            productrecommend: productrecommend,
            shopRespone: shopRespone,
            categoryGroupRespone: categoryRespone);
      } else {
        onError.add((c as ApiResult).httpCallBack);
        return ZipShopObjectCombin();
      }
    }).listen((event) {
      NaiFarmLocalStorage.getNaiFarmShopCache().then((value) {
        if (value != null) {
          for (var data in value.item) {
            if (data.shopRespone != null && data.shopRespone.id == shopid) {
              value.item.remove(data);
              break;
            }
          }

          value.item.add(event);

          NaiFarmLocalStorage.saveNaiFarmShopCache(value).then((value) {
            zipShopObject.add(event);
          });
        } else {
          List<ZipShopObjectCombin> data = <ZipShopObjectCombin>[];
          data.add(event);
          NaiFarmLocalStorage.saveNaiFarmShopCache(NaiFarmShopCombin(data))
              .then((value) {
            zipShopObject.add(event);
          });
        }
      });
    });
    _compositeSubscription.add(subscription);
  }

  loadCategoryPage(BuildContext context, {int groupId}) {
    onLoad.add(true);
    StreamSubscription subscription = Rx.combineLatest4(
        Stream.fromFuture(_application.appStoreAPIRepository
            .categorySubgroup(context, groupId: groupId)),
        Stream.fromFuture(_application.appStoreAPIRepository
            .categoryGroupId(context, groupId: groupId, limit: 10, page: "1")),
        Stream.fromFuture(_application.appStoreAPIRepository
            .getBanners(context, group: "home_middle")),
        Stream.fromFuture(_application.appStoreAPIRepository.moreProduct(
            context,
            limit: 10,
            page: "1",
            link: "products/types/popular?categoryGroupId=$groupId")),
        (a, b, d, e) {
      final _supgroup = (a as ApiResult).respone;
      final _groupproduct = (b as ApiResult).respone;
      final _banner = (d as ApiResult).respone;
      final _hotproduct = (e as ApiResult).respone;

      return CategoryObjectCombin(
          supGroup: (_supgroup as CategoryGroupRespone),
          goupProduct: (_groupproduct as ProductRespone),
          banner: (_banner as BannersRespone),
          hotProduct: (_hotproduct as ProductRespone));
    }).listen((event) {
      onLoad.add(false);
      zipCategoryObject.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  getSearchCategoryGroupId(BuildContext context,
      {ProducItemRespone productItem,
      DataWishlists dataWishlists,
      int groupId,
      int limit = 5,
      String page = "1"}) {
    Stream.fromFuture(_application.appStoreAPIRepository.getSearch(context,
            query: "&categoryGroupId=$groupId", limit: limit, page: page))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 401) {
        NaiFarmLocalStorage.getProductDetailCache().then((value) {
          if (value != null) {
            for (var data in value.item) {
              if (data.productObjectCombine.producItemRespone.id ==
                  productItem.id) {
                value.item.remove(data);
                break;
              }
            }
            value.item.add(ProductDetailData(
                searchRespone: null,
                productObjectCombine: ProductObjectCombine(
                    producItemRespone: productItem,
                    dataWishlists: dataWishlists)));

            NaiFarmLocalStorage.saveProductDetailCache(value).then((value) {
              searchProduct.add((respone.respone as SearchRespone));
            });
          }
        });
      } else {
        onError.add(respone.httpCallBack);
      }
    });
  }

  getProductMyShop(BuildContext context,
      {String page, int limit, String token, String filter}) {
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.getProductMyShop(context,
                page: page, limit: limit, token: token, filter: filter))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as ProductMyShopListRespone);
        if (page == "1") {
          productList.clear();
        }
        productList.addAll(item.data);
        productMyShopRes.add(ProductMyShopListRespone(
            data: productList,
            limit: item.limit,
            page: item.page,
            total: item.total));
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadSearchMyshop(BuildContext context,
      {String page,
      String query,
      int shopId,
      int limit,
      String filter,
      String token}) async {
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.getSearchShop(context,
                shopId: shopId,
                page: page,
                query: query,
                limit: limit,
                filter: filter,
                token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as SearchRespone);
        if (page == "1" && query.length != 0) {
          productList.clear();
        }
        for (var list in item.hits) {
          if (productList.length < item.nbHits) {
            ///ข้อมูลส่งมาซ้ำ หน้าถัดไป             8
            productList.add(ProductMyShop(
                image: list.image,
                id: list.productId,
                offerPrice: list.offerPrice,
                salePrice: list.salePrice,
                name: list.name,
                active: list.active,
                discountPercent: list.discountPercent,
                rating: list.rating));
          }
        }
        productMyShopRes.add(ProductMyShopListRespone(
            data: productList,
            limit: item.limit.toString(),
            total: item.nbHits));
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getProductCategoryGroupId(BuildContext context,
      {int groupId, int limit = 5, String page = "1"}) {
    Stream.fromFuture(_application.appStoreAPIRepository.moreProduct(
            context,
            link: "products/types/trending?categorySubGroupId=$groupId",
            limit: limit,
            page: page))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 401) {
        trendingGroup.add((respone.respone as ProductRespone));
      } else {
        onError.add(respone.httpCallBack);
      }
    });
  }

  updateProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest,
      int productId,
      String token,
      IsActive isActive}) {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.updateProductMyShop(context,
                shopRequest: shopRequest, productId: productId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
        onLoad.add(false);
        if (isActive == IsActive.UpdateProduct) {
          onSuccess.add(true);
        }
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateProductInventories(BuildContext context,
      {InventoriesRequest inventoriesRequest,
      int productId,
      int inventoriesId,
      String token,
      bool isload}) {
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.updateProductInventories(context,
                inventoriesRequest: inventoriesRequest,
                inventoriesId: inventoriesId,
                productId: productId,
                token: token))
        .listen((respone) {
      if (isload) {
        onLoad.add(false);
      }
      //  onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add((respone.respone as ProductShopItemRespone));
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  activeProduct(BuildContext context,
      {ProductMyShopRequest shopRequest,
      int productId,
      String token,
      IsActive isActive}) {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.activeProduct(context,
                active: shopRequest.active, productId: productId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        //onSuccess.add(true);
        var item = respone.respone as ProductShopItemRespone;
        var inventor = InventoriesRequest(
            title: item.name,
            offerPrice: item.offerPrice,
            stockQuantity: item.inventories[0].stockQuantity,
            salePrice: item.salePrice,
            active: shopRequest.active);
        Usermanager().getUser().then((value) => updateProductInventories(
            context,
            isload: true,
            inventoriesRequest: inventor,
            productId: item.id,
            inventoriesId: item.inventories[0].id,
            token: value.token));
        // onSuccess.add(respone.respone);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getCategoriesAll(
    BuildContext context,
  ) {
    StreamSubscription subscription = Rx.combineLatest3(
        Stream.fromFuture(
            _application.appStoreAPIRepository.getCategoriesAll(
          context,
        )),
        Stream.fromFuture(_application.appStoreAPIRepository.getCategories(
          context,
        )),
        Stream.fromFuture(_application.appStoreAPIRepository
            .statesProvice(context, countries: "1")), (a, b, c) {
      final _categorteAll = (a as ApiResult).respone;
      final _categortes = (b as ApiResult).respone;
      final _provice = (c as ApiResult).respone;
      return CategoryCombin(
          categoriesAllRespone: _categorteAll,
          categoriesRespone: _categortes,
          statesRespone: _provice);
    }).listen((respone) {
      NaiFarmLocalStorage.saveCategoriesAll(respone).then((value) {
        onSuccess.add(respone);
      });
    });
    _compositeSubscription.add(subscription);
  }

  void loadCustomerCount(BuildContext context, {String token}) {
    Stream.fromFuture(_application.appStoreAPIRepository
            .getCustomerCount(context, token: token))
        .listen((respone) {
      // print("esfwcersfc ${respone.http_call_back.status}");
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 401 ||
          respone.httpCallBack.status == 406) {
        if(respone.httpCallBack.status == 406){
          Usermanager().logout();
        }
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
  }

//CategoryCombin

  addCartlists(BuildContext context,
      {CartRequest cartRequest,
      String token,
      bool addNow = false,
      bool onload = true}) {
    // bayNow.clear();
    if (onload) {
      onLoad.add(true);
    }

    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .addCartlists(context, cartRequest: cartRequest, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        for (var value in cartRequest.items) {
          bayNow.add(ProductData(id: value.inventoryId));
        }
        Usermanager().getUser().then((value) => context
            .read<CustomerCountBloc>()
            .loadCustomerCount(context, token: value.token));
        onLoad.add(false);
        if (addNow) {
          onSuccess.add(true);
        } else {
          onSuccess.add((respone.respone as CartResponse));
        }
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteProductMyShop(BuildContext context, {int productId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .deleteProductMyShop(context, productId: productId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  Future<FeedbackRespone> getFeedbackFuture(BuildContext context,
      { int id, int limit, int page}) async {
    final respone = await _application.appStoreAPIRepository.
    getFeedback(context,page: page,limit: limit,id: id);
    if (respone.httpCallBack.status == 200) {
      return (respone.respone as FeedbackRespone);
    } else {
      return FeedbackRespone();
    }
  }

  Future<DataWishlists> getWishlistsByProductFuture(BuildContext context,{int id, String token}) async {

    final respone = await _application.appStoreAPIRepository.
    getWishlistsByProduct(context,productID: id,token: await Usermanager().isToken());
    if (respone.httpCallBack.status == 200) {
      return (respone.respone as DataWishlists);
    } else {
      return null;
    }
  }

  loadFeedback(BuildContext context, { int id, int limit, int page}) {
    StreamSubscription subscription = Stream.fromFuture(_application
        .appStoreAPIRepository
        .getFeedback(context,page: page,limit: limit,id: id))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        feedbackList.addAll((respone.respone as FeedbackRespone).data);
        moreFeedback.add(FeedbackRespone(data: feedbackList,total:(respone.respone as FeedbackRespone).total));
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  static ProducItemRespone convertDataToProduct({ProductData data}) {

    return ProducItemRespone(
      inventories: [InventoriesProduct(stockQuantity: data.stockQuantity)],
        name: data.name,
        salePrice: data.salePrice,
        hasVariant: data.hasVariant,
        brand: data.brand,
        minPrice: data.minPrice,
        maxPrice: data.maxPrice,
        slug: data.slug,
        offerPrice: data.offerPrice,
        id: data.id,
        saleCount: data.saleCount,
        discountPercent: data.discountPercent,
        rating:
            data.rating != null ? double.parse(data.rating.toString()) : 0.0,
        reviewCount: data.reviewCount,
        shop: ShopItem(
            id: data.shop.id,
            name: data.shop.name,
            slug: data.shop.slug,
            updatedAt: data.shop.updatedAt),
        image: data.image);
  }

  ProductRespone convertSearchData({SearchRespone item}) {
    List<ProductData> data = <ProductData>[];
    for (var value in item.hits) {
      data.add(ProductData(
          id: value.productId,
          brand: value.brand,
          name: value.name,
          saleCount: value.saleCount,
          salePrice: value.salePrice,
          image: value.image,
          discountPercent: value.discountPercent,
          rating: value.rating,
          offerPrice: value.offerPrice,
          minPrice: value.minPrice,
          maxPrice: value.maxPrice,
          shop: ProductShop(
              id: value.shopId, name: value.shop.name, slug: value.shop.slug)));
    }
    return ProductRespone(data: data);
  }
}
