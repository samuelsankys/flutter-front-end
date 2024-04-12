import 'package:flutter_front_end/data/models/items_model.dart';

class Events {
  int available;
  String collectionURI;
  List<Items> items;
  int returned;

  Events({
    required this.available,
    required this.collectionURI,
    required this.items,
    required this.returned,
  });

  factory Events.fromJson(Map<String, dynamic> json) {
    List<Items>? itemsList;
    if (json['items'] != null) {
      itemsList = <Items>[];
      json['items'].forEach((v) {
        itemsList!.add(Items.fromJson(v));
      });
    }
    return Events(
      available: json['available'],
      collectionURI: json['collectionURI'],
      items: itemsList ?? [],
      returned: json['returned'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available'] = available;
    data['collectionURI'] = collectionURI;
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    data['returned'] = returned;
    return data;
  }
}
