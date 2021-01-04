class AddressCreaterequest {
  int id;
  String addressType;
  String addressTitle;
  int countryId;
  String zipCode;
  String addressLine1;
  String addressLine2;
  int cityId;
  int stateId;
  String phone;

  AddressCreaterequest(
      {this.id,
        this.addressType,
        this.addressTitle,
        this.countryId,
        this.zipCode,
        this.addressLine1,
        this.addressLine2,
        this.cityId,
        this.stateId,
        this.phone});

  AddressCreaterequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['addressType'];
    addressTitle = json['addressTitle'];
    countryId = json['countryId'];
    zipCode = json['zipCode'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressType'] = this.addressType;
    data['addressTitle'] = this.addressTitle;
    data['countryId'] = this.countryId;
    data['zipCode'] = this.zipCode;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['cityId'] = this.cityId;
    data['stateId'] = this.stateId;
    data['phone'] = this.phone;
    return data;
  }
}