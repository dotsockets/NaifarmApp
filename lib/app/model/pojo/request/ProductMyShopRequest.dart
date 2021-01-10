
class ProductMyShopRequest {
  String name;
  int category;
  int stockQuantity;
  int salePrice;
  int sendArea;
  int weight;
  int packaging;
  String description;
  String slug;
  int offerPrice;
  String offerStart;
  String offerEnd;
  List<Attributes> attributes;

  ProductMyShopRequest(
      {this.name,
        this.category,
        this.stockQuantity,
        this.salePrice,
        this.sendArea,
        this.weight,
        this.packaging,
        this.description,
        this.slug,
        this.offerPrice,
        this.offerStart,
        this.offerEnd,
        this.attributes});

  ProductMyShopRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    stockQuantity = json['stockQuantity'];
    salePrice = json['salePrice'];
    sendArea = json['sendArea'];
    weight = json['weight'];
    packaging = json['packaging'];
    description = json['description'];
    slug = json['slug'];
    offerPrice = json['offerPrice'];
    offerStart = json['offerStart'];
    offerEnd = json['offerEnd'];
    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.category;
    data['stockQuantity'] = this.stockQuantity;
    data['salePrice'] = this.salePrice;
    data['sendArea'] = this.sendArea;
    data['weight'] = this.weight;
    data['packaging'] = this.packaging;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['offerPrice'] = this.offerPrice;
    data['offerStart'] = this.offerStart;
    data['offerEnd'] = this.offerEnd;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes {
  int id;
  int valueId;

  Attributes({this.id, this.valueId});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valueId = json['valueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valueId'] = this.valueId;
    return data;
  }
}

