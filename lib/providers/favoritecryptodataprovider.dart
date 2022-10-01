import 'package:flutter/material.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';

class FavoriteCryptoProvider with ChangeNotifier {
  final List<CryptoModel> _cryptoList = [];

  bool cryptoListContains(String symbol) {
    for (var i = 0; i < _cryptoList.length; i++) {
      if (_cryptoList[i].symbol == symbol) return true;
    }
    return false;
  }

  List<CryptoModel> get cryptoList => _cryptoList.reversed.toList();

  void addCrypto(String name, String symbol, String image, num price,
      num priceChangePercentage24h) {
    _cryptoList.add(
      CryptoModel(
        name: name,
        symbol: symbol,
        image: image,
        price: price,
        priceChangePercentage24h: priceChangePercentage24h,
      ),
    );
    notifyListeners();
  }

  void removeCrypto(String symbol) {
    for (var i = 0; i < _cryptoList.length; i++) {
      if (_cryptoList[i].symbol == symbol) {
        _cryptoList.removeAt(i);
      }
    }
    notifyListeners();
  }

  checkIfValueChange(List<CryptoModel> list) {
    for (var i = 0; i < _cryptoList.length; i++) {
      for (var j = 0; j < list.length; j++) {
        if (_cryptoList[i].symbol == list[j].symbol) {
          _cryptoList[i].price = list[j].price;
          _cryptoList[i].priceChangePercentage24h =
              list[j].priceChangePercentage24h;
        }
      }
    }
    notifyListeners();
  }
}
