import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../models/sinif.dart';

class SinifService {

  Future<List<Sinif>> getSiniflar() async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Sinif"),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Sinif.fromJson(e)).toList();
    } else {
      throw Exception("Sınıflar alınamadı: ${response.body}");
    }
  }

  // ---------------- POST ----------------
  Future<void> addSinif(String ad, int seviye) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/Sinif"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "ad": ad,
        "seviye": seviye,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Sınıf eklenemedi: ${response.body}");
    }
  }

  // ---------------- PUT ----------------
  Future<void> updateSinif(int id, String ad, int seviye) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/Sinif/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "ad": ad,
        "seviye": seviye,
      }),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception("Sınıf güncellenemedi: ${response.body}");
    }
  }

  // ---------------- DELETE ----------------
  Future<void> deleteSinif(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/Sinif/$id"),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception("Sınıf silinemedi: ${response.body}");
    }
  }
}