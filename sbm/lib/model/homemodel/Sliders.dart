class Sliders {
  String? image;
  String? mobileImage;
  Null? contents;

  Sliders({this.image, this.mobileImage, this.contents});

  Sliders.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    mobileImage = json['mobile_image'];
    contents = json['contents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['mobile_image'] = this.mobileImage;
    data['contents'] = this.contents;
    return data;
  }
}
