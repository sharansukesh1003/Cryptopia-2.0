import 'package:flutter/material.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';
import 'package:provider_cryptopia/models/portfoliomodel.dart';

class ProtfolioCryptoProvider with ChangeNotifier {
  final List<PortfolioModel> _portfolio = [];

  bool _isLoaded = false;

  updateIsLoaded() {
    _isLoaded = true;
    notifyListeners();
  }

  bool cryptoListContains(String symbol) {
    for (var i = 0; i < _portfolio.length; i++) {
      if (_portfolio[i].symbol == symbol) return true;
    }
    return false;
  }

  List<PortfolioModel> get portfolio => _portfolio;

  bool get isLoaded => _isLoaded;

  void addToPortfolio(String name, String symbol, String image, num price,
      num priceChangePercentage24h, num currentPrice) {
    _portfolio.add(
      PortfolioModel(
        name: name,
        image: image,
        symbol: symbol,
        buyPrice: price,
        currentPrice: currentPrice,
        priceChangePercentage24h: priceChangePercentage24h,
      ),
    );
    notifyListeners();
  }

  void removeFromPortfolio(String symbol) {
    for (var i = 0; i < _portfolio.length; i++) {
      if (_portfolio[i].symbol == symbol) {
        _portfolio.removeAt(i);
      }
    }
    notifyListeners();
  }

  checkIfValueChange(List<CryptoModel> list) {
    for (var i = 0; i < _portfolio.length; i++) {
      for (var j = 0; j < list.length; j++) {
        if (_portfolio[i].symbol == list[j].symbol) {
          _portfolio[i].currentPrice = list[j].price;
          _portfolio[i].priceChangePercentage24h =
              list[j].priceChangePercentage24h;
        }
      }
    }
    notifyListeners();
  }
}
