class Thumbnail {
  String path;
  String extension;

  Thumbnail({required this.path, required this.extension});

  Thumbnail.fromJson(Map<String, dynamic> json)
      : path = json['path'] ?? '',
        extension = json['extension'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['extension'] = extension;
    return data;
  }
}
