import 'package:flutter_front_end/data/models/characters_model.dart';

class CharactersResponse {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Character> results;

  CharactersResponse({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory CharactersResponse.fromJson(Map<String, dynamic> json) {
    return CharactersResponse(
      offset: json['offset'],
      limit: json['limit'],
      total: json['total'],
      count: json['count'],
      results: (json['results'] as List<dynamic>)
          .map((characterJson) => Character.fromJson(characterJson))
          .toList(),
    );
  }
}
