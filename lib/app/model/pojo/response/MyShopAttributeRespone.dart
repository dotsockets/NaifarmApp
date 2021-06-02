class MyShopAttributeRespone {
  List<SubAttributeData> data;
  int total;

  MyShopAttributeRespone({this.data, this.total});

  MyShopAttributeRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SubAttributeData>[];
      json['data'].forEach((v) {
        data.add(new SubAttributeData.fromJson(v));
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

class SubAttributeData {
  int id;
  String name;
  String value;
  String color;

  SubAttributeData({this.id, this.name, this.value, this.color});

  SubAttributeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['color'] = this.color;
    return data;
  }
}
class AttributeData {
  int id;
  String name;

  AttributeData({this.id, this.name});

  AttributeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['name'] = this.name;
      return data;
    }
  }
}
