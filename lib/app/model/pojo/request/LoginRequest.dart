class LoginRequest {
  String username;
  String phone;
  String password;

  LoginRequest({this.username, this.phone, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['password'] = this.password;
    return data;
  }
}