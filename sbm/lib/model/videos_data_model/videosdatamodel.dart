class VideosDataModelMassege {
  bool? success;
  List<VideosDataResponse>? data;
  String? message;

  VideosDataModelMassege({this.success, this.data, this.message});

  VideosDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <VideosDataResponse>[];
      json['data'].forEach((v) {
        data!.add(new VideosDataResponse.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class VideosDataResponse {
  int? id;
  String? productName;
  String? slug;
  String? sku;
  int? productId;
  String? video;
  int? status;
  String? createdAt;
  String? placeholder;
  int? leftDays;
  VideosDataResponse(
      {this.id,
      this.productName,
      this.slug,
      this.sku,
      this.productId,
      this.video,
      this.status,
      this.createdAt,
      this.placeholder,
      this.leftDays});

  VideosDataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    slug = json['slug'];
    sku = json['sku'];
    productId = json['product_id'];
    video = json['video'];
    status = json['status'];
    createdAt = json['created_at'];
    placeholder = json['placeholder'];
    leftDays = json['left_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['slug'] = this.slug;
    data['sku'] = this.sku;
    data['product_id'] = this.productId;
    data['video'] = this.video;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['placeholder'] = this.placeholder;
    data['left_days'] = this.leftDays;
    return data;
  }
}
