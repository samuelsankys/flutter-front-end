import 'dart:convert';
import 'package:crypto/crypto.dart';

class HelperMarvelApi {
  static const String publicApiKey = "6ab02858b1e045dba4341b45029cdc57";
  static const String privateApiKey =
      "ad3468a7456619d08be2403ab06e2c0e6aeea857";
  static const String baseUrl = "http://gateway.marvel.com/v1/public/";

  static String mountUrl(String andpoint, {String query = ""}) {
    final timestamps = DateTime.now().toIso8601String();
    String hash = _generateHash(timestamps);
    return "$baseUrl$andpoint?apikey=$publicApiKey&hash=$hash&ts=${timestamps}$query";
  }

  static String _generateHash(timestamp) {
    String input = timestamp + privateApiKey + publicApiKey;
    return _generateMd5(input);
  }

  static String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
