class Products {
  var id;
  var productName;
  var regularPrice;
  var productType;
  var thumbnailImage;
  var mediumImage;
  var mainImage;
  var sku;
  var slug;
  var uprice;
  var price;
  var discount;
  bool? wishlist;

  Products(
      {this.id,
        this.productName,
        this.regularPrice,
        this.productType,
        this.thumbnailImage,
        this.mediumImage,
        this.mainImage,
        this.sku,
        this.slug,
        this.uprice,
        this.price,
        this.discount,
        this.wishlist});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    regularPrice = json['regular_price'];
    productType = json['product_type'];
    thumbnailImage = json['thumbnail_image'];
    mediumImage = json['medium_image'];
    mainImage = json['main_image'];
    sku = json['sku'];
    slug = json['slug'];
    uprice = json['uprice'];
    price = json['price'];
    discount = json['discount'];
    wishlist = json['wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['regular_price'] = this.regularPrice;
    data['product_type'] = this.productType;
    data['thumbnail_image'] = this.thumbnailImage;
    data['medium_image'] = this.mediumImage;
    data['main_image'] = this.mainImage;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['uprice'] = this.uprice;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['wishlist'] = this.wishlist;
    return data;
  }
}

