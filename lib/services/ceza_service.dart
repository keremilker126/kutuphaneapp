import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api.dart';
import '../models/ceza.dart';

class CezaService {

  // Cezaları getir
  Future<List<Ceza>> getCezalar() async {

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Ceza"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => Ceza.fromJson(e)).toList();

    } else {
      throw Exception("Cezalar alınamadı");
    }
  }

  // Ceza oluştur
  Future<void> createCeza(int oduncId, double tutar, String aciklama) async {

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/CezaApi"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "oduncId": oduncId,
        "tutar": tutar,
        "aciklama": aciklama
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Ceza oluşturulamadı");
    }
  }

  // Ceza ödendi
  Future<void> cezaOde(int cezaId) async {

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/CezaApi/$cezaId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "odendiMi": true
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Ceza ödenemedi");
    }
  }

  Future<void> updateCeza(int cezaId, double tutar, String aciklama) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/CezaApi/$cezaId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "tutar": tutar,
        "aciklama": aciklama,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Ceza güncellenemedi");
    }
  }

  // Ceza sil
  Future<void> deleteCeza(int id) async {

    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/CezaApi/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Ceza silinemedi");
    }
  }

}