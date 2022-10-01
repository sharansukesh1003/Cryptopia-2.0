class CryptoModel {
  String name, symbol, image;
  num price, priceChangePercentage24h;
  static CryptoModel defaultVal = CryptoModel(
      name: 'bitcoin',
      symbol: 'btc',
      image: '',
      price: 10000,
      priceChangePercentage24h: 5.6);
  CryptoModel({
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.priceChangePercentage24h,
  });
}
