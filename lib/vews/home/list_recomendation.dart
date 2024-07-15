import 'package:flutter/material.dart';
import 'package:nusantara/models/makanan.dart';
import 'package:nusantara/vews/makanan/makanan_item.dart';

class ListRecomendation extends StatelessWidget {
  final List<Makanan>? makanans;

  ListRecomendation({required this.makanans});

  @override
  Widget build(BuildContext context) {
    if (makanans == null || makanans!.isEmpty) {
      return Center(
        child: Text('Tidak ada rekomendasi makanan.'),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        itemCount: makanans!.length,
        itemBuilder: (context, index) {
          return MakananItem(makanan: makanans![index]);
        },
      ),
    );
  }
}
