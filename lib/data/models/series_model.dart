import 'package:flutter_front_end/data/models/items_model.dart';

class Series {
  int available;
  String collectionURI;
  List<Items> items;

  Series(
      {required this.available,
      required this.collectionURI,
      required this.items});

  factory Series.fromJson(Map<String, dynamic> json) {
    var itemList = <Items>[];
    if (json['items'] != null) {
      json['items'].forEach((v) {
        itemList.add(Items.fromJson(v));
      });
    }
    return Series(
      available: json['available'],
      collectionURI: json['collectionURI'],
      items: itemList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['available'] = available;
    data['collectionURI'] = collectionURI;
    data['items'] = items.map((v) => v.toJson()).toList();
    return data;
  }
}
