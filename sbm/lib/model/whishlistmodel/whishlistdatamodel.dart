class WhishListDataMessege {
  bool? success;
  WhishListRespose? data;
  String? message;

  WhishListDataMessege({this.success, this.data, this.message});

  WhishListDataMessege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new WhishListRespose.fromJson(json['data'])
        : null;
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

class WhishListRespose {
  int? currentPage;
  List<CardData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  WhishListRespose(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  WhishListRespose.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <CardData>[];
      json['data'].forEach((v) {
        data!.add(new CardData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class CardData {
  int? id;
  String? productName;
  String? productType;
  String? regularPrice;
  String? salePrice;
  String? mainImage;
  String? mediumImage;
  String? sku;
  String? slug;
  String? shortDescription;
  String? specification;
  int? trendingProduct;
  int? bestSelling;
  String? uprice;
  String? price;
  String? discount;
  String? thumbnailImage;
  bool? wishlist;
  String? discountPercent;

  CardData(
      {this.id,
      this.productName,
      this.productType,
      this.regularPrice,
      this.salePrice,
      this.mainImage,
      this.mediumImage,
      this.sku,
      this.slug,
      this.shortDescription,
      this.specification,
      this.trendingProduct,
      this.bestSelling,
      this.uprice,
      this.price,
      this.discount,
      this.thumbnailImage,
      this.wishlist,
      this.discountPercent});

  CardData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productType = json['product_type'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    mainImage = json['main_image'];
    mediumImage = json['medium_image'];
    sku = json['sku'];
    slug = json['slug'];
    shortDescription = json['short_description'];
    specification = json['specification'];
    trendingProduct = json['trending_product'];
    bestSelling = json['best_selling'];
    uprice = json['uprice'];
    price = json['price'];
    discount = json['discount'];
    thumbnailImage = json['thumbnail_image'];
    wishlist = json['wishlist'];
    discountPercent = json['discount_percent'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['main_image'] = this.mainImage;
    data['medium_image'] = this.mediumImage;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['short_description'] = this.shortDescription;
    data['specification'] = this.specification;
    data['trending_product'] = this.trendingProduct;
    data['best_selling'] = this.bestSelling;
    data['uprice'] = this.uprice;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['thumbnail_image'] = this.thumbnailImage;
    data['wishlist'] = this.wishlist;
    data['discount_percent'] = this.discountPercent;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
