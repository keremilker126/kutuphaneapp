class YayinEvi {

  int id;
  String ad;
  String adres;

  YayinEvi({
    required this.id,
    required this.ad,
    required this.adres,
  });

  factory YayinEvi.fromJson(Map<String, dynamic> json) {

    return YayinEvi(
      id: json["id"],
      ad: json["ad"],
      adres: json["adres"],
    );
  }

}