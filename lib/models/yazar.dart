class Yazar {

  int id;
  String ad;
  String soyad;
  String biyografi;

  Yazar({
    required this.id,
    required this.ad,
    required this.soyad,
    required this.biyografi,
  });

  factory Yazar.fromJson(Map<String, dynamic> json) {

    return Yazar(
      id: json["id"],
      ad: json["ad"],
      soyad: json["soyad"],
      biyografi: json["biyografi"],
    );
  }

}