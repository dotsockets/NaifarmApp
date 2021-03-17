
class FbProfile {
  String name;
  String firstName;
  String lastName;
  String email;
  String id;
  String token;

  FbProfile(
      {this.name,
      this.firstName,
      this.lastName,
      this.email,
      this.id,
      this.token});

  FbProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    firstName = json['first_name'].toString();
    lastName = json['last_name'].toString();
    email = json['email'].toString();
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['id'] = this.id;
    return data;
  }
}

class FbError {
  ErrorData error;

  FbError({this.error});

  FbError.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? new ErrorData.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class ErrorData {
  String message;
  String type;
  int code;
  String fbtraceId;

  ErrorData({this.message, this.type, this.code, this.fbtraceId});

  ErrorData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    type = json['type'];
    code = json['code'];
    fbtraceId = json['fbtrace_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['type'] = this.type;
    data['code'] = this.code;
    data['fbtrace_id'] = this.fbtraceId;
    return data;
  }
}