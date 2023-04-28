class GetOutstandingInvoiceModelMassege {
  bool? success;
  GetOutstandingInvoiceModelResponse? data;
  String? message;

  GetOutstandingInvoiceModelMassege({this.success, this.data, this.message});

  GetOutstandingInvoiceModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new GetOutstandingInvoiceModelResponse.fromJson(json['data'])
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

class GetOutstandingInvoiceModelResponse {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  GetOutstandingInvoiceModelResponse(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  GetOutstandingInvoiceModelResponse.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? docDate;
  String? docNum;
  String? bpCode;
  String? bpName;
  String? discountAmount;
  String? amount;
  String? vatAmount;
  String? totalAmount;
  String? salesPerson;
  String? invoiceLink;
  String? docStatus;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.type,
      this.docDate,
      this.docNum,
      this.bpCode,
      this.bpName,
      this.discountAmount,
      this.amount,
      this.vatAmount,
      this.totalAmount,
      this.salesPerson,
      this.invoiceLink,
      this.docStatus,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    docDate = json['doc_date'];
    docNum = json['doc_num'];
    bpCode = json['bp_code'];
    bpName = json['bp_name'];
    discountAmount = json['discount_amount'];
    amount = json['amount'];
    vatAmount = json['vat_amount'];
    totalAmount = json['total_amount'];
    salesPerson = json['sales_person'];
    invoiceLink = json['invoice_link'];
    docStatus = json['doc_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['doc_date'] = this.docDate;
    data['doc_num'] = this.docNum;
    data['bp_code'] = this.bpCode;
    data['bp_name'] = this.bpName;
    data['discount_amount'] = this.discountAmount;
    data['amount'] = this.amount;
    data['vat_amount'] = this.vatAmount;
    data['total_amount'] = this.totalAmount;
    data['sales_person'] = this.salesPerson;
    data['invoice_link'] = this.invoiceLink;
    data['doc_status'] = this.docStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
