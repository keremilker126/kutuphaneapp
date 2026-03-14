import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api.dart';
import '../models/odunc.dart';

class OduncService {

  // Ödünçleri getir
  Future<List<Odunc>> getOduncler() async {

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Odunc"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => Odunc.fromJson(e)).toList();

    } else {
      throw Exception("Ödünçler alınamadı");
    }
  }

  // Kitap ver
  Future<void> kitapVer(int uyeId, int kitapId, String tarih) async {

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/OduncApi"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "uyeId": uyeId,
        "kitapId": kitapId,
        "getirmesiIstenenTarih": tarih
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Kitap verilemedi");
    }
  }

  // Kitabı teslim al
  Future<void> kitapTeslimAl(int oduncId) async {

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/OduncApi/$oduncId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "teslimTarihi": DateTime.now().toIso8601String(),
        "durum": true
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Teslim işlemi başarısız");
    }
  }

  // Ödünç sil
  Future<void> deleteOdunc(int id) async {

    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/OduncApi/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Ödünç silinemedi");
    }
  }

}