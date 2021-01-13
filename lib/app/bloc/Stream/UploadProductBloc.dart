

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:rxdart/rxdart.dart';

class UploadProductBloc{

  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final onChang = BehaviorSubject<Object>();


  List<Asset> ItemImage = List<Asset>();




  UploadProductBloc(this._application);


  void ConvertArrayFile({List<Asset> imageList, int index}){
    ItemImage.remove(null);
    // if(index<9){
    // }

    ItemImage.addAll(imageList);
    onChang.add(ItemImage);
  }

  // bool ValidateButton(){
  //   bool value = false;
  //   int i = 0;
  //   for(var item in listImage){
  //     if(listImage[i].file!=null) {
  //       value = true;
  //       break;
  //     }
  //     i++;
  //   }
  //   return value;
  // }

}