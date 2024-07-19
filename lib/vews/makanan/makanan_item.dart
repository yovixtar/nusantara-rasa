import 'package:flutter/material.dart';
import 'package:nusantara/color.dart';
import 'package:nusantara/models/makanan.dart';
import 'package:nusantara/models/pesanan.dart';
import 'package:nusantara/services/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class MakananItem extends StatelessWidget {
  final Makanan makanan;
  final bool isCart;
  final bool isPesanan;
  final int jumlah;

  MakananItem({
    required this.makanan,
    this.isCart = false,
    this.isPesanan = false,
    this.jumlah = 0,
  });

  @override
  Widget build(BuildContext context) {
    final provider = CartItemProvider.of(context);

    return Card(
      elevation: 3,
      color: secondColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: isPesanan
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: CartItemProvider.of(context),
                      child: Consumer<CartItemProvider>(
                        builder: (context, cart, child) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(makanan.gambar),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    makanan.nama,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    'Rp. ' +
                                        makanan.harga.replaceAllMapped(
                                            RegExp(
                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                            (Match m) => '${m[1]}.'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    makanan.deskripsi,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    makanan.daerah,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    "Tambahkan Keranjang",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cart.decreaseQuantity(makanan.id);
                                        },
                                        icon: Icon(Icons.remove),
                                      ),
                                      Text(
                                        cart.totalItem(makanan.id),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          isCart
                                              ? cart
                                                  .increaseQuantity(makanan.id)
                                              : cart.addItem(PesananItem(
                                                  makanan: makanan,
                                                  jumlah: '1'));
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(makanan.gambar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      makanan.nama,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Rp. ' +
                          makanan.harga.replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]}.'),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    if (isCart || isPesanan) SizedBox(height: 6),
                    if (isCart || isPesanan)
                      Text(
                        "Jumlah ${isCart ? provider.totalItem(makanan.id) : jumlah}",
                        style: TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
              if (isCart)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Hapus Item'),
                          content: Text('Anda yakin ingin menghapus item ini?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<CartItemProvider>(context,
                                        listen: false)
                                    .removeItem(makanan.id);
                                Navigator.of(context).pop();
                              },
                              child: Text('Hapus'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
