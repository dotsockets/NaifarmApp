class InformationRespone {
  int id;
  int authorId;
  String title;
  String slug;
  String content;
  String publishedAt;
  int visibility;
  int position;

  InformationRespone(
      {this.id,
        this.authorId,
        this.title,
        this.slug,
        this.content,
        this.publishedAt,
        this.visibility,
        this.position});

  InformationRespone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authorId = json['authorId'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
    publishedAt = json['publishedAt'];
    visibility = json['visibility'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['authorId'] = this.authorId;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['content'] = this.content;
    data['publishedAt'] = this.publishedAt;
    data['visibility'] = this.visibility;
    data['position'] = this.position;
    return data;
  }
}