class Brands {
  int? id;
  String? brandName;
  String? brandLogo;
  String? slug;

  Brands({this.id, this.brandName, this.brandLogo, this.slug});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandName = json['brand_name'];
    brandLogo = json['brand_logo'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_name'] = this.brandName;
    data['brand_logo'] = this.brandLogo;
    data['slug'] = this.slug;
    return data;
  }
}
