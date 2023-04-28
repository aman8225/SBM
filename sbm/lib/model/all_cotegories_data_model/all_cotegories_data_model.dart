class AllCotegoriesDataModelMassege {
  bool? success;
  List<AllCotegoriesDataModelResponse>? data;
  String? message;

  AllCotegoriesDataModelMassege({this.success, this.data, this.message});

  AllCotegoriesDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AllCotegoriesDataModelResponse>[];
      json['data'].forEach((v) {
        data!.add(new AllCotegoriesDataModelResponse.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AllCotegoriesDataModelResponse {
  int? id;
  String? categoryName;
  List<ChildCat>? childCat;
  String? slug;
  String? logo;

  AllCotegoriesDataModelResponse(
      {this.id, this.categoryName, this.childCat, this.slug, this.logo});

  AllCotegoriesDataModelResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['childCat'] != null) {
      childCat = <ChildCat>[];
      json['childCat'].forEach((v) {
        childCat!.add(new ChildCat.fromJson(v));
      });
    }
    slug = json['slug'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.childCat != null) {
      data['childCat'] = this.childCat!.map((v) => v.toJson()).toList();
    }
    data['slug'] = this.slug;
    data['logo'] = this.logo;
    return data;
  }
}

class ChildCat {
  int? id;
  String? categoryName;
  List<SubChildCat>? subchildcat;
  String? slug;
  String? logo;

  ChildCat(
      {this.id, this.categoryName, this.subchildcat, this.slug, this.logo});

  ChildCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['childCat'] != null) {
      subchildcat = <SubChildCat>[];
      json['childCat'].forEach((v) {
        subchildcat!.add(new SubChildCat.fromJson(v));
      });
    }
    slug = json['slug'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.subchildcat != null) {
      data['childCat'] = this.subchildcat!.map((v) => v.toJson()).toList();
    }
    data['slug'] = this.slug;
    data['logo'] = this.logo;
    return data;
  }
}

class SubChildCat {
  int? id;
  String? categoryName;
  String? slug;

  SubChildCat({this.id, this.categoryName, this.slug});

  SubChildCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    return data;
  }
}
