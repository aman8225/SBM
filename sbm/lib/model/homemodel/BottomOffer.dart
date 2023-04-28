class BottomOffer {
  String? offerBottom1;
  String? offerBottom1Contents;
  String? offerBottom2;
  String? offerBottom2Contents;

  BottomOffer(
      {this.offerBottom1,
      this.offerBottom1Contents,
      this.offerBottom2,
      this.offerBottom2Contents});

  BottomOffer.fromJson(Map<String, dynamic> json) {
    offerBottom1 = json['offer_bottom_1'];
    offerBottom1Contents = json['offer_bottom_1_contents'];
    offerBottom2 = json['offer_bottom_2'];
    offerBottom2Contents = json['offer_bottom_2_contents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_bottom_1'] = this.offerBottom1;
    data['offer_bottom_1_contents'] = this.offerBottom1Contents;
    data['offer_bottom_2'] = this.offerBottom2;
    data['offer_bottom_2_contents'] = this.offerBottom2Contents;
    return data;
  }
}
