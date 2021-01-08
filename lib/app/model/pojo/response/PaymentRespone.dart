

class PaymentRespone {
  List<PaymentData> data;
  int total;

  PaymentRespone({this.data, this.total});

  PaymentRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<PaymentData>();
      json['data'].forEach((v) {
        data.add(new PaymentData.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class PaymentData {
  int id;
  String code;
  String name;
  int type;
  String companyName;
  String website;
  String helpDocLink;
  String termsConditionsLink;
  String description;
  int order;
  String createAt;
  String updateAt;
  bool active = false;

  PaymentData(
      {this.id,
        this.code,
        this.name,
        this.type,
        this.companyName,
        this.website,
        this.helpDocLink,
        this.termsConditionsLink,
        this.description,
        this.order,
        this.createAt,
        this.updateAt,this.active});

  PaymentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
    companyName = json['companyName'];
    website = json['website'];
    helpDocLink = json['helpDocLink'];
    termsConditionsLink = json['termsConditionsLink'];
    description = json['description'];
    order = json['order'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['type'] = this.type;
    data['companyName'] = this.companyName;
    data['website'] = this.website;
    data['helpDocLink'] = this.helpDocLink;
    data['termsConditionsLink'] = this.termsConditionsLink;
    data['description'] = this.description;
    data['order'] = this.order;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

