class Kitap {

  int id;
  String ad;
  String isbn;
  int sayfaSayisi;

  int yazarId;
  int yayinEviId;
  int turId;

  Kitap({
    required this.id,
    required this.ad,
    required this.isbn,
    required this.sayfaSayisi,
    required this.yazarId,
    required this.yayinEviId,
    required this.turId,
  });

  factory Kitap.fromJson(Map<String, dynamic> json) {

    return Kitap(
      id: json["id"],
      ad: json["ad"],
      isbn: json["isbn"],
      sayfaSayisi: json["sayfaSayisi"],
      yazarId: json["yazarId"],
      yayinEviId: json["yayinEviId"],
      turId: json["turId"],
    );
  }

}