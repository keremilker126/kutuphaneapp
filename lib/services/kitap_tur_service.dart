import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../models/kitap_tur.dart';

class KitapTurService {

  Future<List<KitapTur>> getTurler() async {

    final response = await http.get(Uri.parse("${ApiConstants.baseUrl}/KitapTur"));

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => KitapTur.fromJson(e)).toList();
    } else {
      throw Exception("Veri alınamadı");
    }
  }

  Future<void> turEkle(String ad) async {

    await http.post(
      Uri.parse("${ApiConstants.baseUrl}/KitapTur"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"ad": ad}),
    );
  }

  Future<void> turGuncelle(int id, String ad) async {

    await http.put(
      Uri.parse("${ApiConstants.baseUrl}/KitapTur/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "ad": ad
      }),
    );
  }

  Future<void> turSil(int id) async {

    await http.delete(Uri.parse("${ApiConstants.baseUrl}/KitapTur/$id"));
  }
}