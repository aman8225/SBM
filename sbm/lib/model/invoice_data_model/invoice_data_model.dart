class InvoiceDataModelMassege {
  bool? success;
  List<InvoiceDataModelResponse>? data;

  InvoiceDataModelMassege({this.success, this.data});

  InvoiceDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <InvoiceDataModelResponse>[];
      json['data'].forEach((v) {
        data!.add(new InvoiceDataModelResponse.fromJson(v));
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

class InvoiceDataModelResponse {
  String? type;
  String? docDate;
  var docNum;
  String? bpCode;
  String? bpName;
  var discountAmount;
  var amount;
  var vATAmount;
  var totalAmount;
  String? salesPerson;
  var invoiceLink;
  String? docStatus;

  InvoiceDataModelResponse(
      {this.type,
      this.docDate,
      this.docNum,
      this.bpCode,
      this.bpName,
      this.discountAmount,
      this.amount,
      this.vATAmount,
      this.totalAmount,
      this.salesPerson,
      this.invoiceLink,
      this.docStatus});

  InvoiceDataModelResponse.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    docDate = json['DocDate'];
    docNum = json['DocNum'];
    bpCode = json['BpCode'];
    bpName = json['BpName'];
    discountAmount = json['Discount Amount'];
    amount = json['Amount'];
    vATAmount = json['VAT amount'];
    totalAmount = json['Total Amount'];
    salesPerson = json['Sales Person'];
    invoiceLink = json['Invoice Link'];
    docStatus = json['DocStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['DocDate'] = this.docDate;
    data['DocNum'] = this.docNum;
    data['BpCode'] = this.bpCode;
    data['BpName'] = this.bpName;
    data['Discount Amount'] = this.discountAmount;
    data['Amount'] = this.amount;
    data['VAT amount'] = this.vATAmount;
    data['Total Amount'] = this.totalAmount;
    data['Sales Person'] = this.salesPerson;
    data['Invoice Link'] = this.invoiceLink;
    data['DocStatus'] = this.docStatus;
    return data;
  }
}

// class InvoiceDataModelMassege {
//   bool? success;
//   List<Data>? data;
//
//   InvoiceDataModelMassege({this.success, this.data});
//
//   InvoiceDataModelMassege.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   var type;
//   var docDate;
//   var docNum;
//   var bpCode;
//   var bpName;
//   var discountAmount;
//   var amount;
//   var vATAmount;
//   var totalAmount;
//   var salesPerson;
//   var invoiceLink;
//   var docStatus;
//
//   Data(
//       {this.type,
//         this.docDate,
//         this.docNum,
//         this.bpCode,
//         this.bpName,
//         this.discountAmount,
//         this.amount,
//         this.vATAmount,
//         this.totalAmount,
//         this.salesPerson,
//         this.invoiceLink,
//         this.docStatus});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     type = json['Type'];
//     docDate = json['DocDate'];
//     docNum = json['DocNum'];
//     bpCode = json['BpCode'];
//     bpName = json['BpName'];
//     discountAmount = json['Discount Amount'];
//     amount = json['Amount'];
//     vATAmount = json['VAT amount'];
//     totalAmount = json['Total Amount'];
//     salesPerson = json['Sales Person'];
//     invoiceLink = json['Invoice Link'];
//     docStatus = json['DocStatus'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Type'] = this.type;
//     data['DocDate'] = this.docDate;
//     data['DocNum'] = this.docNum;
//     data['BpCode'] = this.bpCode;
//     data['BpName'] = this.bpName;
//     data['Discount Amount'] = this.discountAmount;
//     data['Amount'] = this.amount;
//     data['VAT amount'] = this.vATAmount;
//     data['Total Amount'] = this.totalAmount;
//     data['Sales Person'] = this.salesPerson;
//     data['Invoice Link'] = this.invoiceLink;
//     data['DocStatus'] = this.docStatus;
//     return data;
//   }
// }
