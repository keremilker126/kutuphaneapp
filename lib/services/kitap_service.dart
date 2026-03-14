import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import '../models/kitap.dart';

class KitapService {

  Future<List<Kitap>> getKitaplar() async {

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/Kitap"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => Kitap.fromJson(e)).toList();

    } else {

      throw Exception("Kitaplar alınamadı");

    }

  }

  Future<void> addKitap(
    String ad,
    String isbn,
    int sayfaSayisi,
    int yazarId,
    int yayinEviId,
    int turId,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/Kitap"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "ad": ad,
        "isbn": isbn,
        "sayfaSayisi": sayfaSayisi,
        "yazarId": yazarId,
        "yayinEviId": yayinEviId,
        "turId": turId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Kitap eklenemedi");
    }
  }

  Future<void> updateKitap(
    int id,
    String ad,
    String isbn,
    int sayfaSayisi,
    int yazarId,
    int yayinEviId,
    int turId,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/Kitap/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "ad": ad,
        "isbn": isbn,
        "sayfaSayisi": sayfaSayisi,
        "yazarId": yazarId,
        "yayinEviId": yayinEviId,
        "turId": turId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Kitap güncellenemedi");
    }
  }

  Future<void> deleteKitap(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/Kitap/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Kitap silinemedi");
    }
  }

}