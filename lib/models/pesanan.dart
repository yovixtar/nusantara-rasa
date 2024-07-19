import 'package:nusantara/models/makanan.dart';

class PesananItem {
  final Makanan makanan;
  String jumlah;

  PesananItem({
    required this.makanan,
    required this.jumlah,
  });

  factory PesananItem.fromJson(Map<String, dynamic> json) {
    return PesananItem(
      makanan: Makanan.fromJson(json['menu']),
      jumlah: json['jumlah'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': makanan.toJson(),
      'jumlah': jumlah,
    };
  }
}

class Pesanan {
  final int? id;
  final String pengguna;
  final List<PesananItem> pesananItems;
  final String total;
  final String pengambilan;
  final String alamat;
  final String catatan;

  Pesanan({
    this.id,
    required this.pengguna,
    required this.pesananItems,
    required this.total,
    required this.pengambilan,
    required this.alamat,
    required this.catatan,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      id: json['id'],
      pengguna: json['pengguna'],
      pesananItems: (json['menus'] as List)
          .map((item) => PesananItem.fromJson(item))
          .toList(),
      total: json['total'],
      pengambilan: json['pengambilan'],
      alamat: json['alamat'],
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pengguna': pengguna,
      'menus': pesananItems.map((item) => item.toJson()).toList(),
      'total': total,
      'pengambilan': pengambilan,
      'alamat': alamat,
      'catatan': catatan,
    };
  }
}
