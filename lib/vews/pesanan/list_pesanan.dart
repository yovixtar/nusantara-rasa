import 'package:flutter/material.dart';
import 'package:nusantara/color.dart';
import 'package:nusantara/models/pesanan.dart';
import 'package:nusantara/services/apis/pesanan.dart';
import 'package:nusantara/vews/pesanan/detail_pesanan.dart';

class PesananPage extends StatefulWidget {
  @override
  _PesananPagePageState createState() => _PesananPagePageState();
}

class _PesananPagePageState extends State<PesananPage> {
  late Future<List<Pesanan>> futurePesanan;

  Future<List<Pesanan>> fetchPesanan() async {
    try {
      List<Pesanan> result = await PesananService().fetchPesanan();
      return result;
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    futurePesanan = fetchPesanan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: bgCream,
        title: Text('Pesanan'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pesanan>>(
        future: futurePesanan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data pesanan.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pesanan = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailPesananPage(pesanan: pesanan),
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pesanan ${pesanan.id}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Total: Rp ' +
                                    pesanan.total.replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]}.'),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
