class Product {
  int? productId;
  String? productName;
  String? productCategory;
  String? productImgUrl;
  String? productFeatures;
  int? productPrice;
  int? productStar;

  Product(
      {this.productId,
      this.productName,
      this.productCategory,
      this.productImgUrl,
      this.productFeatures,
      this.productPrice,
      this.productStar});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productCategory = json['productCategory'];
    productImgUrl = json['productImgUrl'];
    productFeatures = json['productFeatures'];
    productPrice = json['productPrice'];
    productStar = json['productStar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productCategory'] = this.productCategory;
    data['productImgUrl'] = this.productImgUrl;
    data['productFeatures'] = this.productFeatures;
    data['productPrice'] = this.productPrice;
    data['productStar'] = this.productStar;
    return data;
  }
}
