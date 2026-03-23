class Sinif {
  final int id;
  final String ad;
  final int seviye;

  Sinif({
    required this.id,
    required this.ad,
    required this.seviye,
  });

  factory Sinif.fromJson(Map<String, dynamic> json) {
    return Sinif(
      id: json['id'],
      ad: json['ad'],
      seviye: json['seviye'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'seviye': seviye,
    };
  }
}