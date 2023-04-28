import 'ChildCategoires1.dart';

class ChildCategoires {
  int? id;
  String? categoryName;
  int? parentCategory;
  String? logo;
  String? categoryDescription;
  String? slug;
  List<ChildCategoires>? childCategoires;

  ChildCategoires(
      {this.id,
      this.categoryName,
      this.parentCategory,
      this.logo,
      this.categoryDescription,
      this.slug,
      this.childCategoires});

  ChildCategoires.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    parentCategory = json['parent_category'];
    logo = json['logo'];
    categoryDescription = json['category_description'];
    slug = json['slug'];
    if (json['child_categoires'] != null) {
      childCategoires = <ChildCategoires>[];
      json['child_categoires'].forEach((v) {
        childCategoires!.add(new ChildCategoires.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['parent_category'] = this.parentCategory;
    data['logo'] = this.logo;
    data['category_description'] = this.categoryDescription;
    data['slug'] = this.slug;
    if (this.childCategoires != null) {
      data['child_categoires'] =
          this.childCategoires!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
