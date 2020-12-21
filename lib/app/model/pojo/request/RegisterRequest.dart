class RegisterRequest {
  String name;
  String email;
  String password;
  String phone;
  int agree;

  RegisterRequest(
      {this.name, this.email, this.password, this.phone, this.agree});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    agree = json['agree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['agree'] = this.agree;
    return data;
  }
}