class SerchBarModel {
  bool? success;
  SearchData? data;
  String? message;

  SerchBarModel({this.success, this.data, this.message});

  SerchBarModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new SearchData.fromJson(json['data']) : null;
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

class SearchData {
  int? id;
  String? productName;
  String? sku;
  String? productType;
  String? regularPrice;
  String? mainImage;
  String? mediumImage;
  String? cartonQty;
  String? uprice;
  List<Variant>? variant;

  SearchData(
      {this.id,
        this.productName,
        this.sku,
        this.productType,
        this.regularPrice,
        this.mainImage,
        this.mediumImage,
        this.cartonQty,
        this.uprice,
        this.variant});

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    sku = json['sku'];
    productType = json['product_type'];
    regularPrice = json['regular_price'];
    mainImage = json['main_image'];
    mediumImage = json['medium_image'];
    cartonQty = json['cartonQty'];
    uprice = json['uprice'];
    if (json['variant'] != null) {
      variant = <Variant>[];
      json['variant'].forEach((v) {
        variant!.add(new Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['sku'] = this.sku;
    data['product_type'] = this.productType;
    data['regular_price'] = this.regularPrice;
    data['main_image'] = this.mainImage;
    data['medium_image'] = this.mediumImage;
    data['cartonQty'] = this.cartonQty;
    data['uprice'] = this.uprice;
    if (this.variant != null) {
      data['variant'] = this.variant!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variant {

  int? id;
  String? itemName;
  String? itemCode;
  int? stock;
  int? isCommited;
  int? qut;
  double? totalprice;
  bool? iconcolore;

  Variant({this.id, this.itemName, this.itemCode, this.isCommited, this.stock,this.qut,
    this.totalprice,
    this.iconcolore});

  Variant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemCode = json['item_code'];
    isCommited = json['IsCommited'];
    stock = json['stock'];
    qut = json['qut'];
    totalprice = json['totalprice'];
    iconcolore = json['iconcolore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    data['item_code'] = this.itemCode;
    data['IsCommited'] = this.isCommited;
    data['stock'] = this.stock;
    data['qut'] = this.qut;
    data['totalprice'] = this.totalprice;
    data['iconcolore'] = this.iconcolore;
    return data;
  }
}