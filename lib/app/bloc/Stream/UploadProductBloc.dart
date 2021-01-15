

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/AssetImage.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';



class UploadProductBloc{

  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final onChang = BehaviorSubject<Object>();
  final ProductMyShop = BehaviorSubject<ProductMyShopListRespone>();
  final uploadProductStorage = BehaviorSubject<UploadProductStorage>();

  CategoryCombin categoriesAllRespone = CategoryCombin();
  ProductMyShopRequest ProductDetail =  ProductMyShopRequest();

  List<OnSelectItem> ItemImage = List<OnSelectItem>();




  UploadProductBloc(this._application){
    //onChang.add(ItemImage);
  }


  void ConvertArrayFile({List<Asset> imageList, int index}){

    List<AssetImage> ItemConvert = List<AssetImage>();
    ItemImage.remove(null);
    for(var temp in imageList){
      ItemConvert.add(AssetImage(temp.identifier,temp.name,temp.originalWidth,temp.originalHeight));
    }

    if(ItemImage.length<=9){
      for(var i = 0;i<(ItemConvert.length);i++){
          if(ItemImage.length!=10){
            ItemImage.add(OnSelectItem(image: ItemConvert[i],onEdit: false));
          }else{
            break;
          }

      }
      NaiFarmLocalStorage.SaveProductStorage(UploadProductStorage(productMyShopRequest: ProductDetail,onSelectItem: ItemImage)).then((value){
        onChang.add(ItemImage);
      });

    }
  }

  void EditImage({List<Asset> imageList,int index}){
    List<AssetImage> ItemConvert = List<AssetImage>();
    ItemImage.remove(null);
    for(var temp in imageList){
      ItemConvert.add(AssetImage(temp.identifier,temp.name,temp.originalWidth,temp.originalHeight));
    }



    if(ItemConvert.length>=1){
      ItemImage[index] = OnSelectItem(image: ItemConvert[0],onEdit: false);
    }
    NaiFarmLocalStorage.SaveProductStorage(UploadProductStorage(onSelectItem: ItemImage,productMyShopRequest: ProductDetail)).then((value){
      onChang.add(ItemImage);
    });
  }

  void DeleteImage({int index}){
    ItemImage.remove(null);
    ItemImage.removeAt(index);

    NaiFarmLocalStorage.SaveProductStorage(UploadProductStorage(onSelectItem: ItemImage,productMyShopRequest: ProductDetail)).then((value){
      onChang.add(ItemImage);
    });
  }

  void LoadImage({List<OnSelectItem> item}){
    if(item!=null){
      for(var items in item){
        if(ItemImage.length!=10){
          ItemImage.add(OnSelectItem(image: items.image,onEdit: false));
        }else{
          break;
        }
      }
    }
    onChang.add(ItemImage);
  }

  void ConvertOnEdit({int index}){
    ItemImage.remove(null);
    var item = (onChang.value as List<OnSelectItem>);

      for(var i=0;i<item.length;i++){
        if(item[i]!=null){
          if(i==index){
            item[i].onEdit = true;
          }else{
            item[i].onEdit = false;
          }
        }

      }

    NaiFarmLocalStorage.SaveProductStorage(UploadProductStorage(onSelectItem: ItemImage,productMyShopRequest: ProductDetail)).then((value){
      onChang.add(ItemImage);
    });
  }


  void SaveProductDetail(){
    NaiFarmLocalStorage.SaveProductStorage(uploadProductStorage.value);
  }


   AddProductMyShop({ProductMyShopRequest shopRequest,String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddProductMyShop(shopRequest: shopRequest,token: token)).listen((respone) {


      if(respone.http_call_back.status==200){
        if(uploadProductStorage.value.productMyShopRequest.active==1){
          UpdateProductMyShop(shopRequest: shopRequest,token: token,productId: (respone.respone as ProductMyShopRespone).id);
        }
        if(uploadProductStorage.value.onSelectItem.length<=0){
          onLoad.add(false);
        }else{
          onSuccess.add((respone.respone as ProductMyShopRespone));
        }

      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UploadImageProduct({File imageFile, String imageableType, int imageableId, String token,int index}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.UploadImage(imageFile: imageFile,imageableId: imageableId,imageableType: imageableType,token: token)).listen((respone) {
      if(index+1==uploadProductStorage.value.onSelectItem.length){
        NaiFarmLocalStorage.DeleteCacheByItem(key: NaiFarmLocalStorage.NaiFarm_Product_Upload).then((value){
          onLoad.add(false);

          onSuccess.add(true);
        });

      }
    });
    _compositeSubscription.add(subscription);
  }

  UpdateProductMyShop({ProductMyShopRequest shopRequest,int productId,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.UpdateProductMyShop(shopRequest: shopRequest,productId: productId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        onSuccess.add(true);
      }
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

  DELETEProductMyShop({int ProductId,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.DELETEProductMyShop(ProductId: ProductId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){

      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }





  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/${DateTime.now().millisecondsSinceEpoch}.jpg'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
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

enum IsActive{
  NewProduct,
  UpdateProduct
}