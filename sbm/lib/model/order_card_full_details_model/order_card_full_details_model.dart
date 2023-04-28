class OrderCardFullDetailsModelMassege {
  bool? success;
  OrderCardFullDetailsModelResponse? data;
  String? message;

  OrderCardFullDetailsModelMassege({this.success, this.data, this.message});

  OrderCardFullDetailsModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new OrderCardFullDetailsModelResponse.fromJson(json['data'])
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

class OrderCardFullDetailsModelResponse {
  int? id;
  int? userid;
  String? paymentMethod;
  int? addressid;
  String? lastModified;
  String? datePurchased;
  String? orderPrice;
  String? shippingCost;
  int? statusId;
  String? orderStatus;
  String? orderInformation;
  int? couponCode;
  String? couponAmount;
  String? totalTax;
  int? orderedSource;
  List<TrackOrder>? trackOrder;
  List<Products>? products;
  String? grandTotal;

  OrderCardFullDetailsModelResponse(
      {this.id,
      this.userid,
      this.paymentMethod,
      this.addressid,
      this.lastModified,
      this.datePurchased,
      this.orderPrice,
      this.shippingCost,
      this.statusId,
      this.orderStatus,
      this.orderInformation,
      this.couponCode,
      this.couponAmount,
      this.totalTax,
      this.orderedSource,
      this.trackOrder,
      this.products,
      this.grandTotal});

  OrderCardFullDetailsModelResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    paymentMethod = json['payment_method'];
    addressid = json['addressid'];
    lastModified = json['last_modified'];
    datePurchased = json['date_purchased'];
    orderPrice = json['order_price'];
    shippingCost = json['shipping_cost'];
    statusId = json['status_id '];
    orderStatus = json['orderStatus'];
    orderInformation = json['order_information'];
    couponCode = json['coupon_code'];
    couponAmount = json['coupon_amount'];
    totalTax = json['total_tax'];
    orderedSource = json['ordered_source'];
    if (json['track_order'] != null) {
      trackOrder = <TrackOrder>[];
      json['track_order'].forEach((v) {
        trackOrder!.add(new TrackOrder.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    grandTotal = json['grandTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['payment_method'] = this.paymentMethod;
    data['addressid'] = this.addressid;
    data['last_modified'] = this.lastModified;
    data['date_purchased'] = this.datePurchased;
    data['order_price'] = this.orderPrice;
    data['shipping_cost'] = this.shippingCost;
    data['status_id '] = this.statusId;
    data['orderStatus'] = this.orderStatus;
    data['order_information'] = this.orderInformation;
    data['coupon_code'] = this.couponCode;
    data['coupon_amount'] = this.couponAmount;
    data['total_tax'] = this.totalTax;
    data['ordered_source'] = this.orderedSource;
    if (this.trackOrder != null) {
      data['track_order'] = this.trackOrder!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['grandTotal'] = this.grandTotal;
    return data;
  }
}

class TrackOrder {
  int? orderid;
  int? orderStatusId;
  String? orderStatusDate;
  String? status;

  TrackOrder(
      {this.orderid, this.orderStatusId, this.orderStatusDate, this.status});

  TrackOrder.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    orderStatusId = json['order_status_id'];
    orderStatusDate = json['order_status_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderid'] = this.orderid;
    data['order_status_id'] = this.orderStatusId;
    data['order_status_date'] = this.orderStatusDate;
    data['status'] = this.status;
    return data;
  }
}

class Products {
  int? id;
  String? productName;
  String? regularPrice;
  String? salePrice;
  String? mainImage;
  String? mediumImage;
  String? thumbnailImage;
  String? sku;
  String? slug;
  String? shortDescription;
  String? specification;
  int? quantity;
  String? subtotal;
  String? price;
  List<ProductsAttributes>? productsAttributes;
  String? uprice;
  List<ProductCategories>? productCategories;

  Products(
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
      this.quantity,
      this.subtotal,
      this.price,
      this.productsAttributes,
      this.uprice,
      this.productCategories});

  Products.fromJson(Map<String, dynamic> json) {
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
    quantity = json['quantity'];
    subtotal = json['subtotal'];
    price = json['price'];
    if (json['products_attributes'] != null) {
      productsAttributes = <ProductsAttributes>[];
      json['products_attributes'].forEach((v) {
        productsAttributes!.add(new ProductsAttributes.fromJson(v));
      });
    }
    uprice = json['uprice'];
    if (json['productCategories'] != null) {
      productCategories = <ProductCategories>[];
      json['productCategories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
      });
    }
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
    data['quantity'] = this.quantity;
    data['subtotal'] = this.subtotal;
    data['price'] = this.price;
    if (this.productsAttributes != null) {
      data['products_attributes'] =
          this.productsAttributes!.map((v) => v.toJson()).toList();
    }
    data['uprice'] = this.uprice;
    if (this.productCategories != null) {
      data['productCategories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsAttributes {
  int? variantId;
  String? itemCode;
  String? itemName;
  String? variantData;
  int? quantity;
  String? productPrice;

  ProductsAttributes(
      {this.variantId,
      this.itemCode,
      this.itemName,
      this.variantData,
      this.quantity,
      this.productPrice});

  ProductsAttributes.fromJson(Map<String, dynamic> json) {
    variantId = json['variant_id'];
    itemCode = json['item_code'];
    itemName = json['item_name'];
    variantData = json['variant_data'];
    quantity = json['quantity'];
    productPrice = json['product_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant_id'] = this.variantId;
    data['item_code'] = this.itemCode;
    data['item_name'] = this.itemName;
    data['variant_data'] = this.variantData;
    data['quantity'] = this.quantity;
    data['product_price'] = this.productPrice;
    return data;
  }
}

class ProductCategories {
  int? id;
  int? productId;
  int? categoryId;
  int? status;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? categoryName;
  int? parentCategory;
  String? categoryDescription;
  String? logo;
  String? banner;
  String? slug;
  String? seoName;
  String? seoDescription;
  String? seoTitle;
  String? seoKeyword;
  int? displayOrder;

  ProductCategories(
      {this.id,
      this.productId,
      this.categoryId,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.categoryName,
      this.parentCategory,
      this.categoryDescription,
      this.logo,
      this.banner,
      this.slug,
      this.seoName,
      this.seoDescription,
      this.seoTitle,
      this.seoKeyword,
      this.displayOrder});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    categoryName = json['category_name'];
    parentCategory = json['parent_category'];
    categoryDescription = json['category_description'];
    logo = json['logo'];
    banner = json['banner'];
    slug = json['slug'];
    seoName = json['seo_name'];
    seoDescription = json['seo_description'];
    seoTitle = json['seo_title'];
    seoKeyword = json['seo_keyword'];
    displayOrder = json['display_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['category_id'] = this.categoryId;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['category_name'] = this.categoryName;
    data['parent_category'] = this.parentCategory;
    data['category_description'] = this.categoryDescription;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['slug'] = this.slug;
    data['seo_name'] = this.seoName;
    data['seo_description'] = this.seoDescription;
    data['seo_title'] = this.seoTitle;
    data['seo_keyword'] = this.seoKeyword;
    data['display_order'] = this.displayOrder;
    return data;
  }
}
