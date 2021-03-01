class LoginRequest {
  String username;
  String phone;
  String password;
  String accessToken;
  String name;
  String email;
  PushService pushService;

  LoginRequest({this.username, this.phone, this.password,this.accessToken,this.name,this.email,this.pushService});

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
class PushService {
  int deviceType;
  String deviceModel;
  String deviceOS;
  String identifier;

  PushService(
      {this.deviceType, this.deviceModel, this.deviceOS, this.identifier});

  PushService.fromJson(Map<String, dynamic> json) {
    deviceType = json['deviceType'];
    deviceModel = json['deviceModel'];
    deviceOS = json['deviceOS'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceType'] = this.deviceType;
    data['deviceModel'] = this.deviceModel;
    data['deviceOS'] = this.deviceOS;
    data['identifier'] = this.identifier;
    return data;
  }
}