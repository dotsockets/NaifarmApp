
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
