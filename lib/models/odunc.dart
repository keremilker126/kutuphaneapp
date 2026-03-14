class Odunc {

  int id;
  int uyeId;
  int kitapId;

  String verilisTarihi;
  String getirmesiIstenenTarih;
  String? teslimTarihi;

  bool durum;

  Odunc({
    required this.id,
    required this.uyeId,
    required this.kitapId,
    required this.verilisTarihi,
    required this.getirmesiIstenenTarih,
    this.teslimTarihi,
    required this.durum,
  });

  factory Odunc.fromJson(Map<String, dynamic> json) {

    return Odunc(
      id: json["id"],
      uyeId: json["uyeId"],
      kitapId: json["kitapId"],
      verilisTarihi: json["verilisTarihi"],
      getirmesiIstenenTarih: json["getirmesiIstenenTarih"],
      teslimTarihi: json["teslimTarihi"],
      durum: json["durum"],
    );
  }

}