import 'ProductCategories.dart';

class TopsaleProducts {
  var id;
  var productName;
  var productType;
  var thumbnailImage;
  var mediumImage;
  var mainImage;
  var sku;
  var slug;
  var uprice;
  var price;
  var wishlist;
  List<ProductCategories>? productCategories;

  TopsaleProducts(
      {this.id,
        this.productName,
        this.productType,
        this.thumbnailImage,
        this.mediumImage,
        this.mainImage,
        this.sku,
        this.slug,
        this.uprice,
        this.price,
        this.wishlist,
        this.productCategories});

  TopsaleProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productType = json['product_type'];
    thumbnailImage = json['thumbnail_image'];
    mediumImage = json['medium_image'];
    mainImage = json['main_image'];
    sku = json['sku'];
    slug = json['slug'];
    uprice = json['uprice'];
    price = json['price'];
    wishlist = json['wishlist'];
    if (json['product_categories'] != null) {
      productCategories = <ProductCategories>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['thumbnail_image'] = this.thumbnailImage;
    data['medium_image'] = this.mediumImage;
    data['main_image'] = this.mainImage;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['uprice'] = this.uprice;
    data['price'] = this.price;
    data['wishlist'] = this.wishlist;
    if (this.productCategories != null) {
      data['product_categories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

