class pdflinckgenretarmodal {
  bool? success;
  String? url;
  String? message;

  pdflinckgenretarmodal({this.success, this.url, this.message});

  pdflinckgenretarmodal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    url = json['url'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['url'] = this.url;
    data['message'] = this.message;
    return data;
  }
}