import 'products_home_data_model.dart';

class HomeSliderModel {
  bool? success;
  String? message;
  List<Data>? data;

  HomeSliderModel({this.success, this.message, this.data});

  HomeSliderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? type;
  String? link;
  String? image;
  ProductData? product;

  Data({this.id, this.name, this.type, this.link, this.image, this.product});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    link = json['link'];
    image = json['image'];
    product =
        json['product'] != null ? ProductData.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['link'] = link;
    data['image'] = image;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}


class Images {
  int? id;
  String? url;

  Images({this.id, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class Variants {
  int? id;
  String? price;
  int? minQuantity;
  int? maxQuantity;

  Variants({this.id, this.price, this.minQuantity, this.maxQuantity});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    minQuantity = json['min_quantity'];
    maxQuantity = json['max_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['min_quantity'] = minQuantity;
    data['max_quantity'] = maxQuantity;
    return data;
  }
}
