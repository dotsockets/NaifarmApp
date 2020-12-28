class zipCodeRespone {
  int zipCode;

  zipCodeRespone({this.zipCode});

  zipCodeRespone.fromJson(Map<String, dynamic> json) {
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zipCode'] = this.zipCode;
    return data;
  }
}

