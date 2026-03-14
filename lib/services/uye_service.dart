import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../models/uye.dart';

class UyeService {

  Future<List<Uye>> getUyeler() async {

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Uye"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => Uye.fromJson(e)).toList();

    } else {

      throw Exception("Uyeler alınamadı");

    }

  }

  Future<void> addUye(
    String ad,
    String soyad,
    String eposta,
    String telefon,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/Uye"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "ad": ad,
        "soyad": soyad,
        "eposta": eposta,
        "telefon": telefon,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Üye eklenemedi");
    }
  }

  Future<void> updateUye(
    int id,
    String ad,
    String soyad,
    String eposta,
    String telefon,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/Uye/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "ad": ad,
        "soyad": soyad,
        "eposta": eposta,
        "telefon": telefon,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Üye güncellenemedi");
    }
  }

  Future<void> deleteUye(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/Uye/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Üye silinemedi");
    }
  }

}