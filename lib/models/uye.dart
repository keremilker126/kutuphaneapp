class Uye {

  int id;
  String ad;
  String soyad;
  String eposta;
  String telefon;

  Uye({
    required this.id,
    required this.ad,
    required this.soyad,
    required this.eposta,
    required this.telefon,
  });

  factory Uye.fromJson(Map<String, dynamic> json) {

    return Uye(
      id: json["id"],
      ad: json["ad"],
      soyad: json["soyad"],
      eposta: json["eposta"],
      telefon: json["telefon"],
    );
  }

}