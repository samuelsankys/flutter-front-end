import 'dart:convert';

import 'package:flutter_front_end/data/http/http_client.dart';
import 'package:flutter_front_end/data/models/characters_response_model.dart';
import 'package:flutter_front_end/helpers/helper_marvel_api.dart';

abstract class ICharacterRepository {
  Future<CharactersResponse> getCharacters(String query);
}

class CharacterRepository implements ICharacterRepository {
  final IHttpClient client;

  CharacterRepository({required this.client});

  @override
  Future<CharactersResponse> getCharacters(String query) async {
    final url = HelperMarvelApi.mountUrl('characters', query: query);
    final response = await client.get(url: url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response?.body);
      final result = CharactersResponse.fromJson(body['data']);

      return result;
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
