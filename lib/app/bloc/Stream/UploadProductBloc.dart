import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/AssetImages.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesAttrRequest.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesRequest.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class UploadProductBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final onChang = BehaviorSubject<Object>();
  final productMyShopRes = BehaviorSubject<ProductMyShopListRespone>();
  final attributeMyShop = BehaviorSubject<MyShopAttributeRespone>();
  final uploadProductStorage = BehaviorSubject<UploadProductStorage>();
  final productRes = BehaviorSubject<ProductShopItemRespone>();

  CategoryCombin categoriesAllRespone = CategoryCombin();
  ProductMyShopRequest productDetail = ProductMyShopRequest();
  List<OnSelectItem> itemImage = <OnSelectItem>[];
  List<ProductMyShop> productList = <ProductMyShop>[];
  List<ImageProductShop> productImageList = <ImageProductShop>[];
  List<AttributesList> productAttributeList = <AttributesList>[];

  int inventoriesId = 0;
  var checkloop = 0;

  UploadProductBloc(this._application);

  void convertArrayFile({List<Asset> imageList, int index}) {
    List<AssetImages> itemConvert = <AssetImages>[];
    itemImage.remove(null);
    for (var temp in imageList) {
      itemConvert.add(AssetImages(
          temp.identifier, temp.name, temp.originalWidth, temp.originalHeight));
    }

    if (itemImage.length <= 9) {
      for (var i = 0; i < (itemConvert.length); i++) {
        if (itemImage.length != 10) {
          itemImage.add(OnSelectItem(image: itemConvert[i], onEdit: false));
        } else {
          break;
        }
      }
      onChang.add(itemImage);
    }
  }

  void editImage({List<Asset> imageList, int index}) {
    itemImage.remove(null);
    itemImage[index] = OnSelectItem(
        url: itemImage[index].url,
        image: AssetImages(imageList[0].identifier, imageList[0].name,
            imageList[0].originalWidth, imageList[0].originalHeight),
        onEdit: false);
    onChang.add(itemImage);
  }

  void deleteImage({int index}) {
    itemImage.remove(null);
    itemImage.removeAt(index);

    NaiFarmLocalStorage.saveProductStorage(UploadProductStorage(
            onSelectItem: itemImage, productMyShopRequest: productDetail))
        .then((value) {
      onChang.add(itemImage);
    });
  }

  void loadImage({List<OnSelectItem> item}) {
    if (item != null) {
      for (var items in item) {
        if (itemImage.length != 10) {
          itemImage.add(OnSelectItem(image: items.image, onEdit: false));
        } else {
          break;
        }
      }
    }
    onChang.add(itemImage);
  }

  void convertOnEdit({int index}) {
    itemImage.remove(null);
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

    onChang.add(itemImage);
  }

  void saveProductDetail() {
    NaiFarmLocalStorage.saveProductStorage(uploadProductStorage.value);
  }

  addProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .addProductMyShop(context, shopRequest: shopRequest, token: token))
        .listen((respone) async {
      if (respone.httpCallBack.status == 200) {
        if (uploadProductStorage.value.productMyShopRequest.active == 1) {
          updateProductMyShop(context,
              shopRequest: shopRequest,
              token: token,
              productId: (respone.respone as ProductMyShopRespone).id,
              isActive: IsActive.NewProduct);
        }
        if (uploadProductStorage.value.onSelectItem.length <= 0) {
          onLoad.add(false);
        } else {
          var item = uploadProductStorage.value.productMyShopRequest;
          var inventor = InventoriesRequest(
              title: item.name,
              offerPrice: item.offerPrice != null ? item.offerPrice : 0,
              stockQuantity: item.stockQuantity,
              salePrice: item.salePrice,
              active: item.active);
          updateProductInventories(context,
              isload: false,
              inventoriesRequest: inventor,
              productId: (respone.respone as ProductMyShopRespone).id,
              inventoriesId:
                  (respone.respone as ProductMyShopRespone).inventories[0].id,
              token: token);

          checkloop = 0;
          for (var item in uploadProductStorage.value.onSelectItem) {
            writeToFile(await item.image.getByteData(quality: 100))
                .then((file) {
              uploadImageProduct(context,
                  token: token,
                  imageableId: (respone.respone as ProductMyShopRespone).id,
                  imageFile: file,
                  imageableType: "product",
                  index: countSelectImage());
            });
          }
        }
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  uploadImageProduct(BuildContext context,
      {File imageFile,
      String imageableType,
      int imageableId,
      String token,
      int index,
      IsActive isActive}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.uploadImage(context,
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

  updateProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest,
      int productId,
      String token,
      IsActive isActive}) {
    if (isActive != IsActive.NewProduct) {
      onLoad.add(true);
    }
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.updateProductMyShop(context,
                shopRequest: shopRequest, productId: productId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        // onSuccess.add(true);

        if (isActive == IsActive.UpdateProduct) {
          //onLoad.add(false);
          onSuccess.add(true);
        } else if (isActive == IsActive.ReplacemenView) {
          onLoad.add(false);
          onSuccess.add(true);
        } else {
          onLoad.add(false);
        }
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
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
    StreamSubscription subscription = Observable.fromFuture(
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
        onSuccess.add((respone.respone as ProductMyShopRespone));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }
  updateInventoriesAttr(BuildContext context,
      {InventoriesAttrRequest inventoriesRequest,
        int productId,
        int inventoriesId,
        String token,}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
        _application.appStoreAPIRepository.updateInventoriesAttr(context,
            inventoriesRequest: inventoriesRequest,
            inventoriesId: inventoriesId,
            productId: productId,
            token: token))
        .listen((respone) {

      //  onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        onSuccess.add((respone.respone as ProductShopItemRespone));
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getProductMyShop(BuildContext context,
      {String page, int limit, String token, String filter}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.getProductMyShop(context,
                page: page, limit: limit, token: token, filter: filter))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as ProductMyShopListRespone);
        productList.addAll(item.data);
        productMyShopRes.add(ProductMyShopListRespone(
            data: productList,
            limit: item.limit,
            page: item.page,
            total: item.total));
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteProductMyShop(BuildContext context, {int productId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .deleteProductMyShop(context, productId: productId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        onSuccess.add(IsActive.DeleteImage);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteImageProduct(BuildContext context,
      {String imageableId, String imageableType, String path, String token}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.deleteImageProduct(context,
                imageableType: imageableType,
                imageableId: imageableId,
                path: path,
                token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  onUpdateImage(BuildContext context,
      {int productId, String token, List<OnSelectItem> data}) async {
    onLoad.add(true);
    itemImage.remove(null);
    checkloop = 0;

    for (var item in data) {
      if (item.image != null && item.url != "") {
        writeToFile(await item.image.getByteData(quality: 100)).then((file) {
          uploadImageProduct(context,
              token: token,
              imageableId: productId,
              imageFile: file,
              imageableType: "product",
              index: data.length,
              isActive: IsActive.UpdateProduct);
        });
        deleteImageProduct(context,
            imageableId: productId.toString(),
            imageableType: "product",
            path: item.url,
            token: token);
      } else if (item.image != null && item.url == "") {
        writeToFile(await item.image.getByteData(quality: 100)).then((file) {
          uploadImageProduct(context,
              token: token,
              imageableId: productId,
              imageFile: file,
              imageableType: "product",
              index: data.length,
              isActive: IsActive.UpdateProduct);
        });
      }
    }
  }

  getProductIDMyShop(BuildContext context, {int productId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .getProductIDMyShop(context, productId: productId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as ProductShopItemRespone);
        uploadProductStorage.value.onSelectItem.clear();
        for (var value in item.image) {
          uploadProductStorage.value.onSelectItem
              .add(OnSelectItem(url: value.path, onEdit: false));
        }
        inventoriesId = item.inventories[0].id;
        uploadProductStorage.value.productMyShopRequest = ProductMyShopRequest(
            inventoriesid: item.inventories[0].id,
            name: item.name,
            salePrice: item.salePrice,
            stockQuantity: item.inventories[0].stockQuantity,
            offerPrice: item.offerPrice,
            active: uploadProductStorage.value.productMyShopRequest.active,
            category: item.categories[0].category.id,
            weight: item.inventories[0].shippingWeight,
            description: item.description);
        productAttributeList.addAll(item.inventories[0].attributes);
        uploadProductStorage.add(uploadProductStorage.value);
        productRes.add(item);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });

    _compositeSubscription.add(subscription);
  }

  getProductDetailShop(BuildContext context, {int productId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .getProductIDMyShop(context, productId: productId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        NaiFarmLocalStorage.getProductMyShopCache().then((value) {
          var res = (respone.respone as ProductShopItemRespone);
          productImageList.addAll(res.image);
          res.image = productImageList;
          if (value != null) {
            for (var data in value.item) {
              if (data.id == productId) {
                value.item.remove(data);
                break;
              }
            }
            value.item.add(res);
            NaiFarmLocalStorage.saveProductMyShopCache(value).then((value) {
              productRes.add(res);
            });
          } else {
            ProductMyShopCombine productMyShop = ProductMyShopCombine([res]);
            NaiFarmLocalStorage.saveProductMyShopCache(productMyShop)
                .then((value) {
              productRes.add(res);
            });
          }
        });

        /*productImageList
            .addAll((respone.respone as ProductMyShopRespone).image);
        productRes.add(ProductMyShopRespone(image: productImageList));*/

        onSuccess.add((respone.respone as ProductShopItemRespone));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });

    _compositeSubscription.add(subscription);
  }

  int countSelectImage() {
    var number = 0;
    for (var item in itemImage) {
      if (item != null && item.image != null) {
        number++;
      }
    }
    return number;
  }

  List<OnSelectItem> getSelectItemUpdate() {
    List<OnSelectItem> data = <OnSelectItem>[];
    for (var item in itemImage) {
      if (item != null && item.image != null) {
        data.add(item);
      }
    }

    return data;
  }

  List<OnSelectItem> getSelectItem() {
    List<OnSelectItem> data = <OnSelectItem>[];
    for (var i = 0; i < itemImage.length; i++) {
      if (itemImage[i] != null) {
        data.add(itemImage[i]);
      }
    }
    itemImage.clear();
    itemImage.addAll(data);
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

  getAttributeMyShop(BuildContext context, {String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .getMyShopAttribute(context, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        onSuccess.add(true);
        attributeMyShop.add(respone.respone as MyShopAttributeRespone);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addAttributeMyShop(BuildContext context,
      {String name, String token, List<String> value, String color = ""}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .addMyShopAttribute(context, token: token, name: name))
        .listen((respone) async {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as AttributeData);
        onLoad.add(false);
        // onSuccess.add(true);
        if (value.length != 0) {
          for (var subType in value) {
            addSubAttribute(context,
                id: item.id,
                token: token,
                color: color,
                value: subType,
                length: value.length);
          }
        }else onSuccess.add(respone.respone as AttributeData);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteAttributeMyShop(BuildContext context, {int id, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .deleteMyShopAttribute(context, id: id, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        getAttributeMyShop(context, token: token);
        // onSuccessDel.add(true);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getSubAttribute(BuildContext context, {String token, int id}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .getSubAttribute(context, id: id, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        attributeMyShop.add((respone.respone as MyShopAttributeRespone));
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateAttribute(BuildContext context,
      {String name, int id, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .updateAttribute(context, id: id, name: name, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        onSuccess.add(respone.respone as AttributeData);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addSubAttribute(BuildContext context,
      {String value, String color = "", int id, String token, int length}) {
    //   onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.addAttributeDetail(context,
                token: token, value: value, color: color, id: id))
        .listen((respone) async {
      if (respone.httpCallBack.status == 200) {
        // onLoad.add(false);
        checkloop++;
        if (checkloop == length) onSuccess.add(respone.respone as SubAttributeData);
      } else {
        //   onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateSubAttribute(BuildContext context,
      {String value, String color, int id, int vid, String token,int total,int index}) async {
    if(index+1==total) onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.updateAttributeDetail(context,
                value: value, id: id, color: color, vid: vid, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        if(index+1==total) {
          onLoad.add(false);
          onSuccess.add(respone.respone as SubAttributeData);
        }
        print((index+1).toString()+" 8999999 "+total.toString());
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteSubAttribute(BuildContext context, {int id, String token, int vid}) {
   // onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .deleteAttributeDetail(context, id: id, token: token, vid: vid))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
       // onLoad.add(false);
        getSubAttribute(context, token: token, id: id);
        //  onSuccessDel.add(true);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateinventories(BuildContext context,
      {int productsId, int inventoriesId, int shippingWeight, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.updateinventories(context,
                productsId: productsId,
                inventoriesId: inventoriesId,
                shippingWeight: shippingWeight,
                token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onLoad.add(false);
        onSuccess.add(true);
        //  GetAttributeDetail(token: token,id: id);
        //  onSuccessDel.add(true);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
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

enum IsActive {
  NewProduct,
  UpdateProduct,
  DeleteImage,
  ReplacemenView,
  NoReplacemenView
}
