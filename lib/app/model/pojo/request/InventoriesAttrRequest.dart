class InventoriesAttrRequest {
  String title;
  String brand;
  String condition;
  String conditionNote;
  int purchasePrice;
  int shippingWeight;
  int freeShipping;
  String availableFrom;
  int minOrderQuantity;
  int stockQuantity;
  int salePrice;
  int packaging;
  String description;
  int offerPrice;
  String offerStart;
  String offerEnd;
  List<AttributesListItem> attributes;
  int preorder;
  String preorderMsg;
  String preorderStart;
  String preorderEnd;
  int active;

  InventoriesAttrRequest(
      {this.title,
        this.brand,
        this.condition,
        this.conditionNote,
        this.purchasePrice,
        this.shippingWeight,
        this.freeShipping,
        this.availableFrom,
        this.minOrderQuantity,
        this.stockQuantity,
        this.salePrice,
        this.packaging,
        this.description,
        this.offerPrice,
        this.offerStart,
        this.offerEnd,
        this.attributes,
        this.preorder,
        this.preorderMsg,
        this.preorderStart,
        this.preorderEnd,
        this.active});

  InventoriesAttrRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    brand = json['brand'];
    condition = json['condition'];
    conditionNote = json['conditionNote'];
    purchasePrice = json['purchasePrice'];
    shippingWeight = json['shippingWeight'];
    freeShipping = json['freeShipping'];
    availableFrom = json['availableFrom'];
    minOrderQuantity = json['minOrderQuantity'];
    stockQuantity = json['stockQuantity'];
    salePrice = json['salePrice'];
    packaging = json['packaging'];
    description = json['description'];
    offerPrice = json['offerPrice'];
    offerStart = json['offerStart'];
    offerEnd = json['offerEnd'];
    if (json['attributes'] != null) {
      attributes = new List<AttributesListItem>();
      json['attributes'].forEach((v) {
        attributes.add(new AttributesListItem.fromJson(v));
      });
    }
    preorder = json['preorder'];
    preorderMsg = json['preorderMsg'];
    preorderStart = json['preorderStart'];
    preorderEnd = json['preorderEnd'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['brand'] = this.brand;
    data['condition'] = this.condition;
    data['conditionNote'] = this.conditionNote;
    data['purchasePrice'] = this.purchasePrice;
    data['shippingWeight'] = this.shippingWeight;
    data['freeShipping'] = this.freeShipping;
    data['availableFrom'] = this.availableFrom;
    data['minOrderQuantity'] = this.minOrderQuantity;
    data['stockQuantity'] = this.stockQuantity;
    data['salePrice'] = this.salePrice;
    data['packaging'] = this.packaging;
    data['description'] = this.description;
    data['offerPrice'] = this.offerPrice;
    data['offerStart'] = this.offerStart;
    data['offerEnd'] = this.offerEnd;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    data['preorder'] = this.preorder;
    data['preorderMsg'] = this.preorderMsg;
    data['preorderStart'] = this.preorderStart;
    data['preorderEnd'] = this.preorderEnd;
    data['active'] = this.active;
    return data;
  }
}

class AttributesListItem {
  int id;
  int valueId;

  AttributesListItem({this.id, this.valueId});

  AttributesListItem.fromJson(Map<String, dynamic> json) {
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
