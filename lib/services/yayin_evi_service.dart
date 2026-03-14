import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../models/yayin_evi.dart';

class YayinEviService {

  Future<List<YayinEvi>> getYayinEvleri() async {

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/YayinEvi"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => YayinEvi.fromJson(e)).toList();

    } else {

      throw Exception("Yayın evleri alınamadı");

    }

  }

  Future<void> addYayinEvi(String ad, String adres) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/YayinEvi"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "ad": ad,
        "adres": adres,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Yayın evi eklenemedi");
    }
  }

  Future<void> updateYayinEvi(int id, String ad, String adres) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/YayinEvi/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "ad": ad,
        "adres": adres,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Yayın evi güncellenemedi");
    }
  }

  Future<void> deleteYayinEvi(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/YayinEvi/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Yayın evi silinemedi");
    }
  }

}