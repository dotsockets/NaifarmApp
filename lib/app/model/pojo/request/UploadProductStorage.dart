
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';

import 'AssetImage.dart';
import 'ProductMyShopRequest.dart';

class UploadProductStorage{
   ProductMyShopRequest productMyShopRequest;
   List<OnSelectItem> onSelectItem;

  UploadProductStorage({this.productMyShopRequest, this.onSelectItem});

  UploadProductStorage.fromJson(Map<String, dynamic> json) {
    productMyShopRequest = json['productMyShopRequest'] != null ? new ProductMyShopRequest.fromJson(json['productMyShopRequest']) : null;
    if (json['onSelectItem'] != null) {
      onSelectItem = new List<OnSelectItem>();
      json['onSelectItem'].forEach((v) {
        onSelectItem.add(new OnSelectItem.fromJson(v));
      });
    }

  }

   Map<String, dynamic> toJson() {

     final Map<String, dynamic> data = new Map<String, dynamic>();
     if (this.productMyShopRequest != null) {
       data['productMyShopRequest'] = this.productMyShopRequest.toJson();
     }
     if (this.onSelectItem != null) {
       data['onSelectItem'] = this.onSelectItem.map((v) => v.toJson()).toList();
     }
     return data;
   }


  // UploadProductStorage.fromJson(Map<String, dynamic> json) {
  //   if (json['onSelectItem'] != null) {
  //     onSelectItem = new List<OnSelectItem>();
  //     json['onSelectItem'].forEach((v) {
  //       onSelectItem.add(new OnSelectItem.fromJson(v));
  //     });
  //   }
  // }
}


class OnSelectItem{
  AssetImage image;
  bool onEdit;
  String url;

  OnSelectItem({this.image, this.onEdit,this.url});

  OnSelectItem.fromJson(Map<String, dynamic> json) {

    image = json['image'] != null ? new AssetImage.fromJson(json['image']) : null;
    onEdit = json['onEdit'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['onEdit'] = this.onEdit;
    return data;
  }

}