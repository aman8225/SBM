class CartData {
  List<Items>? items;
   var grandTotal;
  var vat;
  var vatAmount;
  var amountPayable;
  var totalDiscount;
  var cartonsTotal;


  CartData(
      {this.items,
      this.grandTotal,
      this.vat,
      this.vatAmount,
      this.amountPayable,
      this.totalDiscount,
        this.cartonsTotal});

  CartData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    grandTotal = json['grandTotal'];
    vat = json['vat'];
    vatAmount = json['vat_amount'];
    amountPayable = json['amount_payable'];
    totalDiscount = json['total_discount'];
    cartonsTotal = json['cartonsTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['grandTotal'] = this.grandTotal;
    data['vat'] = this.vat;
    data['vat_amount'] = this.vatAmount;
    data['amount_payable'] = this.amountPayable;
    data['total_discount'] = this.totalDiscount;
    data['cartonsTotal'] = this.cartonsTotal;
    return data;
  }
}

class Items {
  var id;
  var quantity;
  var price;
  var userId;
  var productName;
  var regularPrice;
  var salePrice;
  var thumbnailImage;
  var sku;
  var slug;
  var specification;
  var uSCartQty;
  var subtotal;
  var mainImage;
  List<ProductsAttributes>? productsAttributes;
  List<ProductCategories>? productCategories;

  Items(
      {this.id,
      this.quantity,
      this.price,
      this.userId,
      this.productName,
      this.regularPrice,
      this.salePrice,
      this.thumbnailImage,
      this.sku,
      this.slug,
      this.specification,
      this.uSCartQty,
      this.subtotal,
      this.mainImage,
      this.productsAttributes,
      this.productCategories});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    userId = json['user_id'];
    productName = json['product_name'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    thumbnailImage = json['thumbnail_image'];
    sku = json['sku'];
    slug = json['slug'];
    specification = json['specification'];
    uSCartQty = json['U_SCartQty'];
    subtotal = json['subtotal'];
    mainImage = json['main_image'];
    if (json['products_attributes'] != null) {
      productsAttributes = <ProductsAttributes>[];
      json['products_attributes'].forEach((v) {
        productsAttributes!.add(new ProductsAttributes.fromJson(v));
      });
    }
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
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['user_id'] = this.userId;
    data['product_name'] = this.productName;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['thumbnail_image'] = this.thumbnailImage;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['specification'] = this.specification;
    data['U_SCartQty'] = this.uSCartQty;
    data['subtotal'] = this.subtotal;
    data['main_image'] = this.mainImage;
    if (this.productsAttributes != null) {
      data['products_attributes'] =
          this.productsAttributes!.map((v) => v.toJson()).toList();
    }
    if (this.productCategories != null) {
      data['product_categories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsAttributes {
  var variantId;
  var itemCode;
  var productVariantData;
  var itemName;
  var quantity;
  var stock;
  var isCommited;

  ProductsAttributes(
      {this.variantId,
      this.itemCode,
      this.productVariantData,
      this.itemName,
      this.quantity,
      this.stock,
      this.isCommited});

  ProductsAttributes.fromJson(Map<String, dynamic> json) {
    variantId = json['variant_id'];
    itemCode = json['item_code'];
    productVariantData = json['product_variant_data'];
    itemName = json['item_name'];
    quantity = json['quantity'];
    stock = json['stock'];
    isCommited = json['IsCommited'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant_id'] = this.variantId;
    data['item_code'] = this.itemCode;
    data['product_variant_data'] = this.productVariantData;
    data['item_name'] = this.itemName;
    data['quantity'] = this.quantity;
    data['stock'] = this.stock;
    data['IsCommited'] = this.isCommited;
    return data;
  }
}

class ProductCategories {
  var id;
  var productId;
  var categoryId;
  var status;
  var createdBy;
  var updatedBy;
  var createdAt;
  var updatedAt;
  var deletedAt;
  var categoryName;
  var parentCategory;
  var categoryDescription;
  var logo;
  var banner;
  var slug;
  var seoName;
  var seoDescription;
  var seoTitle;
  var seoKeyword;
  var displayOrder;

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
