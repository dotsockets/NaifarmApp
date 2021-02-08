
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/BannersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MarketObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/SliderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Result>();
  final onSuccess = BehaviorSubject<Object>();

  final ProductPopular = BehaviorSubject<ProductRespone>();
  final CategoryGroup = BehaviorSubject<CategoryGroupRespone>();
  final FeaturedGroup = BehaviorSubject<CategoryGroupRespone>();
  final TrendingGroup = BehaviorSubject<ProductRespone>();
  final SearchProduct = BehaviorSubject<SearchRespone>();
  final ProductMartket = BehaviorSubject<ProductRespone>();
  final RecommendProduct =  BehaviorSubject<ProductRespone>();
  final MoreProduct =  BehaviorSubject<ProductRespone>();
  final Flashsale =  BehaviorSubject<FlashsaleRespone>();
  final ProductItem =  BehaviorSubject<ProducItemRespone>();
  final myShop = BehaviorSubject<MyShopRespone>();
  final Wishlists = BehaviorSubject<WishlistsRespone>();


  final ZipProductDetail = BehaviorSubject<ProductObjectCombine>();

  final ZipMarketProfile = BehaviorSubject<MarketObjectCombine>();

  final ZipHomeObject = BehaviorSubject<HomeObjectCombine>();

  final ZipCategoryObject = BehaviorSubject<CategoryObjectCombin>();

  final ZipShopObject = BehaviorSubject<ZipShopObjectCombin>();

  List<ProductData> product_more = List<ProductData>();


  ProductBloc(this._application){
    Wishlists.add(WishlistsRespone());
  }

  void dispose() {
    _compositeSubscription.clear();
  }


  loadHomeData({BuildContext context,String token,bool callback=false})async{
    StreamSubscription subscription = Observable.combineLatest8(Observable.fromFuture(_application.appStoreAPIRepository.getSliderImage()) // สไลด์ภาพ
        , Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular("1",10)), // สินค้าขายดี
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoryGroup()), // หมวดหมู่ทั่วไป
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoriesFeatured()), // หมวดหมู่แนะนำ
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",6)), // สินค้าแนะนำ
        Observable.fromFuture(_application.appStoreAPIRepository.getShopProduct(ShopId: 1,page: "1",limit: 10)), // สินค้าของ NaiFarm
        Observable.fromFuture(_application.appStoreAPIRepository.Flashsale(page: "1",limit: 5)), //  Flashsale
        Observable.fromFuture(_application.appStoreAPIRepository.MoreProduct(page: "1",limit: 10,link: "products/types/trending")), // สินค้าสำหรับคุน
            (a, b,c,d,e,f,g,h){
            final _slider = (a as ApiResult).respone;
            final _product  =(b as ApiResult).respone;
            final _category =(c as ApiResult).respone;
            final _featured =(d as ApiResult).respone;
            final _trending =(e as ApiResult).respone;
            final _martket =(f as ApiResult).respone;
            final _flashsale =(g as ApiResult).respone;
            final product_foryou =(h as ApiResult).respone;


            return HomeObjectCombine(sliderRespone: _slider,
                productRespone: _product, categoryGroupRespone: _category,featuredRespone: _featured,
            trendingRespone: _trending,martket: _martket,flashsaleRespone: _flashsale,product_foryou: product_foryou);

        }).listen((event) {

          if(callback){
            onSuccess.add(true);
          }
     // onSuccess.add(true);
            NaiFarmLocalStorage.saveHomeData(event).then((value) => ZipHomeObject.add(event));

    });
    _compositeSubscription.add(subscription);
  }

  loadProductPopular(String page)async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular(page,10)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        ProductPopular.add((respone.respone as ProductRespone));
      }

    });
    _compositeSubscription.add(subscription);
  }

  GetMyWishlists({String token}){
    //onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetMyWishlists(token: token)).listen((respone) {
     // onLoad.add(false);
      if(respone.http_call_back.status==200){

        Wishlists.add((respone.respone as WishlistsRespone));
        // NaiFarmLocalStorage.getHomeDataCache().then((value1){
        //   value1.wishlistsRespone = (respone.respone as WishlistsRespone);
        //   NaiFarmLocalStorage.saveHomeData(value1).then((value2) {
        //     Wishlists.add(value1.wishlistsRespone);
        //   });
        //
        // });


      }else{
        onError.add(respone.http_call_back.result);
      }

    });
    _compositeSubscription.add(subscription);
  }

  GetMyWishlistsById({String token,int productId}){
    //onLoad.add(true);

    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetMyWishlists(token: token)).listen((respone) {
      // onLoad.add(false);
      if(respone.http_call_back.status==200){

        for(var item in (respone.respone as WishlistsRespone).data){
          if(item.productId==productId){
            Wishlists.add((respone.respone as WishlistsRespone));
            break;
          }
        }

        // NaiFarmLocalStorage.getHomeDataCache().then((value1){
        //   value1.wishlistsRespone = (respone.respone as WishlistsRespone);
        //   NaiFarmLocalStorage.saveHomeData(value1).then((value2) {
        //     Wishlists.add(value1.wishlistsRespone);
        //   });
        //
        // });


      }else{
        onError.add(respone.http_call_back.result);
      }

    });
    _compositeSubscription.add(subscription);
  }

  loadProductTrending({String page,int limit=10})async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending(page,limit)).listen((respone) {
      if(respone.http_call_back.status==200){
        TrendingGroup.add(respone.respone);
      }

    });
    _compositeSubscription.add(subscription);
  }

  loadProductSearch({String page,String query,int limit})async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getSearch(page: page,query: query,limit: limit)).listen((respone) {
      if(respone.http_call_back.status==200){
        SearchProduct.add((respone.respone as SearchRespone));
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadSearchMyshop({String page, String query, int shopId, int limit})async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getSearchMyshop(shopId: shopId,page: page,query: query,limit: limit)).listen((respone) {
      if(respone.http_call_back.status==200){
        SearchProduct.add((respone.respone as SearchRespone));
      }else{
        onError.add(respone.http_call_back.result);
      }
    });
    _compositeSubscription.add(subscription);
  }




  loadCategoryGroup(){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getCategoryGroup()).listen((respone) {
      if(respone.http_call_back.status==200){
        CategoryGroup.add((respone.respone as CategoryGroupRespone));
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadMartket(String page){


    StreamSubscription subscription = Observable.combineLatest3(
        Observable.fromFuture(_application.appStoreAPIRepository.FarmMarket()),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",5)),
        Observable.fromFuture(_application.appStoreAPIRepository.getShopProduct(ShopId: 1,page: "1",limit: 5)),(a, b,c){
          final _market = (a as ApiResult).respone;
          final _hotproduct  =(b as ApiResult).respone;
          final _recommend =(c as ApiResult).respone;
          return MarketObjectCombine(profileshop: _market,hotproduct: _hotproduct,recommend: _recommend);

        }).listen((event) {
      ZipMarketProfile.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  loadMoreData({String page, int limit, String link,int type_more=0}){
    if(type_more==1){
      StreamSubscription subscription =
      Observable.fromFuture(_application.appStoreAPIRepository.getSearch(query: "&categoryGroupId=${link}",limit: limit,page: page)).listen((respone) {
        if(respone.http_call_back.status==200 ){
          var item = (respone.respone as SearchRespone);
          product_more.addAll(ConvertSearchData(item: item).data);
          MoreProduct.add(ConvertSearchData(item: item));

        }else{
          onError.add(respone.http_call_back.result);
        }
      });
      _compositeSubscription.add(subscription);
   // https://stg-api-test.naifarm.com/v1/products/types/popular?limit=10&page=1
    }else{
      StreamSubscription subscription =
      Observable.fromFuture(_application.appStoreAPIRepository.MoreProduct(page: page,link: link,limit: limit)).listen((respone) {
        if(respone.http_call_back.status==200){
          var item = (respone.respone as ProductRespone);

          product_more.addAll(item.data);
          MoreProduct.add(ProductRespone(data: product_more,limit: item.limit,page: item.page,total: item.total));
        }
      });
      _compositeSubscription.add(subscription);
    }

  }

  loadFlashsaleData({String page, int limit, String link}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.Flashsale(page: page,limit: limit)).listen((respone) {
      if(respone.http_call_back.status==200){
        Flashsale.add((respone.respone as FlashsaleRespone));
      }
    });
    _compositeSubscription.add(subscription);
  }

  GetWishlistsByProduct({int productID,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetWishlistsByProduct(productID: productID,token: token)).listen((respone) {
      Wishlists.add((respone.respone as WishlistsRespone));
    });
    _compositeSubscription.add(subscription);
  }

  DELETEWishlists({int WishId,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.DELETEWishlists(WishId: WishId,token: token)).listen((respone) {
     // Wishlists.add((respone.respone as WishlistsRespone));

      if(respone.http_call_back.status==200){
       // GetMyWishlists(token: token);
       onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result);
      }


    });
    _compositeSubscription.add(subscription);
  }

  AddWishlists({int inventoryId,int productId,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddWishlists(inventoryId: inventoryId,productId: productId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
       // GetMyWishlists(token: token);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result);
      }

    });
    _compositeSubscription.add(subscription);
  }


  loadProductsPage({int id,String token}){
    //  onLoad.add(true);
    onError.add(null);
    Observable.fromFuture(_application.appStoreAPIRepository.ProductsById(id: id)).listen((event) {
      if(event.http_call_back.status==200){
        var item = (event.respone as ProducItemRespone);
        if(item!=null){
          GetSearchCategoryGroupId(GroupId: item.categories[0].category.categorySubGroup.categoryGroup.id,limit: 10);
        }
        ZipProductDetail.add(ProductObjectCombine(producItemRespone: item));
      }else{
        onError.add(event.http_call_back.result);
      }
    });


  }


  // loadProductsPage({int id,String token}){
  // //  onLoad.add(true);
  //   onError.add(null);
  //   StreamSubscription subscription = Observable.combineLatest2(
  //       Observable.fromFuture(_application.appStoreAPIRepository.ProductsById(id: id)),
  //       Observable.fromFuture(_application.appStoreAPIRepository.GetWishlistsByProduct(productID: id,token: token)),(a, b){
  //     final producItemRespone = (a as ApiResult).respone;
  //     final wishlistsRespone  =(b as ApiResult).respone;
  //
  //     if((a as ApiResult).http_call_back.status==200){
  //
  //       return ProductObjectCombine(producItemRespone: producItemRespone,wishlistsRespone: wishlistsRespone);
  //
  //       }else{
  //
  //         onError.add((a as ApiResult).http_call_back.result);
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
  //   Observable.fromFuture(_application.appStoreAPIRepository.ProductsById(id: id)).listen((respone) {
  //
  //     if(respone.http_call_back.status==200){
  //      // GetMyWishlists(token: token);
  //       ProductItem.add(respone.respone);
  //     }else{
  //       onError.add(respone.http_call_back.result);
  //     }
  //
  //   });
  //   _compositeSubscription.add(subscription);
  //
  //
  // }

  ShopById({int shopid,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ShopById(id: shopid)).listen((respone) {
      if(respone.http_call_back.status==200){
        GetMyWishlists(token: token);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result);
      }

    });
    _compositeSubscription.add(subscription);
  }


  loadShop({int shopid,String token}){
    onError.add(null);
    StreamSubscription subscription = Observable.combineLatest4(
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTypeShop(type:"popular" ,shopId: shopid,limit: 10,page: "1",token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTypeShop(type:"trending" ,shopId: shopid,limit: 10,page: "1",token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository.ShopById(id: shopid)),
        Observable.fromFuture(_application.appStoreAPIRepository.GetCategoryByShop(token: token,CategoryId: shopid)),(a, b,c,d){
      final productmyshop = (a as ApiResult).respone;
      final productrecommend  =(b as ApiResult).respone;
      final shopRespone  =(c as ApiResult).respone;
      final categoryRespone  =(d as ApiResult).respone;

      if((c as ApiResult).http_call_back.status==200){
        return ZipShopObjectCombin(productmyshop: productmyshop,productrecommend: productrecommend,shopRespone: shopRespone,categoryGroupRespone: categoryRespone);
      }else{
        onError.add((c as ApiResult).http_call_back.result);
        return ZipShopObjectCombin();

      }


    }).listen((event) {
      ZipShopObject.add(event);
    });
    _compositeSubscription.add(subscription);


  }



  loadCategoryPage({int GroupId}){
    onLoad.add(true);
    StreamSubscription subscription = Observable.combineLatest4(
        Observable.fromFuture(_application.appStoreAPIRepository.CategorySubgroup(GroupId: GroupId)),
        Observable.fromFuture(_application.appStoreAPIRepository.categoryGroupId(GroupId: GroupId,limit: 10,page: "1")),
        Observable.fromFuture(_application.appStoreAPIRepository.GetBanners(group: "home_middle")),
        Observable.fromFuture(_application.appStoreAPIRepository.MoreProduct(limit: 10,page: "1",link: "products/types/popular?categoryGroupId=${GroupId}")),(a, b,d,e){
      final _supgroup = (a as ApiResult).respone;
      final _groupproduct  =(b as ApiResult).respone;
      final _banner  =(d as ApiResult).respone;
      final _hotproduct  =(e as ApiResult).respone;

      return CategoryObjectCombin(supGroup: (_supgroup as CategoryGroupRespone),goupProduct: (_groupproduct as ProductRespone),banner: (_banner as BannersRespone),hotProduct: (_hotproduct as ProductRespone));

    }).listen((event) {
      onLoad.add(false);
      ZipCategoryObject.add(event);
    });
    _compositeSubscription.add(subscription);
  }


  GetSearchCategoryGroupId({int GroupId,int limit=5,String page="1"}){
    Observable.fromFuture(_application.appStoreAPIRepository.getSearch(query: "&categoryGroupId=${GroupId}",limit: limit,page: page)).listen((respone) {
      if(respone.http_call_back.status==200 || respone.http_call_back.result.error.status==401){
        SearchProduct.add((respone.respone as SearchRespone));
      }else{
        onError.add(respone.http_call_back.result);
      }
    });
  }


  GetProductCategoryGroupId({int GroupId,int limit=5,String page="1"}){
    Observable.fromFuture(_application.appStoreAPIRepository.MoreProduct(link:  "products/types/trending?categorySubGroupId=${GroupId}",limit: limit,page: page)).listen((respone) {
      if(respone.http_call_back.status==200 || respone.http_call_back.result.error.status==401){
        TrendingGroup.add((respone.respone as ProductRespone));
      }else{
        onError.add(respone.http_call_back.result);
      }
    });
  }



  GetCategoriesAll(){


    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.GetCategoriesAll()),
        Observable.fromFuture(_application.appStoreAPIRepository.GetCategories()),(a, b){
      final _categorteAll= (a as ApiResult).respone;
      final _categortes  =(b as ApiResult).respone;
      return CategoryCombin(categoriesAllRespone: _categorteAll,categoriesRespone: _categortes);

    }).listen((respone) {
        NaiFarmLocalStorage.saveCategoriesAll(respone);

    });
    _compositeSubscription.add(subscription);
  }

  void loadCustomerCount({String token}){
    Observable.fromFuture(_application.appStoreAPIRepository.GetCustomerCount(token: token)).listen((respone) {
      if(respone.http_call_back.status==200 || respone.http_call_back.result.error.status==401){
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result);
      }
    });
  }

//CategoryCombin

  AddCartlists({BuildContext context,CartRequest cartRequest,String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddCartlists(cartRequest: cartRequest,token: token)).listen((respone) {
      if(respone.http_call_back.status==200||respone.http_call_back.status==201){
        Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
        onLoad.add(false);
        onSuccess.add((respone.respone as CartResponse));
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.result);
      }

    });
    _compositeSubscription.add(subscription);
  }


  DELETEProductMyShop({int ProductId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
        .appStoreAPIRepository
        .DELETEProductMyShop(ProductId: ProductId, token: token))
        .listen((respone) {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.http_call_back.result);
      }
    });
    _compositeSubscription.add(subscription);
  }

  static ProducItemRespone ConvertDataToProduct({ProductData data}){

    return ProducItemRespone(name: data.name,salePrice: data.salePrice,hasVariant: data.hasVariant,brand: data.brand,minPrice: data.minPrice,maxPrice: data.maxPrice,
        slug: data.slug,offerPrice: data.offerPrice,id: data.id,saleCount: data.saleCount,discountPercent: data.discountPercent,rating: data.rating,reviewCount: data.reviewCount,
        shop: ShopItem(id: data.shop.id,name: data.shop.name,slug: data.shop.slug,updatedAt: data.shop.updatedAt),image: data.image);
  }


  ProductRespone ConvertSearchData({SearchRespone item}){
    List<ProductData> data =  List<ProductData>();
    for(var value in item.hits){
      data.add(ProductData(id: value.productId,brand: value.brand,name: value.name,saleCount: value.saleCount,salePrice: value.salePrice,image: value.image,discountPercent: value.discountPercent,rating: value.rating,offerPrice: value.offerPrice,minPrice: value.minPrice,maxPrice: value.maxPrice,
          shop: ProductShop(id: value.shopId,name: value.shop.name,slug: value.shop.slug)));
    }
    return ProductRespone(data: data);
  }






}