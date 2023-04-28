class FiltterDataModelMessege {
  bool? success;
  Data? data;
  String? message;

  FiltterDataModelMessege({this.success, this.data, this.message});

  FiltterDataModelMessege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<PopularBrands>? popularBrands;
  List<Category>? category;
  List<PriceInAED>? priceInAED;
  List<Brands>? brands;
  List<Discount>? discount;
  List<String>? badges;
  List<String>? availability;

  Data(
      {this.popularBrands,
      this.category,
      this.priceInAED,
      this.brands,
      this.discount,
      this.badges,
      this.availability});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Popular_Brands'] != null) {
      popularBrands = <PopularBrands>[];
      json['Popular_Brands'].forEach((v) {
        popularBrands!.add(new PopularBrands.fromJson(v));
      });
    }
    if (json['Category'] != null) {
      category = <Category>[];
      json['Category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['Price_in_AED'] != null) {
      priceInAED = <PriceInAED>[];
      json['Price_in_AED'].forEach((v) {
        priceInAED!.add(new PriceInAED.fromJson(v));
      });
    }
    if (json['Brands'] != null) {
      brands = <Brands>[];
      json['Brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
    if (json['Discount'] != null) {
      discount = <Discount>[];
      json['Discount'].forEach((v) {
        discount!.add(new Discount.fromJson(v));
      });
    }
    badges = json['Badges'].cast<String>();
    availability = json['Availability'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.popularBrands != null) {
      data['Popular_Brands'] =
          this.popularBrands!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['Category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.priceInAED != null) {
      data['Price_in_AED'] = this.priceInAED!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['Brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.discount != null) {
      data['Discount'] = this.discount!.map((v) => v.toJson()).toList();
    }
    data['Badges'] = this.badges;
    data['Availability'] = this.availability;
    return data;
  }
}

class PopularBrands {
  int? id;
  String? name;
  int? count;
  bool? isSelected;

  PopularBrands({this.id, this.name, this.count, this.isSelected});

  PopularBrands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class PriceInAED {
  String? name;
  String? value;
  bool? isSelected;
  PriceInAED({this.name, this.value, this.isSelected});

  PriceInAED.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class Brands {
  int? id;
  String? name;
  int? count;
  bool? isSelected;

  Brands({this.id, this.name, this.count, this.isSelected});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}

class Discount {
  String? name;
  String? value;
  bool? isSelected;
  Discount({this.name, this.value, this.isSelected});

  Discount.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
