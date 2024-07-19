class Promo {
  final int id;
  final String gambar;
  final String judul;
  final String deskripsi;

  Promo({
    required this.id,
    required this.gambar,
    required this.judul,
    required this.deskripsi,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id'],
      gambar: json['gambar'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gambar': gambar,
      'judul': judul,
      'deskripsi': deskripsi,
    };
  }
}
