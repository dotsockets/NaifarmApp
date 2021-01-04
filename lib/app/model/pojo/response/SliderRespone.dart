
class SliderRespone {
  List<SliderData> data;
  int total;

  SliderRespone({this.data, this.total});

  SliderRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SliderData>();
      json['data'].forEach((v) {
        data.add(new SliderData.fromJson(v));
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

class SliderData {
  int id;
  String title;
  String titleColor;
  String subTitle;
  String subTitleColor;
  String link;
  int order;
  List<SliderImage> image;

  SliderData(
      {this.id,
        this.title,
        this.titleColor,
        this.subTitle,
        this.subTitleColor,
        this.link,
        this.order,
        this.image});

  SliderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    titleColor = json['titleColor'];
    subTitle = json['subTitle'];
    subTitleColor = json['subTitleColor'];
    link = json['link'];
    order = json['order'];
    if (json['image'] != null) {
      image = new List<SliderImage>();
      json['image'].forEach((v) {
        image.add(new SliderImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['titleColor'] = this.titleColor;
    data['subTitle'] = this.subTitle;
    data['subTitleColor'] = this.subTitleColor;
    data['link'] = this.link;
    data['order'] = this.order;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SliderImage {
  String name;
  String path;

  SliderImage({this.name, this.path});

  SliderImage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['path'] = this.path;
    return data;
  }
}

