import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../models/yazar.dart';

class YazarService {

  Future<List<Yazar>> getYazarlar() async {

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Yazar"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => Yazar.fromJson(e)).toList();

    } else {

      throw Exception("Yazarlar alınamadı");

    }

  }

  Future<void> addYazar(
    String ad,
    String soyad,
    String biyografi,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/Yazar"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "ad": ad,
        "soyad": soyad,
        "biyografi": biyografi,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Yazar eklenemedi");
    }
  }

  Future<void> updateYazar(
    int id,
    String ad,
    String soyad,
    String biyografi,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/Yazar/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "ad": ad,
        "soyad": soyad,
        "biyografi": biyografi,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Yazar güncellenemedi");
    }
  }

  Future<void> deleteYazar(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/Yazar/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Yazar silinemedi");
    }
  }

}