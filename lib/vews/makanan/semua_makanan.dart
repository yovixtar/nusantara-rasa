import 'package:flutter/material.dart';
import 'package:nusantara/color.dart';
import 'package:nusantara/models/makanan.dart';
import 'package:nusantara/services/apis/menu.dart';
import 'package:nusantara/vews/makanan/makanan_item.dart';

class SemuaMakananPage extends StatefulWidget {
  final String? cari;

  SemuaMakananPage({this.cari});

  @override
  _SemuaMakananPageState createState() => _SemuaMakananPageState();
}

class _SemuaMakananPageState extends State<SemuaMakananPage> {
  late Future<List<Makanan>> futureMakanan;

  Future<List<Makanan>> fetchMakanan({String? query}) async {
    try {
      List<Makanan> result = await MenuService().fetchMenu();
      if (query != null && query.isNotEmpty) {
        result = result
            .where((m) => m.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    futureMakanan = fetchMakanan(query: widget.cari);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        title: Text('Daftar Makanan'),
        automaticallyImplyLeading:
            (widget.cari != null && widget.cari!.isNotEmpty) ? true : false,
        centerTitle: true,
        backgroundColor: bgCream,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: FutureBuilder<List<Makanan>>(
          future: futureMakanan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada data makanan.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MakananItem(makanan: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
