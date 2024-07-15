import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nusantara/color.dart';
import 'package:nusantara/models/makanan.dart';
import 'package:nusantara/services/apis/menu.dart';
import 'package:nusantara/vews/home/tab_recomendation.dart';
import 'package:nusantara/vews/makanan/semua_makanan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Makanan>> futureMakanan;

  Future<List<Makanan>> fetchMakanan() async {
    try {
      List<Makanan> result = await MenuService().fetchMenu();
      return result;
    } catch (e) {
      return [];
    }
  }

  final List<String> imgList = [
    'assets/images/banner2.png',
  ];

  @override
  void initState() {
    super.initState();
    futureMakanan = fetchMakanan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: bgCream,
        title: Text('Beranda'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildCarouselSlider(),
            _buildRecomendationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    TextEditingController searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Cari menu...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onSubmitted: (String value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SemuaMakananPage(cari: value),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: imgList
          .map((item) => Container(
                child: Center(
                    child: Image.asset(item, fit: BoxFit.cover, width: 1000)),
              ))
          .toList(),
    );
  }

  Widget _buildRecomendationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rekomendasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(
            height: 400,
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
                  List<Makanan> popularMakanan = snapshot.data!
                      .where((m) => m.kategori == 'Popularitas')
                      .toList();
                  List<Makanan> seasonalMakanan = snapshot.data!
                      .where((m) => m.kategori == 'Musim')
                      .toList();

                  return TabRecomendation(
                      popularMakanan: popularMakanan,
                      seasonalMakanan: seasonalMakanan);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
