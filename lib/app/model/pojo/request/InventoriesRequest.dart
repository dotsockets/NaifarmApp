class InventoriesRequest {
  String title;
  int stockQuantity;
  int salePrice;
  int active;
  int offerPrice;

  InventoriesRequest(
      {this.title,
        this.stockQuantity,
        this.salePrice,
        this.active,
        this.offerPrice});

  InventoriesRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    stockQuantity = json['stockQuantity'];
    salePrice = json['salePrice'];
    active = json['active'];
    offerPrice = json['offerPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['stockQuantity'] = this.stockQuantity;
    data['salePrice'] = this.salePrice;
    data['active'] = this.active;
    data['offerPrice'] = this.offerPrice;
    return data;
  }
}

