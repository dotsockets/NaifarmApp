import 'ThrowIfNoSuccess.dart';

class AddressesListRespone {
  List<Data> data;
  int total;
  ThrowIfNoSuccess http_call_back;

  AddressesListRespone({this.data, this.total,this.http_call_back});

  AddressesListRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  int id;
  String addressType;
  String addressTitle;
  String addressLine1;
  String addressLine2;
  int cityId;
  int stateId;
  String zipCode;
  String phone;

  Data(
      {this.id,
        this.addressType,
        this.addressTitle,
        this.addressLine1,
        this.addressLine2,
        this.cityId,
        this.stateId,
        this.zipCode,
        this.phone});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['addressType'];
    addressTitle = json['addressTitle'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    zipCode = json['zipCode'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressType'] = this.addressType;
    data['addressTitle'] = this.addressTitle;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['cityId'] = this.cityId;
    data['stateId'] = this.stateId;
    data['zipCode'] = this.zipCode;
    data['phone'] = this.phone;
    return data;
  }
}