class KitapTur {
  final int id;
  final String ad;

  KitapTur({
    required this.id,
    required this.ad,
  });

  factory KitapTur.fromJson(Map<String, dynamic> json) {
    return KitapTur(
      id: json["id"],
      ad: json["ad"],
    );
  }
}