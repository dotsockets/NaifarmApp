
import 'CategoryGroupRespone.dart';
import 'FeaturedRespone.dart';
import 'ProductRespone.dart';
import 'SliderRespone.dart';

class HomeObjectCombine{
  final SliderRespone sliderRespone;
  final ProductRespone productRespone;
  final CategoryGroupRespone categoryGroupRespone;
  final FeaturedRespone featuredRespone;
  final ProductRespone  trendingRespone;

  HomeObjectCombine({this.sliderRespone, this.productRespone,this.categoryGroupRespone,this.featuredRespone,this.trendingRespone});
}