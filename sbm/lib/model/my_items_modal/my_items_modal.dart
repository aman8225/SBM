class MyItemsModal {
  bool? success;
  List<MyItemsModalmassege>? data;
  String? message;

  MyItemsModal({this.success, this.data, this.message});

  MyItemsModal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <MyItemsModalmassege>[];
      json['data'].forEach((v) {
        data!.add(new MyItemsModalmassege.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class MyItemsModalmassege {
  var id;
  var productName;
  var regularPrice;
  var salePrice;
  var mainImage;
  var mediumImage;
  var thumbnailImage;
  var sku;
  var slug;
  var shortDescription;
  var specification;
  var trendingProduct;
  var bestSelling;
  var orderPrice;
  var subTotal;
  var wishlist;
  var cartonQty;
  var price;
  var uprice;
  var discount;
  var estimateDeliveryDate;
  var regularPricee;
  var discountPercent;

  MyItemsModalmassege(
      {this.id,
        this.productName,
        this.regularPrice,
        this.salePrice,
        this.mainImage,
        this.mediumImage,
        this.thumbnailImage,
        this.sku,
        this.slug,
        this.shortDescription,
        this.specification,
        this.trendingProduct,
        this.bestSelling,
        this.orderPrice,
        this.subTotal,
        this.wishlist,
        this.cartonQty,
        this.price,
        this.uprice,
        this.discount,
        this.estimateDeliveryDate,
        this.regularPricee,
        this.discountPercent});

  MyItemsModalmassege.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    mainImage = json['main_image'];
    mediumImage = json['medium_image'];
    thumbnailImage = json['thumbnail_image'];
    sku = json['sku'];
    slug = json['slug'];
    shortDescription = json['short_description'];
    specification = json['specification'];
    trendingProduct = json['trending_product'];
    bestSelling = json['best_selling'];
    orderPrice = json['order_price'];
    subTotal = json['sub_total'];
    wishlist = json['wishlist'];
    cartonQty = json['cartonQty'];
    price = json['price'];
    uprice = json['uprice'];
    discount = json['discount'];
    estimateDeliveryDate = json['estimate_delivery_date'];
    regularPricee = json['regular_pricee'];
    discountPercent = json['discount_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['main_image'] = this.mainImage;
    data['medium_image'] = this.mediumImage;
    data['thumbnail_image'] = this.thumbnailImage;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['short_description'] = this.shortDescription;
    data['specification'] = this.specification;
    data['trending_product'] = this.trendingProduct;
    data['best_selling'] = this.bestSelling;
    data['order_price'] = this.orderPrice;
    data['sub_total'] = this.subTotal;
    data['wishlist'] = this.wishlist;
    data['cartonQty'] = this.cartonQty;
    data['price'] = this.price;
    data['uprice'] = this.uprice;
    data['discount'] = this.discount;
    data['estimate_delivery_date'] = this.estimateDeliveryDate;
    data['regular_pricee'] = this.regularPricee;
    data['discount_percent'] = this.discountPercent;
    return data;
  }
}