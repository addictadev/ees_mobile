class StaticModel {
  bool? success;
  String? message;
  List<Data>? data;

  StaticModel({this.success, this.message, this.data});

  StaticModel.fromJson(Map<String, dynamic> json) {
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
  String? privacy;
  String? terms;

  Data({this.id, this.privacy, this.terms});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    privacy = json['privacy'];
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['privacy'] = privacy;
    data['terms'] = terms;
    return data;
  }
}
