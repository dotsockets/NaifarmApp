class BannersRespone {
  List<BannersData> data;
  int total;

  BannersRespone({this.data, this.total});

  BannersRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BannersData>[];
      json['data'].forEach((v) {
        data.add(new BannersData.fromJson(v));
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

class BannersData {
  int id;
  String title;
  String description;
  String link;
  String linkLabel;
  String bgColor;
  int columns;
  int order;
  List<BannersImage> image;

  BannersData(
      {this.id,
      this.title,
      this.description,
      this.link,
      this.linkLabel,
      this.bgColor,
      this.columns,
      this.order,
      this.image});

  BannersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    linkLabel = json['linkLabel'];
    bgColor = json['bgColor'];
    columns = json['columns'];
    order = json['order'];
    if (json['image'] != null) {
      image = <BannersImage>[];
      json['image'].forEach((v) {
        image.add(new BannersImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['link'] = this.link;
    data['linkLabel'] = this.linkLabel;
    data['bgColor'] = this.bgColor;
    data['columns'] = this.columns;
    data['order'] = this.order;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannersImage {
  int id;
  String path;
  String name;
  String extension;
  String size;
  int imageableId;
  String imageableType;
  int featured;
  int order;

  BannersImage(
      {this.id,
      this.path,
      this.name,
      this.extension,
      this.size,
      this.imageableId,
      this.imageableType,
      this.featured,
      this.order});

  BannersImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    name = json['name'];
    extension = json['extension'];
    size = json['size'];
    imageableId = json['imageableId'];
    imageableType = json['imageableType'];
    featured = json['featured'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    data['name'] = this.name;
    data['extension'] = this.extension;
    data['size'] = this.size;
    data['imageableId'] = this.imageableId;
    data['imageableType'] = this.imageableType;
    data['featured'] = this.featured;
    data['order'] = this.order;
    return data;
  }
}
