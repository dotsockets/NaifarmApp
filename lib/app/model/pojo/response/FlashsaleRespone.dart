import 'ProductRespone.dart';
import 'StatesRespone.dart';

class FlashsaleRespone {
  List<FlashsaleData> data;
  int total;
  String page;
  String limit;
  bool loadmore = true;

  FlashsaleRespone(
      {this.data, this.total, this.page, this.limit, this.loadmore});

  FlashsaleRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FlashsaleData>[];
      json['data'].forEach((v) {
        data.add(new FlashsaleData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}

class FlashsaleData {
  int id;
  String start;
  String end;
  List<FlashsaleItems> items;

  FlashsaleData({this.id, this.start, this.end, this.items});

  FlashsaleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    start = json['start'];
    end = json['end'];
    if (json['items'] != null) {
      items = <FlashsaleItems>[];
      json['items'].forEach((v) {
        items.add(new FlashsaleItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start'] = this.start;
    data['end'] = this.end;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FlashsaleItems {
  ProductData product;

  FlashsaleItems({this.product});

  FlashsaleItems.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null
        ? new ProductData.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Shop {
  int id;
  String name;
  String slug;
  DataStates state;
  String updatedAt;
  List<ProductImage> image;

  Shop({this.id, this.name, this.slug, this.state, this.updatedAt, this.image});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    state =
        json['state'] != null ? new DataStates.fromJson(json['state']) : null;
    updatedAt = json['updatedAt'];
    if (json['image'] != null) {
      image = <ProductImage>[];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    data['updatedAt'] = this.updatedAt;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
