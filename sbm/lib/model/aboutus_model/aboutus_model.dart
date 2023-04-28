class AboutUsModelMassege {
  bool? success;
  Data? data;
  String? message;

  AboutUsModelMassege({this.success, this.data, this.message});

  AboutUsModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? pageName;
  String? banner;
  String? pageDescription;
  String? video;
  String? seoTitle;
  String? seoDescription;
  String? seoKeyword;
  String? slug;
  int? createdBy;
  int? status;
  String? createdAt;
  String? updatedAt;
  Data(
      {this.id,
      this.pageName,
      this.banner,
      this.pageDescription,
      this.video,
      this.seoTitle,
      this.seoDescription,
      this.seoKeyword,
      this.slug,
      this.createdBy,
      this.status,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageName = json['page_name'];
    banner = json['banner'];
    pageDescription = json['page_description'];
    video = json['video'];
    seoTitle = json['seo_title'];
    seoDescription = json['seo_description'];
    seoKeyword = json['seo_keyword'];
    slug = json['slug'];
    createdBy = json['created_by'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['page_name'] = this.pageName;
    data['banner'] = this.banner;
    data['page_description'] = this.pageDescription;
    data['video'] = this.video;
    data['seo_title'] = this.seoTitle;
    data['seo_description'] = this.seoDescription;
    data['seo_keyword'] = this.seoKeyword;
    data['slug'] = this.slug;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
