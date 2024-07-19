import 'package:flutter/material.dart';
import 'package:nusantara/color.dart';
import 'package:nusantara/services/apis/pesanan.dart';
import 'package:nusantara/services/providers/cart_provider.dart';
import 'package:nusantara/vews/layout_menu.dart';
import 'package:nusantara/vews/makanan/makanan_item.dart';
import 'package:nusantara/vews/snackbar_utils.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String deliveryMethod = 'Dine-In';
  bool isLoading = false;

  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  handlePesanan(List<Map<String, dynamic>> pesananItem, int total,
      String pengambilan, String alamat, String catatan) async {
    setState(() {
      isLoading = true;
    });

    final result = await PesananService().pesanMenu(
        pesananItem: pesananItem,
        total: total,
        pengambilan: pengambilan,
        alamat: alamat,
        catatan: catatan);

    if (result) {
      Provider.of<CartItemProvider>(context, listen: false).clearItems();
      SnackbarUtils.showSuccessSnackbar(context, "Berhasil memesan menu!");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LayoutMenu(
            toPage: 3,
          ),
        ),
      );
    } else {
      SnackbarUtils.showErrorSnackbar(context, "Gagal memesan menu!");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showAddressNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Isi Alamat dan Catatan Tambahan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  minLines: 1,
                  maxLines: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _catatanController,
                  decoration: InputDecoration(labelText: 'Catatan Tambahan'),
                  minLines: 1,
                  maxLines: 5,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  final alamat = _alamatController.text.isEmpty
                      ? ''
                      : _alamatController.text;
                  final catatan = _catatanController.text.isEmpty
                      ? ''
                      : _catatanController.text;

                  final cartProvider =
                      Provider.of<CartItemProvider>(context, listen: false);
                  final orderItemsJson = cartProvider.orderItems
                      .map((item) => item.toJson())
                      .toList();

                  Navigator.of(context).pop();

                  handlePesanan(
                    orderItemsJson,
                    cartProvider.totalPrice(),
                    deliveryMethod,
                    alamat,
                    catatan,
                  );
                },
                child: Text('Kirim'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartItemProvider>(context);

    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: bgCream,
        title: Text('Pemesanan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Metode Pengambilan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      deliveryMethod = 'Dine-In';
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Dine-In',
                        groupValue: deliveryMethod,
                        onChanged: (value) {
                          setState(() {
                            deliveryMethod = value!;
                          });
                        },
                      ),
                      Text('Dine-In'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      deliveryMethod = 'Take-Away';
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Take-Away',
                        groupValue: deliveryMethod,
                        onChanged: (value) {
                          setState(() {
                            deliveryMethod = value!;
                          });
                        },
                      ),
                      Text('Take-Away'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      deliveryMethod = 'Delivery';
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Delivery',
                        groupValue: deliveryMethod,
                        onChanged: (value) {
                          setState(() {
                            deliveryMethod = value!;
                          });
                        },
                      ),
                      Text('Delivery'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Keranjang Belanja:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.orderItems.length,
                itemBuilder: (context, index) {
                  final order = cartProvider.orderItems[index];
                  return MakananItem(
                    makanan: order.makanan,
                    isCart: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 160,
                maxHeight: 60,
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: opsColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                'Total : \nRp. ' +
                    cartProvider.totalPrice().toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          FloatingActionButton.extended(
            backgroundColor: primaryColor,
            onPressed: () async {
              if (cartProvider.orderItems.isEmpty) {
                SnackbarUtils.showErrorSnackbar(
                    context, "Silahkan memilih makanan kesukaan anda !");
              } else {
                _showAddressNoteDialog();
              }
            },
            label: isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    'Pesan Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
