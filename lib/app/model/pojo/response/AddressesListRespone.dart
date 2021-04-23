import 'ThrowIfNoSuccess.dart';

class AddressesListRespone {
  List<AddressesData> data;
  int total;
  ThrowIfNoSuccess httpCallBack;

  AddressesListRespone({this.data, this.total, this.httpCallBack});

  AddressesListRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AddressesData>[];
      json['data'].forEach((v) {
        data.add(new AddressesData.fromJson(v));
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

class AddressesData {
  int id;
  String addressType;
  String addressTitle;
  String addressLine1;
  String addressLine2;
  int cityId;
  int stateId;
  String zipCode;
  String phone;
  bool select;
  City city;
  StateAddress state;

  AddressesData(
      {this.id,
      this.addressType,
      this.addressTitle,
      this.addressLine1,
      this.addressLine2,
      this.cityId,
      this.stateId,
      this.zipCode,
      this.phone,
      this.select, this.city,this.state});

  AddressesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['addressType'];
    addressTitle = json['addressTitle'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    zipCode = json['zipCode'];
    phone = json['phone'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    state = json['state'] != null ? new StateAddress.fromJson(json['state']) : null;
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
class City {
  int id;
  String name;

  City({this.id, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class StateAddress {
  int id;
  String name;

  StateAddress({this.id, this.name});

  StateAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}