class LoginRequest {
  String username;
  String phone;
  String password;
  String accessToken;
  String name;
  String email;

  LoginRequest({this.username, this.phone, this.password,this.accessToken,this.name,this.email});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phone = json['phone'];
    password = json['password'];
    accessToken = json['accessToken'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['accessToken'] = this.accessToken;
    data['name'] = this.name;
    return data;
  }
}