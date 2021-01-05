
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/FeaturedRespone.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MarketObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductDetailObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/SliderRespone.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();



  final ProductPopular = BehaviorSubject<ProductRespone>();
  final CategoryGroup = BehaviorSubject<CategoryGroupRespone>();
  final FeaturedGroup = BehaviorSubject<FeaturedRespone>();
  final TrendingGroup = BehaviorSubject<ProductRespone>();
  final SearchProduct = BehaviorSubject<SearchRespone>();
  final ProductMartket = BehaviorSubject<ProductRespone>();
  final RecommendProduct =  BehaviorSubject<ProductRespone>();
  final MoreProduct =  BehaviorSubject<ProductRespone>();
  final Flashsale =  BehaviorSubject<FlashsaleRespone>();
  final ProductItem =  BehaviorSubject<ProducItemRespone>();


  final ZipProductDetail = BehaviorSubject<ProductDetailObjectCombine>();

  final ZipMarketProfile = BehaviorSubject<MarketObjectCombine>();

  ProductBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
  }


  loadHomeData()async{
    StreamSubscription subscription = Observable.combineLatest7(Observable.fromFuture(_application.appStoreAPIRepository.getSliderImage())
        , Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular("1",10)),
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoryGroup()),
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoriesFeatured()),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",5)),
        Observable.fromFuture(_application.appStoreAPIRepository.getProduct("1",5)),
        Observable.fromFuture(_application.appStoreAPIRepository.Flashsale(page: "1",limit: 5)),(a, b,c,d,e,f,g){
            final _slider = (a as ApiResult).respone;
            final _product  =(b as ApiResult).respone;
            final _category =(c as ApiResult).respone;
            final _featured =(d as ApiResult).respone;
            final _trending =(e as ApiResult).respone;
            final _martket =(f as ApiResult).respone;
            final _flashsale =(g as ApiResult).respone;
            return HomeObjectCombine(sliderRespone: (_slider as SliderRespone),
                productRespone: (_product as ProductRespone),
                categoryGroupRespone: (_category as CategoryGroupRespone),featuredRespone: (_featured as FeaturedRespone),
            trendingRespone: (_trending as ProductRespone),martket: (_martket as ProductRespone),flashsaleRespone: (_flashsale as FlashsaleRespone));

        }).listen((event) {
           ProductPopular.add(event.productRespone);
           CategoryGroup.add(event.categoryGroupRespone);
           FeaturedGroup.add(event.featuredRespone);
           TrendingGroup.add(event.trendingRespone);
           ProductMartket.add(event.martket);
           Flashsale.add(event.flashsaleRespone);
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
        Observable.fromFuture(_application.appStoreAPIRepository.getProduct("1",5)),(a, b,c){
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

  loadProductsById({int id}){

    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.ProductsById(id: id)),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",5)),(a, b){
      final _product = (a as ApiResult).respone;
      final _recommend  =(b as ApiResult).respone;
      return ProductDetailObjectCombine(productItem: _product,recommend: _recommend);

    }).listen((event) {
      ZipProductDetail.add(event);
    });
    _compositeSubscription.add(subscription);


  }



}