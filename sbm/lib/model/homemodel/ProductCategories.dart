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
