class ItamStockDataModelMassege {
  bool? success;
  List<ItamStockDataModelresponse>? data;

  ItamStockDataModelMassege({this.success, this.data});

  ItamStockDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ItamStockDataModelresponse>[];
      json['data'].forEach((v) {
        data!.add(new ItamStockDataModelresponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItamStockDataModelresponse {
  String? itemCode;
  String? itemName;
  int? availableStock;
  int? committed;
  String? uItemgrp;
  ItamStockDataModelresponse(
      {this.itemCode,
      this.itemName,
      this.availableStock,
      this.committed,
      this.uItemgrp});

  ItamStockDataModelresponse.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    availableStock = json['AvailableStock'];
    committed = json['Committed'];
    uItemgrp = json['U_Itemgrp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['AvailableStock'] = this.availableStock;
    data['Committed'] = this.committed;
    data['U_Itemgrp'] = this.uItemgrp;
    return data;
  }
}
