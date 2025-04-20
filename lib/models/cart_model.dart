class CartModel {
  bool? success;
  String? message;
  CartItem? data;

  CartModel({this.success, this.message, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? CartItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CartItem {
  List<Items>? items;
  int? totalPrice;
  dynamic discount;
  dynamic totalAfterDiscount;

  CartItem({this.items, this.totalPrice});

  CartItem.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    totalPrice = json['total_before_coupon'];
    discount = json['discount'];
    totalAfterDiscount = json['total_after_coupon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['total_before_coupon'] = totalPrice;
    data['discount'] = discount;
    data['total_after_coupon'] = totalAfterDiscount;
    return data;
  }
}

class Items {
  int? id;
  Product? product;
  Variant? variant;
  Property? property;
  int? quantity;
  String? hideAt;

  Items(
      {this.id,
      this.product,
      this.variant,
      this.property,
      this.quantity,
      this.hideAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    variant =
        json['variant'] != null ? Variant.fromJson(json['variant']) : null;
    property =
        json['property'] != null ? Property.fromJson(json['property']) : null;
    quantity = json['quantity'];
    hideAt = json['hide_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (variant != null) {
      data['variant'] = variant!.toJson();
    }
    if (property != null) {
      data['property'] = property!.toJson();
    }
    data['quantity'] = quantity;
    data['hide_at'] = hideAt;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? package;
  String? brand;
  String? image;

  Product({this.id, this.name, this.package, this.brand, this.image});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    package = json['package'];
    brand = json['brand'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['package'] = package;
    data['brand'] = brand;
    data['image'] = image;
    return data;
  }
}

class Variant {
  int? id;
  String? price;
  int? minQuantity;
  int? maxQuantity;

  Variant({this.id, this.price, this.minQuantity, this.maxQuantity});

  Variant.fromJson(Map<String, dynamic> json) {
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

class Property {
  int? id;
  String? name;
  String? logo;
  String? cart_min;

  Property({this.id, this.name, this.logo});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    cart_min = json['cart_min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['cart_min'] = cart_min;
    return data;
  }
}
