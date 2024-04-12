import 'package:flutter_front_end/data/models/events_model.dart';
import 'package:flutter_front_end/data/models/series_model.dart';
import 'package:flutter_front_end/data/models/thumbnail_model.dart';

class Character {
  int id;
  String name;
  String description;
  String modified;
  Thumbnail? thumbnail;
  String resourceURI;
  Series? series;
  Events? events;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.modified,
    required this.thumbnail,
    required this.resourceURI,
    required this.series,
    required this.events,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      modified: json['modified'],
      thumbnail: json['thumbnail'] != null
          ? Thumbnail.fromJson(json['thumbnail'])
          : null,
      resourceURI: json['resourceURI'],
      series: json['series'] != null ? Series.fromJson(json['series']) : null,
      events: json['events'] != null ? Events.fromJson(json['events']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['modified'] = modified;
    if (thumbnail != null) {
      data['thumbnail'] = thumbnail!.toJson();
    }
    data['resourceURI'] = resourceURI;
    if (series != null) {
      data['series'] = series!.toJson();
    }
    if (events != null) {
      data['events'] = events!.toJson();
    }
    return data;
  }
}
