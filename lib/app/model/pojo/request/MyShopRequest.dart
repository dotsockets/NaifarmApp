
class MyShopRequest {
  String name;
  String legalName;
  String slug;
  String description;
  String externalUrl;
  int stateId;
  int active;

  MyShopRequest(
      {this.name,
        this.legalName,
        this.slug,
        this.description,
        this.externalUrl,
        this.stateId,
        this.active});

  MyShopRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    legalName = json['legalName'];
    slug = json['slug'];
    description = json['description'];
    externalUrl = json['externalUrl'];
    stateId = json['stateId'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['legalName'] = this.legalName;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['externalUrl'] = this.externalUrl;
    data['stateId'] = this.stateId;
    data['active'] = this.active;
    return data;
  }
}

