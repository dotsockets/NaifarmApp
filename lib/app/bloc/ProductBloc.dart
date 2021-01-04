
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/FeaturedRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
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



  ProductBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
  }


  loadHomeData()async{
    StreamSubscription subscription = Observable.combineLatest5(Observable.fromFuture(_application.appStoreAPIRepository.getSliderImage())
        , Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular("1")),
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoryGroup()),
        Observable.fromFuture(_application.appStoreAPIRepository.getCategoriesFeatured()),
        Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1")),(a, b,c,d,e){
            final _slider = (a as ApiResult).respone;
            final _product  =(b as ApiResult).respone;
            final _category =(c as ApiResult).respone;
            final _featured =(d as ApiResult).respone;
            final _trending =(e as ApiResult).respone;
            return HomeObjectCombine(sliderRespone: (_slider as SliderRespone),
                productRespone: (_product as ProductRespone),
                categoryGroupRespone: (_category as CategoryGroupRespone),featuredRespone: (_featured as FeaturedRespone),
            trendingRespone: (_trending as ProductRespone));

        }).listen((event) {
           ProductPopular.add(event.productRespone);
           CategoryGroup.add(event.categoryGroupRespone);
           FeaturedGroup.add(event.featuredRespone);
           TrendingGroup.add(event.trendingRespone);
    });
    _compositeSubscription.add(subscription);
  }

  loadProductPopular(String page)async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular(page)).listen((respone) {
      if(respone.http_call_back.status==200){
        ProductPopular.add((respone.respone as ProductRespone));
      }

    });
    _compositeSubscription.add(subscription);
  }

  loadProductTrending(String page)async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending(page)).listen((respone) {
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

}