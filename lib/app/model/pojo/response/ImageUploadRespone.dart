
class ImageUploadRespone {
  int id;
  String path;
  String name;
  String extension;
  String size;
  int imageableId;
  String imageableType;
  int featured;
  int order;

  ImageUploadRespone(
      {this.id,
        this.path,
        this.name,
        this.extension,
        this.size,
        this.imageableId,
        this.imageableType,
        this.featured,
        this.order});

  ImageUploadRespone.fromJson(Map<String, dynamic> json) {
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

