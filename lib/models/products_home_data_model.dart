class ProductsHomeDataModel {
  bool? status;
  String? message;
  List<ProductData>? data;
  Pagination? pagination;

  ProductsHomeDataModel(
      {this.status, this.message, this.data, this.pagination});

  ProductsHomeDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ProductData {
  int? id;
  String? name;
  String? description;
  String? package;
  int? status;
  String? image;
  List<Categories>? categories;
  List<Categories>? properties;
  List<Variants>? variants;

  ProductData(
      {this.id,
      this.name,
      this.description,
      this.package,
      this.status,
      this.image,
      this.categories,
      this.properties,
      this.variants});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    package = json['package'];
    status = json['status'];
    image = json['image'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['properties'] != null) {
      properties = <Categories>[];
      json['properties'].forEach((v) {
        properties!.add(Categories.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['package'] = package;
    data['status'] = status;
    data['image'] = image;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (properties != null) {
      data['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  dynamic nextPageUrl;
  dynamic prevPageUrl;

  Pagination(
      {this.currentPage,
      this.perPage,
      this.total,
      this.lastPage,
      this.nextPageUrl,
      this.prevPageUrl});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['last_page'] = lastPage;
    data['next_page_url'] = nextPageUrl;
    data['prev_page_url'] = prevPageUrl;
    return data;
  }
}
