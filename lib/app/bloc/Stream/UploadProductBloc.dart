import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/AssetImages.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesRequest.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class UploadProductBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final onChang = BehaviorSubject<Object>();
  final ProductMyShopRes = BehaviorSubject<ProductMyShopListRespone>();
  final attributeMyShop = BehaviorSubject<MyShopAttributeRespone>();
  final uploadProductStorage = BehaviorSubject<UploadProductStorage>();
  final productRes = BehaviorSubject<ProductMyShopRespone>();

  CategoryCombin categoriesAllRespone = CategoryCombin();
  ProductMyShopRequest ProductDetail = ProductMyShopRequest();
  List<OnSelectItem> ItemImage = List<OnSelectItem>();
  List<ProductMyShop> productList = List<ProductMyShop>();
  List<ImageProductShop> productImageList = List<ImageProductShop>();

  int inventoriesId = 0;
  var checkloop = 0;

  UploadProductBloc(this._application);

  void ConvertArrayFile({List<Asset> imageList, int index}) {
    List<AssetImages> ItemConvert = List<AssetImages>();
    ItemImage.remove(null);
    for (var temp in imageList) {
      ItemConvert.add(AssetImages(
          temp.identifier, temp.name, temp.originalWidth, temp.originalHeight));
    }

    if (ItemImage.length <= 9) {
      for (var i = 0; i < (ItemConvert.length); i++) {
        if (ItemImage.length != 10) {
          ItemImage.add(OnSelectItem(image: ItemConvert[i], onEdit: false));
        } else {
          break;
        }
      }
      onChang.add(ItemImage);
    }
  }

  void EditImage({List<Asset> imageList, int index}) {
    ItemImage.remove(null);
    ItemImage[index] = OnSelectItem(
        url: ItemImage[index].url,
        image: AssetImages(imageList[0].identifier, imageList[0].name,
            imageList[0].originalWidth, imageList[0].originalHeight),
        onEdit: false);
    onChang.add(ItemImage);
  }

  void DeleteImage({int index}) {
    ItemImage.remove(null);
    ItemImage.removeAt(index);

    NaiFarmLocalStorage.SaveProductStorage(UploadProductStorage(
            onSelectItem: ItemImage, productMyShopRequest: ProductDetail))
        .then((value) {
      onChang.add(ItemImage);
    });
  }

  void LoadImage({List<OnSelectItem> item}) {
    if (item != null) {
      for (var items in item) {
        if (ItemImage.length != 10) {
          ItemImage.add(OnSelectItem(image: items.image, onEdit: false));
        } else {
          break;
        }
      }
    }
    onChang.add(ItemImage);
  }

  void ConvertOnEdit({int index}) {
    ItemImage.remove(null);
    var item = (onChang.value as List<OnSelectItem>);

    for (var i = 0; i < item.length; i++) {
      if (item[i] != null) {
        if (i == index) {
          item[i].onEdit = true;
        } else {
          item[i].onEdit = false;
        }
      }
    }

    onChang.add(ItemImage);
  }

  void SaveProductDetail() {
    NaiFarmLocalStorage.SaveProductStorage(uploadProductStorage.value);
  }

  AddProductMyShop(BuildContext context,{ProductMyShopRequest shopRequest, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .AddProductMyShop(context,shopRequest: shopRequest, token: token))
        .listen((respone) async {
      if (respone.http_call_back.status == 200) {
        if (uploadProductStorage.value.productMyShopRequest.active == 1) {
          UpdateProductMyShop(context,
              shopRequest: shopRequest,
              token: token,
              productId: (respone.respone as ProductMyShopRespone).id,isActive: IsActive.NewProduct);
        }
        if (uploadProductStorage.value.onSelectItem.length <= 0) {
          onLoad.add(false);
        } else {

          var item = uploadProductStorage.value.productMyShopRequest;
          var inventor = InventoriesRequest(title: item.name,offerPrice: item.offerPrice!=null?item.offerPrice:0,stockQuantity: item.stockQuantity,salePrice: item.salePrice,active: item.active);
         UpdateProductInventories(context,Isload: false,inventoriesRequest: inventor,productId: (respone.respone as ProductMyShopRespone).id,inventoriesId: (respone.respone as ProductMyShopRespone).inventories[0].id, token: token);

          checkloop = 0;
          for (var item in uploadProductStorage.value.onSelectItem) {
            writeToFile(await item.image.getByteData(quality: 100))
                .then((file) {
              UploadImageProduct(
                  context,
                  token: token,
                  imageableId: (respone.respone as ProductMyShopRespone).id,
                  imageFile: file,
                  imageableType: "product",
                  index: CountSelectImage());
            });
          }
        }
      } else {
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UploadImageProduct(BuildContext context,
      {File imageFile,
      String imageableType,
      int imageableId,
      String token,
      int index,
      IsActive isActive}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.UploadImage(
                context,
                imageFile: imageFile,
                imageableId: imageableId,
                imageableType: imageableType,
                token: token))
        .listen((respone) {
      checkloop++;
      if (checkloop == index) {
        onLoad.add(false);
        onSuccess.add(true);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UpdateProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, int productId, String token,IsActive isActive}) {
    if(isActive != IsActive.NewProduct){
      onLoad.add(true);
    }

    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.UpdateProductMyShop(context,
                shopRequest: shopRequest, productId: productId, token: token))
        .listen((respone) {
      if (respone.http_call_back.status == 200) {
      // onSuccess.add(true);

         if(isActive == IsActive.UpdateProduct){
           //onLoad.add(false);
           onSuccess.add(true);
         }else if(isActive == IsActive.ReplacemenView){
           onLoad.add(false);
           onSuccess.add(true);
         }else{
           onLoad.add(false);
         }
      } else {
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UpdateProductInventories(BuildContext context,
      {InventoriesRequest inventoriesRequest,
      int productId,
      int inventoriesId,
      String token,bool Isload}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.UpdateProductInventories(context,
                inventoriesRequest: inventoriesRequest,
                inventoriesId: inventoriesId,
                productId: productId,
                token: token))
        .listen((respone) {
          if(Isload){
            onLoad.add(false);
          }
    //  onLoad.add(false);
      if (respone.http_call_back.status == 200) {
        onSuccess.add((respone.respone as ProductMyShopRespone));
      } else {
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  GetProductMyShop(BuildContext context,{String page, int limit, String token,String filter}) {
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.GetProductMyShop(context,page: page, limit: limit, token: token,filter: filter)).listen((respone) {
      if (respone.http_call_back.status == 200) {
        var item = (respone.respone as ProductMyShopListRespone);
        productList.addAll(item.data);
        ProductMyShopRes.add(ProductMyShopListRespone(data: productList,limit: item.limit,page: item.page,total: item.total));
      }
    });
    _compositeSubscription.add(subscription);
  }

  DELETEProductMyShop(BuildContext context,{int ProductId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .DELETEProductMyShop(context,ProductId: ProductId, token: token))
        .listen((respone) {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        onSuccess.add(IsActive.DeleteImage);
      } else {
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  DeleteImageProduct(BuildContext context,
      {String imageableId, String imageableType, String path, String token}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.DeleteImageProduct(context,
                imageableType: imageableType,
                imageableId: imageableId,
                path: path,
                token: token))
        .listen((respone) {
      if (respone.http_call_back.status == 200) {
      } else {
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  OnUpdateImage(BuildContext context,{int ProductId, String token, List<OnSelectItem> data}) async {
    onLoad.add(true);
    ItemImage.remove(null);
    checkloop = 0;

    for (var item in data) {
      if (item.image != null && item.url != "") {
        writeToFile(await item.image.getByteData(quality: 100)).then((file) {
          UploadImageProduct(context,
              token: token,
              imageableId: ProductId,
              imageFile: file,
              imageableType: "product",
              index: data.length,
              isActive: IsActive.UpdateProduct);
        });
        DeleteImageProduct(context,
            imageableId: ProductId.toString(),
            imageableType: "product",
            path: item.url,
            token: token);
      } else if (item.image != null && item.url == "") {
        writeToFile(await item.image.getByteData(quality: 100)).then((file) {
          UploadImageProduct(context,
              token: token,
              imageableId: ProductId,
              imageFile: file,
              imageableType: "product",
              index: data.length,
              isActive: IsActive.UpdateProduct);
        });
      }
    }
  }

  GetProductIDMyShop(BuildContext context,{int ProductId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .GetProductIDMyShop(context,ProductId: ProductId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.http_call_back.status == 200) {
        var item = (respone.respone as ProductMyShopRespone);
        uploadProductStorage.value.onSelectItem.clear();
        for (var value in item.image) {
          uploadProductStorage.value.onSelectItem
              .add(OnSelectItem(url: value.path, onEdit: false));
        }
        inventoriesId = item.inventories[0].id;
        uploadProductStorage.value.productMyShopRequest = ProductMyShopRequest(
            inventoriesid : item.inventories[0].id,
            name: item.name,
            salePrice: item.salePrice,
            stockQuantity: item.inventories[0].stockQuantity,
            offerPrice: item.offerPrice,
            active: uploadProductStorage.value.productMyShopRequest.active,
            category: item.categories[0].category.id,
            weight: item.inventories[0].shippingWeight,
            description: item.description);
        uploadProductStorage.add(uploadProductStorage.value);

      } else {
        onError.add(respone.http_call_back.message);
      }
    });

    _compositeSubscription.add(subscription);
  }

  GetProductDetailShop(BuildContext context,{int ProductId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
        .appStoreAPIRepository
        .GetProductIDMyShop(context,ProductId: ProductId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.http_call_back.status == 200) {
        productImageList.addAll((respone.respone as ProductMyShopRespone).image);
        productRes.add(ProductMyShopRespone(image: productImageList));

       onSuccess.add((respone.respone as ProductMyShopRespone));
      } else {
        onError.add(respone.http_call_back.message);
      }
    });

    _compositeSubscription.add(subscription);
  }
  int CountSelectImage() {
    var number = 0;
    for (var item in ItemImage) {
      if (item != null && item.image!=null) {
        number++;
      }
    }
    return number;
  }

  List<OnSelectItem> GetSelectItemUpdate() {
    List<OnSelectItem> data = List<OnSelectItem>();
    for (var item in ItemImage) {
      if (item != null && item.image!=null) {
        data.add(item);
      }
    }

    return data;
  }

  List<OnSelectItem> GetSelectItem() {
    List<OnSelectItem> data = List<OnSelectItem>();
    for (var i = 0; i < ItemImage.length; i++) {
      if (ItemImage[i] != null) {
        data.add(ItemImage[i]);
      }
    }
    ItemImage.clear();
    ItemImage.addAll(data);


    return data;
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath +
        '/${DateTime.now().millisecondsSinceEpoch}.jpg'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  GetAttributeMyShop(BuildContext context,{String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.getMyShopAttribute(context,token: token)).listen((respone) {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        onSuccess.add(true);
        attributeMyShop.add((respone.respone as MyShopAttributeRespone));
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }
  AddAttributeMyShop(BuildContext context,{String name, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.addMyShopAttribute(context,token: token,name: name)).listen((respone) async {
      if (respone.http_call_back.status == 200) {
       onLoad.add(false);
       onSuccess.add(true);
      }else {
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  DELETEAttributeMyShop(BuildContext context,{int id, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.deleteMyShopAttribute(context,id: id, token: token)).listen((respone) {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        GetAttributeMyShop(context,token: token);
       // onSuccessDel.add(true);
      }else {
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  GetAttributeDetail(BuildContext context,{String token,int id}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.getAttributeDetail(context,id: id,token: token)).listen((respone) {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        attributeMyShop.add((respone.respone as MyShopAttributeRespone));
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UpdateAttribute(BuildContext context,{String name,int id, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.updateAttribute(context,id:id,name:name,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        onLoad.add(false);
        onSuccess.add(true);
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  AddAttributeDetail(BuildContext context,{String value,String color,int id,String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.addAttributeDetail(context,token: token,value: value,color: color,id: id)).listen((respone) async {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        onSuccess.add(true);
      }else {
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UpdateAttributeDetail(BuildContext context,{String value, String color, int id, int vid, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.updateAttributeDetail(context,value: value,id: id,color: color,vid: vid,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        onLoad.add(false);
        onSuccess.add(true);
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }
  DELETEAttributeDetail(BuildContext context,{int id, String token,int vid}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.deleteAttributeDetail(context,id: id, token: token,vid: vid)).listen((respone) {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        GetAttributeDetail(context,token: token,id: id);
        //  onSuccessDel.add(true);
      }else {
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateinventories(BuildContext context,{int productsId, int inventoriesId,int shippingWeight, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.updateinventories(context,productsId: productsId,inventoriesId: inventoriesId,shippingWeight: shippingWeight,token: token)).listen((respone) {
      if (respone.http_call_back.status == 200) {
        onLoad.add(false);
        onSuccess.add(true);
      //  GetAttributeDetail(token: token,id: id);
        //  onSuccessDel.add(true);
      }else {
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
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

enum IsActive { NewProduct, UpdateProduct, DeleteImage,ReplacemenView,NoReplacemenView }
