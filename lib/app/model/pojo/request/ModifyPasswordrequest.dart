class ModifyPasswordrequest {
  String password;
  String checkPassword;
  String oldPassword;

  ModifyPasswordrequest({this.password, this.checkPassword, this.oldPassword});

  ModifyPasswordrequest.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    checkPassword = json['checkPassword'];
    oldPassword = json['oldPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['checkPassword'] = this.checkPassword;
    data['oldPassword'] = this.oldPassword;
    return data;
  }
}