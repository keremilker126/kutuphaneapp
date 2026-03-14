class Ceza {

  int id;
  int oduncId;
  double tutar;
  String aciklama;
  bool odendiMi;

  Ceza({
    required this.id,
    required this.oduncId,
    required this.tutar,
    required this.aciklama,
    required this.odendiMi,
  });

  factory Ceza.fromJson(Map<String, dynamic> json) {

    return Ceza(
      id: json["id"],
      oduncId: json["oduncId"],
      tutar: json["tutar"],
      aciklama: json["aciklama"],
      odendiMi: json["odendiMi"],
    );
  }

}