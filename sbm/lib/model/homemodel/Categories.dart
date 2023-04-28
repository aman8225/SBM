import 'ChildCategoires.dart';

class Categories {
  int? id;
  String? categoryName;
  Null? parentCategory;
  String? logo;
  String? categoryDescription;
  String? slug;

  Categories(
      {this.id,
        this.categoryName,
        this.parentCategory,
        this.logo,
        this.categoryDescription,
        this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    parentCategory = json['parent_category'];
    logo = json['logo'];
    categoryDescription = json['category_description'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['parent_category'] = this.parentCategory;
    data['logo'] = this.logo;
    data['category_description'] = this.categoryDescription;
    data['slug'] = this.slug;
    return data;
  }
}
