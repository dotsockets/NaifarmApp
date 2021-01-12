

import 'dart:io';

import 'package:image_picker/image_picker.dart';
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

  List<ProductImage> listImage = List<ProductImage>();
  List<ProductImage> ItemImage = List<ProductImage>();




  UploadProductBloc(this._application);


  void InstallImage(){
    for(var i=0;i<1;i++){
      if(i<1){
        listImage.add(ProductImage(name: "0"));
      }else{
        listImage.add(ProductImage());
      }

    }
    onChang.add(listImage);
  }

  void ConvertArrayFile({File file, int index}){
    listImage[index].file = file;
    if(index<9)
      listImage[index+1].name = "0";
    else{
      listImage[index].name = "0";
    }

   // ItemImage.add(listImage[index]);
    onChang.add(listImage);
  }

  bool ValidateButton(){
    bool value = false;
    int i = 0;
    for(var item in listImage){
      if(listImage[i].file!=null) {
        value = true;
        break;
      }
      i++;
    }
    return value;
  }

}