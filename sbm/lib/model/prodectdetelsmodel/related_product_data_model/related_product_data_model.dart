class RelatedProductDataModelMassege {
  bool? success;
  List<RelatedProductDataResponse>? data;
  String? message;

  RelatedProductDataModelMassege({this.success, this.data, this.message});

  RelatedProductDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <RelatedProductDataResponse>[];
      json['data'].forEach((v) {
        data!.add(new RelatedProductDataResponse.fromJson(v));
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

class RelatedProductDataResponse {
  int? id;
  String? productName;
  String? productType;
  String? shortDescription;
  String? regularPrice;
  String? salePrice;
  String? mainImage;
  String? mediumImage;
  String? thumbnailImage;
  String? sku;
  String? slug;
  String? specification;
  int? trendingProduct;
  int? bestSelling;
  String? uprice;
  String? price;
  String? discount;
  String? fronturl;
  String? discountPercent;
  bool? wishlist;
  RelatedProductDataResponse(
      {this.id,
      this.productName,
      this.productType,
      this.shortDescription,
      this.regularPrice,
      this.salePrice,
      this.mainImage,
      this.mediumImage,
      this.thumbnailImage,
      this.sku,
      this.slug,
      this.specification,
      this.trendingProduct,
      this.bestSelling,
      this.uprice,
      this.price,
      this.discount,
      this.fronturl,
      this.discountPercent,
      this.wishlist});

  RelatedProductDataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productType = json['product_type'];
    shortDescription = json['short_description'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    mainImage = json['main_image'];
    mediumImage = json['medium_image'];
    thumbnailImage = json['thumbnail_image'];
    sku = json['sku'];
    slug = json['slug'];
    specification = json['specification'];
    trendingProduct = json['trending_product'];
    bestSelling = json['best_selling'];
    uprice = json['uprice'];
    price = json['price'];
    discount = json['discount'];
    fronturl = json['fronturl'];
    discountPercent = json['discount_percent'];
    wishlist = json['wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['short_description'] = this.shortDescription;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['main_image'] = this.mainImage;
    data['medium_image'] = this.mediumImage;
    data['thumbnail_image'] = this.thumbnailImage;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['specification'] = this.specification;
    data['trending_product'] = this.trendingProduct;
    data['best_selling'] = this.bestSelling;
    data['uprice'] = this.uprice;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['fronturl'] = this.fronturl;
    data['discount_percent'] = this.discountPercent;
    data['wishlist'] = this.wishlist;
    return data;
  }
}
