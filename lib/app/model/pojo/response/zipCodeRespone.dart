class ZipCodeRespone {
  int zipCode;

  ZipCodeRespone({this.zipCode});

  ZipCodeRespone.fromJson(Map<String, dynamic> json) {
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zipCode'] = this.zipCode;
    return data;
  }
}
