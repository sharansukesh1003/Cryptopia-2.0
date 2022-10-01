import 'package:flutter/material.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';
import 'package:provider_cryptopia/services/cryptoapi.dart';

class CryptoDataProvider with ChangeNotifier {
  List<CryptoModel> _list = [];

  List<CryptoModel> _topGainersList = [];

  List<CryptoModel> _topLosersList = [];

  List<CryptoModel> get list => _list;

  List<CryptoModel> get topGainersList => _topGainersList;

  List<CryptoModel> get topLosersList => _topLosersList;

  void getTopGainers() {
    if (_topGainersList.isEmpty) {
      _topGainersList = [..._list];
    }
    for (int i = 0; i < _topGainersList.length - 1; i++) {
      for (int j = 0; j < _topGainersList.length - i - 1; j++) {
        if (_topGainersList[j].priceChangePercentage24h <
            _topGainersList[j + 1].priceChangePercentage24h) {
          CryptoModel temp = _topGainersList[j];
          _topGainersList[j] = _topGainersList[j + 1];
          _topGainersList[j + 1] = temp;
        }
      }
    }
  }

  void getTopLosers() {
    if (_topLosersList.isEmpty) {
      _topLosersList = [..._list];
    }
    for (int i = 0; i < _topLosersList.length - 1; i++) {
      for (int j = 0; j < _topLosersList.length - i - 1; j++) {
        if (_topLosersList[j].priceChangePercentage24h >
            _topLosersList[j + 1].priceChangePercentage24h) {
          CryptoModel temp = _topLosersList[j];
          _topLosersList[j] = _topLosersList[j + 1];
          _topLosersList[j + 1] = temp;
        }
      }
    }
  }

  getCryptoData() async {
    _list = await CryptoAPI.getCryptoData();
    notifyListeners();
  }

  Stream<List<CryptoModel>> getStreamCryptoData() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 30), (() async {
        _list = await CryptoAPI.getCryptoData();
        notifyListeners();
      }));
      yield _list;
    }
  }

  Future<List<CryptoModel>> getFavoriteCryptoData() async {
    _list = await CryptoAPI.getCryptoData();
    notifyListeners();
    return _list;
  }
}
