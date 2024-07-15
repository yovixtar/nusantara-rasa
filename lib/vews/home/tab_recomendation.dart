import 'package:flutter/material.dart';
import 'package:nusantara/models/makanan.dart';
import 'package:nusantara/vews/home/list_recomendation.dart';

class TabRecomendation extends StatelessWidget {
  final List<Makanan> popularMakanan;
  final List<Makanan> seasonalMakanan;

  TabRecomendation(
      {required this.popularMakanan, required this.seasonalMakanan});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Popularitas'),
              Tab(text: 'Musim'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListRecomendation(makanans: popularMakanan),
                ListRecomendation(makanans: seasonalMakanan),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
