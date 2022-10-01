import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider_cryptopia/models/cryptomodel.dart';

const url =
    "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=1000&page=1&sparkLine=false";

class CryptoAPI {
  static Future<List<CryptoModel>> getCryptoData() async {
    // print('called');
    List<CryptoModel> cryptoList = [];
    await http.get(Uri.parse(url)).then((res) => {
          json.decode(res.body).forEach((element) {
            cryptoList.add(
              CryptoModel(
                name: element['name'],
                symbol: element['symbol'],
                image: element['image'],
                price: element['current_price'] ?? 0.00,
                priceChangePercentage24h:
                    element['price_change_percentage_24h'] ?? 0.00,
              ),
            );
          })
        });
    return cryptoList;
  }
}
