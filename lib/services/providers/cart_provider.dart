import 'package:flutter/material.dart';
import 'package:nusantara/models/makanan.dart';
import 'package:nusantara/models/pesanan.dart';
import 'package:provider/provider.dart';

class CartItemProvider extends ChangeNotifier {
  List<PesananItem> _pesananItems = [];

  List<PesananItem> get orderItems => _pesananItems;

  void addItem(PesananItem pesananItem) async {
    bool found = false;
    for (var orderItem in _pesananItems) {
      if (orderItem.makanan.id == pesananItem.makanan.id) {
        orderItem.jumlah =
            "${int.parse(pesananItem.jumlah) + int.parse(orderItem.jumlah)}";
        found = true;
        break;
      }
    }

    if (!found) {
      _pesananItems.add(pesananItem);
    }

    notifyListeners();
  }

  void removeItem(int makananId) {
    _pesananItems.removeWhere((item) => item.makanan.id == makananId);
    notifyListeners();
  }

  void increaseQuantity(int makananId) {
    for (var item in _pesananItems) {
      if (item.makanan.id == makananId) {
        item.jumlah = (int.parse(item.jumlah) + 1).toString();
        break;
      }
    }
    notifyListeners();
  }

  void decreaseQuantity(int makananId) {
    for (var item in _pesananItems) {
      if (item.makanan.id == makananId && int.parse(item.jumlah) > 1) {
        item.jumlah = (int.parse(item.jumlah) - 1).toString();
        break;
      }
    }
    _pesananItems.removeWhere(
        (item) => item.makanan.id == makananId && int.parse(item.jumlah) == 0);
    notifyListeners();
  }

  String totalItem(int makananId) {
    final item = _pesananItems.firstWhere(
        (item) => item.makanan.id == makananId,
        orElse: () => PesananItem(
            makanan: Makanan(
                id: 0,
                nama: '',
                deskripsi: '',
                harga: '',
                gambar: '',
                stok: '',
                kategori: '',
                daerah: ''),
            jumlah: '0'));
    return item.jumlah;
  }

  int totalPrice() {
    int myTotal = 0;
    for (PesananItem element in _pesananItems) {
      myTotal += int.parse(element.makanan.harga) * int.parse(element.jumlah);
    }
    return myTotal;
  }

  void clearItems() {
    orderItems.clear();
    notifyListeners();
  }

  static CartItemProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartItemProvider>(
      context,
      listen: listen,
    );
  }
}
