
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/BannersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MarketObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductDetailObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/SliderRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<String>();
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
  final ProductMyShop = BehaviorSubject<ProductMyShopListRespone>();
  final Wishlists = BehaviorSubject<WishlistsRespone>();


  final ZipProductDetail = BehaviorSubject<ProductDetailObjectCombine>();

  final ZipMarketProfile = BehaviorSubject<MarketObjectCombine>();

  final ZipHomeObject = BehaviorSubject<HomeObjectCombine>();

  final ZipCategoryObject = BehaviorSubject<CategoryObjectCombin>();

  ProductBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
  }


  loadHomeData({String token})async{
    StreamSubscription subscription = Observable.combineLatest9(Observable.fromFuture(_application.appStoreAPIRepository.getSliderImage()) // สไลด์ภาพ
        , Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular("1",10)), // สินค้าขายดี
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoryGroup()), // หมวดหมู่ทั่วไป
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoriesFeatured()), // หมวดหมู่แนะนำ
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",5)), // สินค้าแนะนำ
        Observable.fromFuture(_application.appStoreAPIRepository.getShopProduct(ShopId: 1,page: "1",limit: 5)), // สินค้าของ NaiFarm
        Observable.fromFuture(_application.appStoreAPIRepository.Flashsale(page: "1",limit: 5)), // สินค้าลดราคา
        Observable.fromFuture(_application.appStoreAPIRepository.FarmMarket()),
        Observable.fromFuture(_application.appStoreAPIRepository.GetMyWishlists(token: token)), // NaiFarmShop
            (a, b,c,d,e,f,g,h,k){
            final _slider = (a as ApiResult).respone;
            final _product  =(b as ApiResult).respone;
            final _category =(c as ApiResult).respone;
            final _featured =(d as ApiResult).respone;
            final _trending =(e as ApiResult).respone;
            final _martket =(f as ApiResult).respone;
            final _flashsale =(g as ApiResult).respone;
            final _martkertall =(h as ApiResult).respone;
            final _mywishlist =(k as ApiResult).respone;

            return HomeObjectCombine(sliderRespone: _slider,
                productRespone: _product, categoryGroupRespone: _category,featuredRespone: _featured,
            trendingRespone: _trending,martket: _martket,flashsaleRespone: _flashsale,myShopRespone: _martkertall,wishlistsRespone: _mywishlist);

        }).listen((event) {

            NaiFarmLocalStorage.saveHomeData(event).then((value) => ZipHomeObject.add(event));

    });
    _compositeSubscription.add(subscription);
  }

  loadProductPopular(String page)async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular(page,10)).listen((respone) {
      if(respone.http_call_back.status==200){
        ProductPopular.add((respone.respone as ProductRespone));
      }

    });
    _compositeSubscription.add(subscription);
  }

  GetMyWishlists({String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetMyWishlists(token: token)).listen((respone) {
      if(respone.http_call_back.status==200){

        NaiFarmLocalStorage.getHomeDataCache().then((value1){
          value1.wishlistsRespone = (respone.respone as WishlistsRespone);
          NaiFarmLocalStorage.saveHomeData(value1).then((value2) {
            Wishlists.add(value1.wishlistsRespone);
          });

        });


      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  loadProductTrending(String page)async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending(page,10)).listen((respone) {
      if(respone.http_call_back.status==200){
        TrendingGroup.add((respone.respone as ProductRespone));
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

  loadMoreData({String page, int limit, String link}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.MoreProduct(page: page,link: link,limit: limit)).listen((respone) {
      if(respone.http_call_back.status==200){
        MoreProduct.add((respone.respone as ProductRespone));
      }
    });
    _compositeSubscription.add(subscription);
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
      GetMyWishlists(token: token);
      if(respone.http_call_back.status==200){
       onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }


    });
    _compositeSubscription.add(subscription);
  }

  AddWishlists({int inventoryId,int productId,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddWishlists(inventoryId: inventoryId,productId: productId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        GetMyWishlists(token: token);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }




  loadProductsById({int id,int shopid,String token}){

    StreamSubscription subscription = Observable.combineLatest3(
        Observable.fromFuture(_application.appStoreAPIRepository.ProductsById(id: id)),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",5)),
        Observable.fromFuture(_application.appStoreAPIRepository.ShopById(id: shopid)),(a, b,c){
      final _product = (a as ApiResult).respone;
      final _recommend  =(b as ApiResult).respone;
      final _shop  =(c as ApiResult).respone;
      return ProductDetailObjectCombine(productItem: _product,recommend: _recommend,shopRespone: _shop);

    }).listen((event) {
      ZipProductDetail.add(event);
    });
    _compositeSubscription.add(subscription);


  }



  loadCategoryPage({int GroupId}){
    StreamSubscription subscription = Observable.combineLatest5(
        Observable.fromFuture(_application.appStoreAPIRepository.CategorySubgroup(GroupId: GroupId)),
        Observable.fromFuture(_application.appStoreAPIRepository.categoryGroupId(GroupId: GroupId,limit: 5,page: "1")),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",5)),
        Observable.fromFuture(_application.appStoreAPIRepository.GetBanners(group: "home_middle")),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular("1",6)),(a, b,c,d,e){
      final _supgroup = (a as ApiResult).respone;
      final _groupproduct  =(b as ApiResult).respone;
      final recommend  =(c as ApiResult).respone;
      final _banner  =(d as ApiResult).respone;
      final _hotproduct  =(e as ApiResult).respone;

      return CategoryObjectCombin(supGroup: (_supgroup as CategoryGroupRespone),goupProduct: (_groupproduct as ProductRespone),recommend: (recommend as ProductRespone),banner: (_banner as BannersRespone),hotProduct: (_hotproduct as ProductRespone));

    }).listen((event) {
      ZipCategoryObject.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  GetProductMyShop({String page, int limit,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetProductMyShop(page: page,limit: limit,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        ProductMyShop.add((respone.respone as ProductMyShopListRespone));
      }
    });
    _compositeSubscription.add(subscription);
  }



  static ProducItemRespone ConvertDataToProduct({ProductData data}){

    return ProducItemRespone(name: data.name,salePrice: data.salePrice,hasVariant: data.hasVariant,brand: data.brand,minPrice: data.minPrice,maxPrice: data.maxPrice,
        slug: data.slug,offerPrice: data.offerPrice,id: data.id,saleCount: data.saleCount,discountPercent: data.discountPercent,rating: data.rating,reviewCount: data.reviewCount,
        shop: ShopItem(id: data.shop.id,name: data.shop.name,slug: data.shop.slug,updatedAt: data.shop.updatedAt),image: data.image);
  }








}