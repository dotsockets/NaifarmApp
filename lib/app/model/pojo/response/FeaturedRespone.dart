
import 'SliderRespone.dart';

class FeaturedRespone {
  List<FeaturedData> data;
  int total;

  FeaturedRespone({this.data, this.total});

  FeaturedRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FeaturedData>();
      json['data'].forEach((v) {
        data.add(new FeaturedData.fromJson(v));
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

class FeaturedData {
  int id;
  String name;
  String slug;
  List<SliderImage> image;

  FeaturedData({this.id, this.name, this.slug, this.image});

  FeaturedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    if (json['image'] != null) {
      image = new List<Null>();
      json['image'].forEach((v) {
        image.add(new SliderImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

