class SystemRespone {
  String supportPhone;
  String supportEmail;
  String bankAccount;
  String bankAccountName;
  String bankAccountNumber;
  String bankAccountMobile;

  SystemRespone(
      {this.supportPhone,
      this.supportEmail,
      this.bankAccount,
      this.bankAccountName,
      this.bankAccountNumber,
      this.bankAccountMobile});

  SystemRespone.fromJson(Map<String, dynamic> json) {
    supportPhone = json['supportPhone'];
    supportEmail = json['supportEmail'];
    bankAccount = json['bankAccount'];
    bankAccountName = json['bankAccountName'];
    bankAccountNumber = json['bankAccountNumber'];
    bankAccountMobile = json['bankAccountMobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supportPhone'] = this.supportPhone;
    data['supportEmail'] = this.supportEmail;
    data['bankAccount'] = this.bankAccount;
    data['bankAccountName'] = this.bankAccountName;
    data['bankAccountNumber'] = this.bankAccountNumber;
    data['bankAccountMobile'] = this.bankAccountMobile;
    return data;
  }
}
