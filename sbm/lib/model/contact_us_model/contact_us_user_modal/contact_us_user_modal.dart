class ContactUsUserModalMassege {
  bool? success;
  ContactUsUserModalResponse? data;
  String? message;

  ContactUsUserModalMassege({this.success, this.data, this.message});

  ContactUsUserModalMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new ContactUsUserModalResponse.fromJson(json['data'])
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

class ContactUsUserModalResponse {
  String? favicon;
  String? logo;
  String? websiteName;
  String? phoneNumber;
  String? email;
  String? companyAddress;
  String? facebookLink;
  String? linkedinLink;
  String? whatsAppLink;
  String? twitterLink;
  String? youtubeLink;
  String? headerTagline;
  String? footerCopyrightText;
  String? footerImage;
  String? vat;
  String? postPerPage;
  String? currency;
  String? shippingCost;
  String? registrationEmail;
  String? bulkorderEmail;
  String? frontendUrl;
  String? smallIconImg;
  String? mediumIconImg;
  String? largeIconImg;
  String? placeorderEmail;
  List<FooterCats>? footerCats;

  ContactUsUserModalResponse(
      {this.favicon,
      this.logo,
      this.websiteName,
      this.phoneNumber,
      this.email,
      this.companyAddress,
      this.facebookLink,
      this.linkedinLink,
      this.whatsAppLink,
      this.twitterLink,
      this.youtubeLink,
      this.headerTagline,
      this.footerCopyrightText,
      this.footerImage,
      this.vat,
      this.postPerPage,
      this.currency,
      this.shippingCost,
      this.registrationEmail,
      this.bulkorderEmail,
      this.frontendUrl,
      this.smallIconImg,
      this.mediumIconImg,
      this.largeIconImg,
      this.placeorderEmail,
      this.footerCats});

  ContactUsUserModalResponse.fromJson(Map<String, dynamic> json) {
    favicon = json['favicon'];
    logo = json['logo'];
    websiteName = json['website_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    companyAddress = json['company_address'];
    facebookLink = json['facebook_link'];
    linkedinLink = json['linkedin_link'];
    whatsAppLink = json['whatsApp_link'];
    twitterLink = json['twitter_link'];
    youtubeLink = json['youtube_link'];
    headerTagline = json['header_tagline'];
    footerCopyrightText = json['footer_copyright_text'];
    footerImage = json['footer_image'];
    vat = json['vat'];
    postPerPage = json['post_per_page'];
    currency = json['currency'];
    shippingCost = json['shipping_cost'];
    registrationEmail = json['registration_email'];
    bulkorderEmail = json['bulkorder_email'];
    frontendUrl = json['frontend_url'];
    smallIconImg = json['small_icon_img'];
    mediumIconImg = json['medium_icon_img'];
    largeIconImg = json['large_icon_img'];
    placeorderEmail = json['placeorder_email'];
    if (json['footer_cats'] != null) {
      footerCats = <FooterCats>[];
      json['footer_cats'].forEach((v) {
        footerCats!.add(new FooterCats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favicon'] = this.favicon;
    data['logo'] = this.logo;
    data['website_name'] = this.websiteName;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['company_address'] = this.companyAddress;
    data['facebook_link'] = this.facebookLink;
    data['linkedin_link'] = this.linkedinLink;
    data['whatsApp_link'] = this.whatsAppLink;
    data['twitter_link'] = this.twitterLink;
    data['youtube_link'] = this.youtubeLink;
    data['header_tagline'] = this.headerTagline;
    data['footer_copyright_text'] = this.footerCopyrightText;
    data['footer_image'] = this.footerImage;
    data['vat'] = this.vat;
    data['post_per_page'] = this.postPerPage;
    data['currency'] = this.currency;
    data['shipping_cost'] = this.shippingCost;
    data['registration_email'] = this.registrationEmail;
    data['bulkorder_email'] = this.bulkorderEmail;
    data['frontend_url'] = this.frontendUrl;
    data['small_icon_img'] = this.smallIconImg;
    data['medium_icon_img'] = this.mediumIconImg;
    data['large_icon_img'] = this.largeIconImg;
    data['placeorder_email'] = this.placeorderEmail;
    if (this.footerCats != null) {
      data['footer_cats'] = this.footerCats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FooterCats {
  int? id;
  String? categoryName;
  String? slug;
  List<ChildCats>? childCats;

  FooterCats({this.id, this.categoryName, this.slug, this.childCats});

  FooterCats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
    if (json['childCats'] != null) {
      childCats = <ChildCats>[];
      json['childCats'].forEach((v) {
        childCats!.add(new ChildCats.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    if (this.childCats != null) {
      data['childCats'] = this.childCats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildCats {
  int? id;
  String? categoryName;
  String? slug;

  ChildCats({this.id, this.categoryName, this.slug});

  ChildCats.fromJson(Map<String, dynamic> json) {
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
