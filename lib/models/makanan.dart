class Makanan {
  final int id;
  final String nama;
  final String deskripsi;
  final String daerah;
  final String harga;
  final String stok;
  final String gambar;
  final String kategori;

  Makanan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.daerah,
    required this.harga,
    required this.stok,
    required this.gambar,
    required this.kategori,
  });

  factory Makanan.fromJson(Map<String, dynamic> json) {
    return Makanan(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      daerah: json['daerah'],
      harga: json['harga'],
      stok: json['stok'],
      gambar: json['gambar'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'daerah': daerah,
      'harga': harga,
      'stok': stok,
      'gambar': gambar,
      'kategori': kategori,
    };
  }
}
