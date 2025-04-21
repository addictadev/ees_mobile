class OrdersModel {
  bool? status;
  String? message;
  List<OrderItemDetails>? orderList;

  OrdersModel({this.status, this.message, this.orderList});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      orderList = <OrderItemDetails>[];
      json['data'].forEach((v) {
        orderList!.add(OrderItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (orderList != null) {
      data['data'] = orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItemDetails {
  int? id;
  String? status;
  String? note;
  dynamic discount;
  dynamic coupon_code;
  dynamic totalBeforDiscount;
  String? orderedAt;
  String? totalPrice;
  Property? property;
  List<Items>? items;

  OrderItemDetails(
      {this.id,
      this.status,
      this.note,
      this.discount,
      this.coupon_code,
      this.totalBeforDiscount,
      this.orderedAt,
      this.totalPrice,
      this.property,
      this.items});

  OrderItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    note = json['note'];
    coupon_code = json['coupon_code'];
    discount = json['discount'];
    totalBeforDiscount = json['total_before_discount'];
    orderedAt = json['ordered_at'];
    totalPrice = json['total_price'];
    property =
        json['property'] != null ? Property.fromJson(json['property']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['note'] = note;
    data['coupon_code'] = coupon_code;
    data['discount'] = discount;
    data['total_before_discount'] = totalBeforDiscount;
    data['ordered_at'] = orderedAt;
    data['total_price'] = totalPrice;
    if (property != null) {
      data['property'] = property!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Property {
  int? id;
  String? name;
  String? address;
  String? logo;

  Property({this.id, this.name, this.address, this.logo});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['logo'] = logo;
    return data;
  }
}

class Items {
  String? productName;
  int? variantId;
  int? id;
  int? quantity;
  dynamic package;
  dynamic seller_note;
  dynamic seller_quantity;
  String? price;
  String? image;
  String? status;

  Items(
      {this.productName,
      this.variantId,
      this.id,
      this.package,
      this.seller_note,
      this.quantity,
      this.price,
      this.image,
      this.status});

  Items.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    variantId = json['variant_id'];

    id = json['id'];
    quantity = json['quantity'];
    package = json['package'];
    seller_note = json['seller_note'];
    seller_quantity = json['seller_quantity'];
    price = json['price'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['variant_id'] = variantId;

    data['id'] = id;
    data['quantity'] = quantity;
    data['package'] = package;
    data['seller_note'] = seller_note;
    data['seller_quantity'] = seller_quantity;
    data['price'] = price;
    data['image'] = image;
    data['status'] = status;
    return data;
  }
}
