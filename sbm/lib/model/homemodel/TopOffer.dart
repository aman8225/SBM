class TopOffer {
  String? offerTop1;
  String? offerTop1Url;
  String? offerTop2;
  String? offerTop2Url;
  String? offerTop3;
  String? offerTop3Url;

  TopOffer(
      {this.offerTop1,
      this.offerTop1Url,
      this.offerTop2,
      this.offerTop2Url,
      this.offerTop3,
      this.offerTop3Url});

  TopOffer.fromJson(Map<String, dynamic> json) {
    offerTop1 = json['offer_top_1'];
    offerTop1Url = json['offer_top_1_url'];
    offerTop2 = json['offer_top_2'];
    offerTop2Url = json['offer_top_2_url'];
    offerTop3 = json['offer_top_3'];
    offerTop3Url = json['offer_top_3_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_top_1'] = this.offerTop1;
    data['offer_top_1_url'] = this.offerTop1Url;
    data['offer_top_2'] = this.offerTop2;
    data['offer_top_2_url'] = this.offerTop2Url;
    data['offer_top_3'] = this.offerTop3;
    data['offer_top_3_url'] = this.offerTop3Url;
    return data;
  }
}
