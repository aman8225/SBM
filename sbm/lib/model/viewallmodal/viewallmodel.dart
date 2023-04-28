class ViewAllMassege {
  bool? success;
  ViewAllResponse? data;
  String? message;

  ViewAllMassege({this.success, this.data, this.message});

  ViewAllMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new ViewAllResponse.fromJson(json['data'])
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

class ViewAllResponse {
  int? id;
  String? categoryName;
  int? parentCategory;
  String? logo;
  String? categoryDescription;
  String? slug;
  Parents? parents;
  List<ChildCategoires>? childCategoires;

  ViewAllResponse(
      {this.id,
      this.categoryName,
      this.parentCategory,
      this.logo,
      this.categoryDescription,
      this.slug,
      this.parents,
      this.childCategoires});

  ViewAllResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    parentCategory = json['parent_category'];
    logo = json['logo'];
    categoryDescription = json['category_description'];
    slug = json['slug'];
    parents =
    json['parents'] != null ? new Parents.fromJson(json['parents']) : null;
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
    if (this.parents != null) {
      data['parents'] = this.parents!.toJson();
    }
    if (this.childCategoires != null) {
      data['child_categoires'] =
          this.childCategoires!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parents {
  int? id;
  String? categoryName;
  String? slug;
  int? parentCategory;
  Parent1? parent;

  Parents(
      {this.id,
        this.categoryName,
        this.slug,
        this.parentCategory,
        this.parent});

  Parents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
    parentCategory = json['parent_category'];
    parent =
    json['parent'] != null ? new Parent1.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    data['parent_category'] = this.parentCategory;
    if (this.parent != null) {
      data['parent'] = this.parent!.toJson();
    }
    return data;
  }
}

class Parent1 {
  int? id;
  String? categoryName;
  String? slug;
  Null? parentCategory;

  Parent1({this.id, this.categoryName, this.slug, this.parentCategory});

  Parent1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
    parentCategory = json['parent_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    data['parent_category'] = this.parentCategory;
    return data;
  }
}


class ChildCategoires {
  int? id;
  String? categoryName;
  int? parentCategory;
  String? logo;
  String? categoryDescription;
  String? slug;
  List<ChildCategoires>? childCategoires;
  List<Categories>? categories;

  ChildCategoires(
      {this.id,
      this.categoryName,
      this.parentCategory,
      this.logo,
      this.categoryDescription,
      this.slug,
      this.childCategoires,
      this.categories});

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
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
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
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildCategoires1 {
  int? id;
  String? categoryName;
  int? parentCategory;
  String? logo;
  String? categoryDescription;
  String? slug;
  List<Categories>? childCategoires;

  ChildCategoires1(
      {this.id,
      this.categoryName,
      this.parentCategory,
      this.logo,
      this.categoryDescription,
      this.slug,
      this.childCategoires});

  ChildCategoires1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    parentCategory = json['parent_category'];
    logo = json['logo'];
    categoryDescription = json['category_description'];
    slug = json['slug'];
    if (json['child_categoires'] != null) {
      childCategoires = <Categories>[];
      json['child_categoires'].forEach((v) {
        childCategoires!.add(new Categories.fromJson(v));
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

class Categories {
  int? id;
  String? categoryName;
  int? parentCategory;
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
